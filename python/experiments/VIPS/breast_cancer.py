import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_breast_cancer_lnpdf


class Breast_Cancer(AbstractVIPSExperiment):
    def __init__(self, num_initial_components, initial_mixture_prior_variance, config):
        num_dimensions = 31
        filepath = "breast_cancer/" + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance)
        [self.target_lnpdf, _, _] = build_breast_cancer_lnpdf()
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

    def obtain_groundtruth(self):
        data = np.load(self.data_path + "groundtruth/breast_cancer/breastcancer_gt_with_lns_10k.npz")
        self.groundtruth_samples = data['groundtruth']
        self.groundtruth_lnpdfs = data['groundtruth_lns']

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)

def run_on_cluster(config_name, path_for_dumps, rate_of_dumps=100, num_threads=1, num_initial=1, adding_rate=None, adapt_ridge=None, ridge_coeff=None, fixedKL=None):
    if config_name is 'default':
        import experiments.VIPS.configs.default as config
    elif config_name is 'fast_adding':
        import experiments.VIPS.configs.fast_adding as config
    elif config_name is 'oldSampleReusage':
        import experiments.VIPS.configs.oldSampleReusage as config
    elif config_name is 'noAddingOrDeletion':
        import experiments.VIPS.configs.noAddingOrDeletion as config
    else:
        print("config_name " + config_name + ' not known')
        return

    config.COMMON['num_threads'] = num_threads
    config.COMMON['gmm_dumps_path'] = path_for_dumps
    config.COMMON['gmm_dumps_rate'] = rate_of_dumps
    config.PLOTTING['rate'] = -1
    if adding_rate is not None:
        config.LTS['component_adding_rate'] = adding_rate
    if adapt_ridge is not None:
        config.COMPONENT_OPTIMIZATION['adapt_ridge_multipliers'] = adapt_ridge
    if ridge_coeff is not None:
        config.COMPONENT_OPTIMIZATION['ridge_for_MORE'] = ridge_coeff
    if fixedKL is not None:
        config.COMPONENT_OPTIMIZATION['max_kl_bound'] = fixedKL
        config.COMPONENT_OPTIMIZATION['min_kl_bound'] = fixedKL

    experiment = Breast_Cancer(num_initial_components=num_initial, initial_mixture_prior_variance=100, config=config)
    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.default as config
    config.COMMON['mmd_alpha'] = 20
    config.PLOTTING['rate'] = 5
    config.COMMON['mmd_rate'] = 5


    experiment = Breast_Cancer(num_initial_components=1, initial_mixture_prior_variance=100, config=config)
    experiment.obtain_groundtruth()
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()