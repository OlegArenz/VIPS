import datetime

import numpy as np
import os
from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_GMM_lnpdf
from sampler.VIPS.VIPS import VIPS


class Target_GMM(AbstractVIPSExperiment):
    def __init__(self, num_dimensions, num_true_components, num_initial_components, initial_mixture_prior_variance, target_gmm_prior_variance, config):
        filepath = "GMM/" + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance)
        [self.target_lnpdf, _, _, self.target_mixture] = build_GMM_lnpdf(num_dimensions, num_true_components, target_gmm_prior_variance)
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config

    def obtain_groundtruth(self, num_samples):
        [self.groundtruth_samples, self.groundtruth_lnpdfs] = self.get_groundtruth(num_samples)

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)

    def run_experiment_VIPS(self, target_lnpdf, config, groundtruth_samples = None, groundtruth_lnpdfs=None):
        self.sampler = VIPS(self.num_dimensions, target_lnpdf, self.initial_mixture, config, groundtruth_samples, groundtruth_lnpdfs)
        self.sampler.target_mixture = self.target_mixture
        self.sampler.learn_sampling()

    def get_groundtruth(self, num_samples):
        self.target_lnpdf.counter = 0
        samples = self.target_mixture.sample(num_samples)
        lnpdfs = self.target_mixture.evaluate(samples, return_log=True)
        return [samples, lnpdfs]


def run_on_cluster(config_name, path_for_dumps, rate_of_dumps=100, num_threads=1, num_dimensions=20, num_initial=1, num_outer=1000, overwrite_delta=None, old_cov_init=None, isotropic=None):
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
    config.LTS['outer_iterations'] = num_outer
    if overwrite_delta is not None:
        config.LTS['max_exploration_gains'] = overwrite_delta
    if old_cov_init is not None:
        config.LTS['use_linesearch_for_new_covs'] = not old_cov_init
    if isotropic is not None:
        config.LTS['initialize_new_covs_isotropic'] = isotropic

    experiment = Target_GMM(num_dimensions=num_dimensions,
                            num_true_components=10,
                            num_initial_components=num_initial,
                            initial_mixture_prior_variance=1e3,
                            target_gmm_prior_variance=1e3,
                            config=config)

    if not os.path.exists(path_for_dumps):
        os.makedirs(path_for_dumps)
    np.savez(path_for_dumps+'target_mixture', true_means=experiment.target_mixture.get_numpy_means(), true_covs=experiment.target_mixture.get_numpy_covs())


    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.default as config
    experiment = Target_GMM(num_dimensions=20,
                            num_true_components=10,
                            num_initial_components=1,
                            initial_mixture_prior_variance=1e3,
                            target_gmm_prior_variance=1e3,
                            config=config)
    experiment.obtain_groundtruth(2000)
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()
    print('done')
