from time import time

import numpy as np

from cppWrapper.VIPS_PythonWrapper import VIPS_PythonWrapper
from cppWrapper.MMD import MMD
from sampler.VIPS.LearningProgress import LearningProgress
from scipy.stats import multivariate_normal as mvn
import os

max_samples_for_residual = int(1e5)
lowest_ll = -10 ** 10

def my_nan_to_num(x):
    x = np.atleast_1d(x)
    x[np.where(np.isnan(x))] = lowest_ll
    x = np.maximum(x,lowest_ll)
    return np.nan_to_num(x)

class VIPS:
    def initialize_from_config(self, config):
        self.config = config

        self.num_mmd_evals = self.config.COMMON['num_mmd_evals']
        self.mmd_alpha = self.config.COMMON['mmd_alpha']
        self.mmd_rate = self.config.COMMON['mmd_rate']
        self.progress_rate = self.config.COMMON['progress_rate']
        self.progress_path = self.config.COMMON['progress_path']
        self.path_for_gmm_dumps = self.config.COMMON['gmm_dumps_path']
        if self.path_for_gmm_dumps is not None and not os.path.exists(self.path_for_gmm_dumps):
            os.makedirs(self.path_for_gmm_dumps)
        self.rate_for_gmm_dumps = self.config.COMMON['gmm_dumps_rate']
        self.gmm_dump_timesteps = []
        self.start = time()

        self.num_initial_samples = self.config.LTS['num_initial_samples']
        self.outer_iterations = self.config.LTS['outer_iterations']
        self.new_comps_to_add = self.config.LTS['new_components_to_add']
        self.comp_adding_rate = self.config.LTS['component_adding_rate']
        self.comp_deletion_rate = self.config.LTS['component_deletion_rate']
        self.exploration_gains = self.config.LTS['max_exploration_gains']
        self.min_component_weight = self.config.LTS['min_components_weight']
        self.new_samples_per_iter = self.config.LTS['num_samples_per_iteration']
        self.em_iterations = self.config.LTS['iterations_for_mixture_updates']
        self.max_components = self.config.LTS['max_components']
        self.sample_reuse_factor = self.config.LTS['sample_reuse_factor']
        self.use_KL_subsampling = self.config.LTS['use_KL_subsampling']
        self.num_reused_samples  = self.config.LTS['num_reused_samples']
        self.desired_num_eff_samples = self.config.LTS['desired_num_eff_samples']
        self.use_linesearch_new_covs = self.config.LTS['use_linesearch_for_new_covs']
        self.initialize_isotropic = self.config.LTS['initialize_new_covs_isotropic']

        self.min_kl_bound = self.config.COMPONENT_OPTIMIZATION['min_kl_bound']
        self.max_kl_bound = self.config.COMPONENT_OPTIMIZATION['max_kl_bound']
        self.ridge_for_MORE = self.config.COMPONENT_OPTIMIZATION['ridge_for_MORE']
        self.adapt_ridge_multipliers = self.config.COMPONENT_OPTIMIZATION['adapt_ridge_multipliers']
        self.max_active_samples = self.config.COMPONENT_OPTIMIZATION['max_active_samples']
        self.weight_kl_bound = self.config.WEIGHT_OPTIMIZATION['epsilon']
        self.dont_learn_correlations = self.config.COMPONENT_OPTIMIZATION['no_correlations']
        self.dont_recompute_densities = (self.em_iterations == 1)
        self.update_plots = self.config.FUNCTIONS['plot_fctn']
        self.plot_rate = self.config.PLOTTING['rate']




    def __init__(self, num_dimensions, target_lnpdf, initial_mixture, config, groundtruth_samples=None, groundtruth_lnpdfs=None):
        self.initialize_from_config(config)
        self.target_lnpdf = target_lnpdf
        self.groundtruth_samples = groundtruth_samples
        self.groundtruth_likelihoods = groundtruth_lnpdfs
        self.num_dimensions = num_dimensions
        self.vips_c = VIPS_PythonWrapper(num_dimensions, self.config.COMMON['num_threads'], self.min_kl_bound, self.max_kl_bound)
        self.progress = LearningProgress(self.num_dimensions)

        self.add_initial_components(initial_mixture)
        self.draw_initial_samples()
        self.initialize_mmd()

        if self.progress_path is not None:
            np.savez(self.progress_path + "/config",
                     configLTS=self.config.LTS,
                     configCOMMON=self.config.COMMON,
                     configCOMPOPT=self.config.COMPONENT_OPTIMIZATION,
                     configWEIGHTOPT=self.config.WEIGHT_OPTIMIZATION,
                     )


    def learn_sampling(self):
        ind=0
        for i in range(0, self.outer_iterations):
            num_components = len(self.vips_c.get_weights()[0])
            adding_components_start = time()
            # Add Components
            if (self.new_comps_to_add >= 0) and (i % self.comp_adding_rate == 0) \
                    and i > 0 and num_components < self.max_components:
                    max_exploration_gain = self.exploration_gains[ind % len(self.exploration_gains)]
                    ind+=1


                    if self.use_linesearch_new_covs:
                        self.vips_c.promote_samples_to_components(self.new_comps_to_add,
                                                                  max_exploration_gain, 0,
                                                                  False, max_samples_for_residual, True,
                                                                  False)
                        added_comps = len(self.vips_c.get_model()[0]) - num_components
                        self.initialize_cov_for_new_comps(added_comps)
                    else:
                        self.vips_c.promote_samples_to_components(self.new_comps_to_add,
                                                                  max_exploration_gain, 0,
                                                                  False, max_samples_for_residual, True,
                                                                  self.initialize_isotropic)

            print("added components")

            # Delete Components
            if self.comp_deletion_rate > 0:
                self.vips_c.delete_low_weight_components(self.min_component_weight, self.comp_deletion_rate)
                num_components = self.vips_c.get_num_components()
                print("deleted components")

            # Draw new samples
            sampling_start = time()

            # Activate old samples based on KL
            if self.use_KL_subsampling:
                samps_per_comp = int(
                    np.minimum(self.num_reused_samples * self.num_dimensions, np.ceil(40000 / num_components)))
                self.n_eff = self.vips_c.select_active_samples(10, samps_per_comp, 1e0)
                self.progress.add_neff(self.n_eff)
                # Sample from each component as many samples as necessary to approximately get a desired number of effective samples
                weights = np.maximum(self.desired_num_eff_samples * self.num_dimensions - np.nan_to_num(self.n_eff), 0)
                num_new_samples = int(np.ceil(np.sum(weights)))
                if np.sum(weights) > 0:
                    weights /= np.sum(weights)
                else:
                    num_new_samples = 0
            else:
                # Sample uniformly from each component
                weights = np.ones(num_components)/num_components
                num_new_samples = self.num_dimensions * num_components * self.new_samples_per_iter
            if num_new_samples != 0:
                [new_samples, used_components] = self.vips_c.draw_samples_weights(num_new_samples, weights)
                new_target_densities = my_nan_to_num(self.target_lnpdf(new_samples))
                self.vips_c.add_samples(new_samples, used_components, new_target_densities)
                self.progress.add_feval(self.target_lnpdf.counter)
            print("Num_new_samples: " + str(num_new_samples))
            sampling_end = time()

            # select active samples
            if self.use_KL_subsampling:
                self.vips_c.activate_newest_samples(num_new_samples, True)
            else:
                self.vips_c.activate_newest_samples(self.sample_reuse_factor * num_new_samples, False)

            print("----------------------------")
            print("adding components took " + "%0.6f" % (sampling_start - adding_components_start))
            print("sampling  took " + "%0.2f" % (sampling_end - sampling_start))
            print("activating samples took " + "%0.6f" % (time() - sampling_end))
            # EM
            for j in range(0, self.em_iterations):
                self.vips_c.update_targets_for_KL_bounds(True, True)
                [num_samples, num_samples_total] = self.vips_c.get_num_samples()
                print("----------")
                print('Iteration ( Sampling(EM) ): ' + str(i) + '(' + str(j) + ')')
                print('Samples ( active/total ): ' + str(num_samples) + '/' + str(
                    num_samples_total))
                print('Number of components: ' + str(int(num_components)))
                before_weight_update = time()

                self.vips_c.update_weights(self.weight_kl_bound, 0, 0, self.weight_kl_bound >= 100)
                self.vips_c.apply_lower_bound_on_weights(1e-30 * np.ones(self.vips_c.get_num_components()))

                after_weight_update = time()
                if i % 10 == 0:
                    self.update_progress(i, 0)
                self.do_plots(i, j)

                before_component_update = time()
                self.vips_c.update_components(0,
                                             self.ridge_for_MORE,
                                             1000,
                                             self.max_active_samples,
                                             self.dont_learn_correlations,
                                             self.dont_recompute_densities,
                                             self.adapt_ridge_multipliers)
                after_component_update = time()

                print("updating weights took " + "%0.2f" % (after_weight_update - before_weight_update))
                print("updating components took " + "%0.2f" % (after_component_update - before_component_update))
                self.dump_gmm(i)

        if self.progress_rate > 0:
            np.savez(self.progress_path + "result",
                     progress=self.progress)
        print("done")

    def initialize_cov_for_new_comps(self, added_comps):
        weights, means, covs = self.vips_c.get_model()
        # target_entropy = float(self.num_dimensions) + np.inner(weights, self.vips_c.get_model_entropies())
        target_entropy = np.inner(weights, self.vips_c.get_model_entropies())

        rescaling_factor = np.exp(1. / self.num_dimensions * (2 * target_entropy - np.log(
            np.linalg.det(2 * 3.1415 * np.exp(1) * np.eye(self.num_dimensions)))))

        for j in np.arange(added_comps, 0, -1):
            # We want to find the best interpolation of covariance matrices between the current one and a spherical one
            this_comp = mvn(means[-j], covs[-j])
            this_spherical = mvn(means[-j], rescaling_factor * np.eye(self.num_dimensions))

            # Sample from both components and evaluate the samples on the target distribution
            current_samps = this_comp.rvs(10 * self.num_dimensions)
            spherical_samps = this_spherical.rvs(10 * self.num_dimensions)
            this_samps = np.vstack((current_samps, spherical_samps))
            interpolated_lnpdfs = my_nan_to_num(self.target_lnpdf(current_samps))
            spherical_lnpdfs = my_nan_to_num(self.target_lnpdf(spherical_samps))

            # Also add these samples to the database
            self.vips_c.add_samples_mean_cov(current_samps, interpolated_lnpdfs, this_comp.mean, this_comp.cov)
            self.vips_c.add_samples_mean_cov(spherical_samps, spherical_lnpdfs, this_spherical.mean, this_spherical.cov)

            # compute the background distribution for importance weighting
            this_targetlnpdfs = np.hstack((interpolated_lnpdfs, spherical_lnpdfs))
            spherical_lnpdfs = this_spherical.logpdf(this_samps)
            thiscomp_lnpdfs = this_comp.logpdf(this_samps)
            bg_lnpdfs = np.vstack((np.log(0.5) + spherical_lnpdfs, np.log(0.5) + thiscomp_lnpdfs))
            maxvals = np.max(bg_lnpdfs, axis=0)
            bg_lnpdfs = bg_lnpdfs - maxvals[np.newaxis, :]
            bg_lnpdfs = maxvals + np.log(np.sum(np.exp(bg_lnpdfs), axis=0))

            # Finding the best interpolation and updating the component is done in c++, based on the provided samples and likelihoods
            self.vips_c.get_best_interpolation(int(len(weights) - j), this_samps, this_targetlnpdfs, bg_lnpdfs,
                                               rescaling_factor)

    def add_initial_components(self, initial_mixture):
        initial_means = initial_mixture.get_numpy_means()
        initial_covs = initial_mixture.get_numpy_covs()
        initial_weights = np.ones(initial_mixture.num_components) / initial_mixture.num_components
        self.vips_c.add_components(initial_weights, initial_means, initial_covs)

    def draw_initial_samples(self):
        if self.num_initial_samples > 0:
            [initial_samples, used_components] = self.vips_c.draw_samples(self.num_initial_samples, 1.0)
            new_target_densities = my_nan_to_num(self.target_lnpdf(initial_samples))
            self.vips_c.add_samples(initial_samples, used_components, new_target_densities)

    def initialize_mmd(self):
        if self.groundtruth_samples is not None:
            self.mmd = MMD(self.groundtruth_samples)
            self.mmd.set_kernel(self.mmd_alpha)
            if self.groundtruth_likelihoods is None:
                self.groundtruth_likelihoods = np.array([my_nan_to_num(self.target_lnpdf(sample)) for sample in self.groundtruth_samples]).reshape(-1)
            self.progress.set_groundtruth_likelihoods(self.groundtruth_likelihoods)
        else:
            self.mmd = None

    def update_progress(self, sampling_iteration, EM_iteration):
        #self.progress.add_mixture_entropy(self.vips_c.get_entropy_estimate_on_active_samples())
        [self.progress.num_samples, self.progress.num_samples_total] = self.vips_c.get_num_samples()
        # add timestamp
        self.progress.add_timestamp(time())
        # add weights
        [weights, _] = self.vips_c.get_weights()
        self.progress.add_weights(weights)
        # add expected rewards and expected target_densities
        [expected_rewards, expected_target_densities, comp_etd_history, comp_reward_history] = self.vips_c.get_expected_rewards()
        self.progress.comp_reward_history = comp_reward_history
        # add number of components
        self.progress.add_num_components(int(len(weights)))
        # add mixture densities on groundtruth
        if self.groundtruth_samples is not None:
            if ((self.mmd_rate > 0)
                and ((sampling_iteration * self.em_iterations) % self.mmd_rate == 0)):
                mmd = 0
                for i in range(self.config.COMMON['num_mmd_evals']):
                    test_samples = self.vips_c.draw_samples(2000, 1)[0]
                    mmd += self.mmd.compute_MMD_gt(test_samples, True)
                print("MMD: " + str(mmd / self.config.COMMON['num_mmd_evals']))
                self.progress.add_mmd(mmd / self.config.COMMON['num_mmd_evals'])

    def dump_gmm(self, i):
        if self.path_for_gmm_dumps is not None and i % self.rate_for_gmm_dumps == 0:
            [weights, means, covs] = self.vips_c.get_model()
            self.gmm_dump_timesteps.append(time() - self.start)
            np.savez(self.path_for_gmm_dumps + 'gmm_dump_' + str(i), weights=weights, means=means, covs=covs,
                     timestamps=self.gmm_dump_timesteps, fevals=self.progress.num_feval[-1], active_samples=self.vips_c.get_debug_info()[9],
                     num_comps=self.progress.num_components, reward_hist=self.progress.comp_reward_history, num_sample_hist=self.vips_c.get_debug_info()[10].T)

    def do_plots(self, sampling_iteration, EM_iteration):
        if self.plot_rate > 0 and ((self.update_plots is not None)
                and ((sampling_iteration * self.em_iterations + EM_iteration) % self.plot_rate == 0)):
            self.update_plots(self)



