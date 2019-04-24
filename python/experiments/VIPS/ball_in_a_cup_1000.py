import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_ball_in_a_cup_lnpdf

from plotting.default_plot import default_plots
import matplotlib.pyplot as plt
from plotting.visualize_n_link import visualize_mixture
from experiments.VIPS.configs.ConfigUtils import ConfigUtils

class Ball_In_a_cup(AbstractVIPSExperiment):
    def __init__(self, num_dimensions, num_initial_components, initial_mixture_prior_variance, config):
        filepath = "biac/" + str(num_dimensions) + '/' + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance)

        self.target_lnpdf = build_ball_in_a_cup_lnpdf()

        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

    def obtain_groundtruth(self):
        print("no groundtruth available for ball in a cup")

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)

def run_on_cluster(num_dimensions, config_name, path_for_dumps, rate_of_dumps=100, num_threads=1):
    if config_name is 'default':
        import experiments.VIPS.configs.default as config
    elif config_name is 'fast_adding':
        import experiments.VIPS.configs.fast_adding as config
    else:
        print("config_name " + config_name + ' not known')
        return

    config.COMMON['num_threads'] = num_threads
    config.COMMON['gmm_dumps_path'] = path_for_dumps
    config.COMMON['gmm_dumps_rate'] = rate_of_dumps
    config.PLOTTING['rate'] = -1

    experiment =  Ball_In_a_cup(num_dimensions=num_dimensions,
                            num_initial_components=1,
                            initial_mixture_prior_variance=1e-1,
                            config=config)

    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.explorative20 as config
    config.COMMON['mmd_alpha'] = 6
  #  num_dimensions = 56
    num_dimensions = 28
    initial_variance = np.power((1/np.repeat(np.linspace(1, 10., int(num_dimensions / 7)).reshape((1, -1)), [7], axis=0).flatten()),2)
    #initial_variance = np.ones(num_dimensions)
    experiment = Ball_In_a_cup(num_dimensions=num_dimensions,
                            num_initial_components=5,
                            initial_mixture_prior_variance=0.1 * initial_variance,
                            config=config)
    experiment.obtain_groundtruth()
    experiment.run_experiment()

    print("Done")