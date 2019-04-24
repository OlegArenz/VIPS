import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link_4
from plotting.default_plot import default_plots
import matplotlib.pyplot as plt
from plotting.visualize_n_link import visualize_mixture
from experiments.VIPS.configs.ConfigUtils import ConfigUtils

class Planar_N_Link(AbstractVIPSExperiment):
    def __init__(self, num_dimensions, num_initial_components,
                 initial_mixture_prior_variance, cart_likelihood_var, conf_likelihood_var, config):
        self.cart_likelihood_var = cart_likelihood_var
        self.conf_likelihood_var = conf_likelihood_var
        filepath = "planar_n_link/" + str(num_dimensions) + '/' + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance)
        [self.target_lnpdf, self.prior, self.prior_chol] = build_target_likelihood_planar_n_link_4(num_dimensions, conf_likelihood_var, cart_likelihood_var)
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

        # add plot for robot visualization
        def all_plots(sampler):
            plt.figure(100)
            plt.clf()
            [weights, means, _] = sampler.vips_c.get_model()
            visualize_mixture(weights, means)
            default_plots(sampler)
        changes_in_functions = {
            'plot_fctn': all_plots,
        }
        ConfigUtils.merge_FUNCTIONS(config, changes_in_functions)

    def obtain_groundtruth(self):
        self.groundtruth_samples = np.load(self.data_path+'groundtruth/10link_4/samples_10link4_180kof200M.npy')[:,::18,:].reshape((-1,10)).copy()
        self.groundtruth_lnpdfs = np.load(self.data_path+'groundtruth/10link_4/lnpdfs_10link4_180kof200M.npy')[:,::18].flatten().copy()

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)


def run_on_cluster(num_dimensions, config_name, path_for_dumps, rate_of_dumps=100, num_threads=1, num_initial_components=1, outer_iters=1000, old_cov_init=None,  isotropic=None, adding_rate=None, adapt_ridge=None, ridge_coeff=None, fixedKL=None, des_num_eff=None):
    if config_name is 'default':
        import experiments.VIPS.configs.default as config
    elif config_name is 'fast_adding':
        import experiments.VIPS.configs.fast_adding as config
    elif config_name is 'fast_adding_old_reusage':
        import experiments.VIPS.configs.fast_adding_old_reusage as config
    else:
        print("config_name " + config_name + ' not known')
        return

    config.COMMON['num_threads'] = num_threads
    config.COMMON['gmm_dumps_path'] = path_for_dumps
    config.COMMON['gmm_dumps_rate'] = rate_of_dumps
    config.LTS['outer_iterations'] = outer_iters
    config.PLOTTING['rate'] = -1

    if des_num_eff is not None:
        config.LTS['desired_num_eff_samples'] = des_num_eff
    if old_cov_init is not None:
        config.LTS['use_linesearch_for_new_covs'] = not old_cov_init
    if isotropic is not None:
        config.LTS['initialize_new_covs_isotropic'] = isotropic
    if adding_rate is not None:
        config.LTS['component_adding_rate'] = adding_rate
    if adapt_ridge is not None:
        config.COMPONENT_OPTIMIZATION['adapt_ridge_multipliers'] = adapt_ridge
    if ridge_coeff is not None:
        config.COMPONENT_OPTIMIZATION['ridge_for_MORE'] = ridge_coeff
    if fixedKL is not None:
        config.COMPONENT_OPTIMIZATION['max_kl_bound'] = fixedKL
        config.COMPONENT_OPTIMIZATION['min_kl_bound'] = fixedKL

    conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
    conf_likelihood_var[0] = 1e0
    cart_likelihood_var = np.array([1e-4, 1e-4])

    experiment = Planar_N_Link(num_dimensions=num_dimensions,
                            num_initial_components=num_initial_components,
                            initial_mixture_prior_variance=conf_likelihood_var,
                            cart_likelihood_var=cart_likelihood_var,
                            conf_likelihood_var=conf_likelihood_var,
                            config=config)

    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.fast_adding as config

    config.COMMON['mmd_alpha'] = 6
    num_dimensions = 10
    conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
    conf_likelihood_var[0] = 1e0
    cart_likelihood_var = np.array([1e-4, 1e-4])

    experiment = Planar_N_Link(num_dimensions=num_dimensions,
                            num_initial_components=100,
                            initial_mixture_prior_variance=conf_likelihood_var,
                            cart_likelihood_var=cart_likelihood_var,
                            conf_likelihood_var=conf_likelihood_var,
                            config=config)
    experiment.obtain_groundtruth()
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()

    print("Done")