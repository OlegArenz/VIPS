import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link
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
        [self.target_lnpdf, self.prior, self.prior_chol] = build_target_likelihood_planar_n_link(num_dimensions, conf_likelihood_var, cart_likelihood_var)
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

        # add plot for robot visualization
        def all_plots(sampler):
            default_plots(sampler)
            plt.figure(100)
            plt.clf()
            [weights, means, _] = sampler.vips_c.get_model()
            visualize_mixture(weights, means)
        changes_in_functions = {
            'plot_fctn': all_plots,
        }
        ConfigUtils.merge_FUNCTIONS(config, changes_in_functions)

    def obtain_groundtruth(self):
        if (self.num_dimensions == 10 and np.all(conf_likelihood_var[1:] == 4e-2 * np.ones(self.num_dimensions - 1)) and np.all(
                    cart_likelihood_var == np.array([1e-4, 1e-4]))):
            self.groundtruth_samples = np.array(np.load(self.data_path + "groundtruth/10link/icml_10link_samples_10kof25.6mio.npz")['arr_0'].tolist())
            self.groundtruth_lnpdfs = self.target_lnpdf(self.groundtruth_samples)
        elif (self.num_dimensions == 3 and np.all(conf_likelihood_var[1:] == 4e-2 * np.ones(self.num_dimensions - 1)) and np.all(
                    cart_likelihood_var == np.array([1e-4, 1e-4]))):
            self.groundtruth_samples = np.load(self.data_path + "groundtruth/3link/samples_after_10kburnin_1152thinning.npy")
            self.groundtruth_lnpdfs = self.target_lnpdf(self.groundtruth_samples)

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)


def run_on_cluster(num_dimensions, config_name, path_for_dumps, rate_of_dumps=100, num_threads=1):
    if config_name is 'explorative40':
        import experiments.VIPS.configs.explorative40 as config
    elif config_name is 'explorative5':
        import experiments.VIPS.configs.explorative5 as config
    elif config_name is 'single':
        import experiments.VIPS.configs.single_comp as config
    else:
        print("config_name " + config_name + ' not known')
        return

    config.COMMON['num_threads'] = num_threads
    config.COMMON['gmm_dumps_path'] = path_for_dumps
    config.COMMON['gmm_dumps_rate'] = rate_of_dumps
    config.PLOTTING['rate'] = -1

    conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
    conf_likelihood_var[0] = 1
    cart_likelihood_var = np.array([1e-4, 1e-4])

    experiment = Planar_N_Link(num_dimensions=num_dimensions,
                            num_initial_components=1,
                            initial_mixture_prior_variance=conf_likelihood_var,
                            cart_likelihood_var=cart_likelihood_var,
                            conf_likelihood_var=conf_likelihood_var,
                            config=config)

    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.explorative40 as config

    config.COMMON['mmd_alpha'] = 6
    num_dimensions = 10
    conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
    conf_likelihood_var[0] = 1
    cart_likelihood_var = np.array([1e-4, 1e-4])

    experiment = Planar_N_Link(num_dimensions=num_dimensions,
                            num_initial_components=1,
                            initial_mixture_prior_variance=conf_likelihood_var,
                            cart_likelihood_var=cart_likelihood_var,
                            conf_likelihood_var=conf_likelihood_var,
                            config=config)
    experiment.obtain_groundtruth()
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()

    print("Done")