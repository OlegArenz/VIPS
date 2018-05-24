import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_german_credit_lnpdf


class German_Credit(AbstractVIPSExperiment):
    def __init__(self, num_initial_components, initial_mixture_prior_variance, config):
        num_dimensions = 25
        filepath = "german_credit/" + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance)
        [self.target_lnpdf, _, _] = build_german_credit_lnpdf()
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

    def obtain_groundtruth(self):
        self.groundtruth_samples = np.load(self.data_path + "groundtruth/german_credit/german_credit10k.npy")
        self.groundtruth_lnpdfs = np.load(self.data_path + "groundtruth/german_credit/german_credit10k_lns.npy")

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)

def run_on_cluster(config_name, path_for_dumps, rate_of_dumps=100, num_threads=1):
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

    experiment = German_Credit(num_initial_components=1, initial_mixture_prior_variance=100, config=config)
    experiment.run_experiment()


if __name__ == '__main__':
    import experiments.VIPS.configs.single_comp as config
    experiment = German_Credit(num_initial_components=1, initial_mixture_prior_variance=100, config=config)
    experiment.obtain_groundtruth()
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()