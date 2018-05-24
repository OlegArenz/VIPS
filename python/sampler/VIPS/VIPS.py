from time import time

import numpy as np

from cppWrapper.VIPS_PythonWrapper import VIPS_PythonWrapper
from cppWrapper.MMD import MMD
from sampler.VIPS.LearningProgress import LearningProgress
import os

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
        self.max_exploration_gain = self.config.LTS['initial_max_exploration_gain']
        self.decrease_rate_for_exploration_gain = self.config.LTS['decrease_rate_for_exploration_gain']
        self.min_component_weight = self.config.LTS['min_components_weight']
        self.new_samples_per_iter = self.config.LTS['num_samples_per_iteration']
        self.em_iterations = self.config.LTS['iterations_for_mixture_updates']
        self.max_components = self.config.LTS['max_components']
        self.sample_reuse_factor = self.config.LTS['sample_reuse_factor']

        self.comp_kl_bound_max = self.config.COMPONENT_OPTIMIZATION['epsilon']
        self.comp_kl_bound_fact = self.config.COMPONENT_OPTIMIZATION['upper_kl_bound_fac']
        self.ridge_for_MORE = self.config.COMPONENT_OPTIMIZATION['ridge_for_MORE']
        self.max_active_samples = self.config.COMPONENT_OPTIMIZATION['max_active_samples']
        self.weight_kl_bound = self.config.WEIGHT_OPTIMIZATION['epsilon']
        self.dont_learn_correlations = self.config.COMPONENT_OPTIMIZATION['no_correlations']

        self.update_plots = self.config.FUNCTIONS['plot_fctn']
        self.plot_rate = self.config.PLOTTING['rate']



    def __init__(self, num_dimensions, target_lnpdf, initial_mixture, config, groundtruth_samples=None, groundtruth_lnpdfs=None):
        self.initialize_from_config(config)
        self.target_lnpdf = target_lnpdf
        self.groundtruth_samples = groundtruth_samples
        self.groundtruth_likelihoods = groundtruth_lnpdfs
        self.num_dimensions = num_dimensions
        self.vips_c = VIPS_PythonWrapper(num_dimensions, self.config.COMMON['num_threads'])
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
        for i in range(0, self.outer_iterations):
            num_components = len(self.vips_c.get_weights()[0])
            adding_components_start = time()
            # add and delete components
            if (self.new_comps_to_add >= 0) and (i % self.comp_adding_rate == 0) \
                    and i > 0 and num_components < self.max_components:
                    max_exploration_gain = np.exp(-self.decrease_rate_for_exploration_gain*i) * self.max_exploration_gain
                    max_exploration_gain = np.maximum(10, max_exploration_gain)
                    self.vips_c.promote_samples_to_components(self.new_comps_to_add,
                                                             max_exploration_gain, 0,
                                                             False, 1000000)
            self.vips_c.delete_low_weight_components(self.min_component_weight)

            sampling_start = time()
            # draw new samples
            if (self.new_samples_per_iter > 0):
                num_components = self.vips_c.get_num_components()
                weights = np.ones(num_components)/num_components
                [new_samples, used_components] = self.vips_c.draw_samples_weights(
                    self.num_dimensions * num_components * self.new_samples_per_iter, weights)
                new_target_densities = np.nan_to_num(self.target_lnpdf(new_samples))
                self.vips_c.add_samples(new_samples, used_components, new_target_densities)
                self.progress.add_feval(len(new_target_densities))
            sampling_end = time()

            # select active samples
            self.vips_c.activate_newest_samples(self.sample_reuse_factor * len(used_components))

            print("----------------------------")
            print("adding components took " + "%0.6f" % (sampling_start - adding_components_start))
            print("sampling  took " + "%0.2f" % (sampling_end - sampling_start))
            print("activating samples tool " + "%0.6f" % (time() - sampling_end))
            # EM
            for j in range(0, self.em_iterations):
                self.update_progress(i, j)
                self.vips_c.update_targets_for_KL_bounds(True, True)
                print("----------")
                print('Iteration ( Sampling(EM) ): ' + str(i) + '(' + str(j) + ')')
                print('Samples ( active/total ): ' + str(self.progress.num_samples) + '/' + str(
                    self.progress.num_samples_total))
                print('Number of components: ' + str(int(self.progress.num_components[-1])))

                before_weight_update = time()
                self.vips_c.update_weights(self.weight_kl_bound, 0, 0)
                after_weight_update = time()

                self.vips_c.apply_lower_bound_on_weights(1e-30 * np.ones(self.vips_c.get_num_components()))

                self.vips_c.update_components(self.comp_kl_bound_max,
                                             self.comp_kl_bound_fact, 0,
                                             self.ridge_for_MORE,
                                             1000,
                                             self.max_active_samples,
                                             self.dont_learn_correlations)
                after_component_update = time()

                print("updating weights took " + "%0.2f" % (after_weight_update - before_weight_update))
                print("updating components took " + "%0.2f" % (after_component_update - after_weight_update))

                self.dump_gmm(i)
                self.do_plots(i, j)

        if self.progress_rate > 0:
            np.savez(self.progress_path + "result",
                     progress=self.progress)
        print("done")

    def add_initial_components(self, initial_mixture):
        initial_means = initial_mixture.get_numpy_means()
        initial_covs = initial_mixture.get_numpy_covs()
        initial_weights = np.ones(initial_mixture.num_components) / initial_mixture.num_components
        self.vips_c.add_components(initial_weights, initial_means, initial_covs)
        target_densities = np.empty(initial_mixture.num_components)
        for i in range(0, initial_mixture.num_components):
            target_densities[i] = np.nan_to_num(self.target_lnpdf(initial_means[i]))
        component_indices = np.arange(0, initial_mixture.num_components, dtype=np.int32)
        self.vips_c.add_samples(initial_means, component_indices, target_densities)

    def draw_initial_samples(self):
        if self.num_initial_samples > 0:
            [initial_samples, used_components] = self.vips_c.draw_samples(self.num_initial_samples, 1.0)
            new_target_densities = np.nan_to_num(self.target_lnpdf(initial_samples))
            self.vips_c.add_samples(initial_samples, used_components, new_target_densities)

    def initialize_mmd(self):
        if self.groundtruth_samples is not None:
            self.mmd = MMD(self.groundtruth_samples)
            self.mmd.set_kernel(self.mmd_alpha)
            if self.groundtruth_likelihoods is None:
                self.groundtruth_likelihoods = np.array([self.target_lnpdf(sample) for sample in self.groundtruth_samples]).reshape(-1)
            self.progress.set_groundtruth_likelihoods(self.groundtruth_likelihoods)
        else:
            self.mmd = None

    def update_progress(self, sampling_iteration, EM_iteration):
        self.progress.add_mixture_entropy(self.vips_c.get_entropy_estimate_on_active_samples())
        [self.progress.num_samples, self.progress.num_samples_total] = self.vips_c.get_num_samples()
        # add timestamp
        self.progress.add_timestamp(time())
        # add KLs
        [KL_weights, KLs_components] = self.vips_c.get_last_KLs()
        self.progress.add_KL_weights(KL_weights)
        self.progress.add_KL_components(KLs_components)
        # add weights
        [weights, _] = self.vips_c.get_weights()
        self.progress.add_weights(weights)
        # add expected rewards and expected target_densities
        [expected_rewards, expected_target_densities, comp_etd_history, comp_reward_history] = self.vips_c.get_expected_rewards()
        self.progress.add_expected_rewards(expected_rewards)
        self.progress.add_expected_target_densities(expected_target_densities)
        self.progress.comp_reward_history = comp_etd_history
        # add number of components
        self.progress.add_num_components(int(len(weights)))
        # add mixture densities on groundtruth
        if self.groundtruth_samples is not None:
            densities_on_gt = self.vips_c.get_log_densities_on_mixture(self.groundtruth_samples)
            self.progress.add_learned_densities_on_gt(densities_on_gt)
            if ((self.mmd_rate > 0)
                and ((sampling_iteration * self.em_iterations + EM_iteration + 1) % self.mmd_rate == 0)):
                mmd = 0
                for i in range(self.config.COMMON['num_mmd_evals']):
                    test_samples = self.vips_c.draw_samples(2000, 1)[0]
                    mmd += self.mmd.compute_MMD_gt(test_samples, True)
                self.progress.add_mmd(mmd / self.config.COMMON['num_mmd_evals'])

    def dump_gmm(self, i):
        if self.path_for_gmm_dumps is not None and i % self.rate_for_gmm_dumps == 0:
            [weights, means, covs] = self.vips_c.get_model()
            self.gmm_dump_timesteps.append(time() - self.start)
            np.savez(self.path_for_gmm_dumps + 'gmm_dump_' + str(i), weights=weights, means=means, covs=covs,
                     timestamps=self.gmm_dump_timesteps, fevals=np.sum(self.progress.num_feval))

    def do_plots(self, sampling_iteration, EM_iteration):
        if self.plot_rate > 0 and ((self.update_plots is not None)
                and ((sampling_iteration * self.em_iterations + EM_iteration) % self.plot_rate == 0)):
            self.update_plots(self)



