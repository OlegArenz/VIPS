import datetime

import numpy as np

from experiments.VIPS.abstract_vips_experiment import AbstractVIPSExperiment
from experiments.lnpdfs.create_target_lnpfs import build_Goodwin

class Goodwin_oscillator(AbstractVIPSExperiment):
    def __init__(self, unknown_params, num_initial_components, initial_mixture_prior_variance, config, seed):
        filepath = "goodwin/" + datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")+'/'
        AbstractVIPSExperiment.__init__(self, filepath, len(unknown_params), num_initial_components, initial_mixture_prior_variance)
        self.target_lnpdf = build_Goodwin(unknown_params, seed=seed, sigma=np.sqrt(0.2),
                                          parameters=np.array([ 10.        ,   1.97      ,   0.46      ,   0.53      ,
                                                                0.02878028,   0.13585575,   1.57070286,   0.75737477,
                                                                0.28929913,   1.52671658,   1.26995194,   1.89562767]))
        self.groundtruth_samples = None
        self.groundtruth_lnpdfs = None
        self.config = config
        self.seed = seed


    def obtain_groundtruth(self):
        if self.seed == 1:
            self.groundtruth_samples = np.load(self.data_path + "groundtruth/goodwin/12/goodwin12_10kof2.56M_samps.npy")
            self.groundtruth_lnpdfs = np.load(self.data_path + "groundtruth/goodwin/12/goodwin12_10kof2.56M_lnpdfs.npy")
        else:
            print("no groundtruth available")

       # self.groundtruth_samples = np.load(self.data_path + "groundtruth/goodwin/samples_gess_goodwin_20k.npy")
       # self.groundtruth_lnpdfs = np.load(self.data_path + "groundtruth/goodwin/lnpdfs_gess_goodwin_20k.npy")

    def run_experiment(self):
        self.run_experiment_VIPS(self.target_lnpdf, self.config, self.groundtruth_samples, self.groundtruth_lnpdfs)


def run_on_cluster(config_name, path_for_dumps, seed=1, rate_of_dumps=100, num_threads=1, adding_rate=None, old_cov_init=None,  isotropic=None, adapt_ridge=None, ridge_coeff=None, fixedKL=None, des_num_eff=None):
    if config_name is 'default':
        import experiments.VIPS.configs.default as config
    elif config_name is 'fast_adding':
        import experiments.VIPS.configs.fast_adding as config
    elif config_name is 'oldSampleReusage':
        import experiments.VIPS.configs.oldSampleReusage as config
    else:
        print("config_name " + config_name + ' not known')
        return

    config.COMMON['num_threads'] = num_threads
    config.COMMON['gmm_dumps_path'] = path_for_dumps
    config.COMMON['gmm_dumps_rate'] = rate_of_dumps
    config.PLOTTING['rate'] = -1
    if des_num_eff is not None:
        config.LTS['desired_num_eff_samples'] = des_num_eff
    if adding_rate is not None:
        config.LTS['component_adding_rate'] = adding_rate
    if old_cov_init is not None:
        config.LTS['use_linesearch_for_new_covs'] = not old_cov_init
    if isotropic is not None:
        config.LTS['initialize_new_covs_isotropic'] = isotropic
    if adapt_ridge is not None:
        config.COMPONENT_OPTIMIZATION['adapt_ridge_multipliers'] = adapt_ridge
    if ridge_coeff is not None:
        config.COMPONENT_OPTIMIZATION['ridge_for_MORE'] = ridge_coeff
    if fixedKL is not None:
        config.COMPONENT_OPTIMIZATION['max_kl_bound'] = fixedKL
        config.COMPONENT_OPTIMIZATION['min_kl_bound'] = fixedKL

    unknown_params = [1,2] + np.arange(4,12).tolist()
    num_dimensions = len(unknown_params)
    initial_var = 1e-1 * np.ones(num_dimensions)
    experiment = Goodwin_oscillator(unknown_params=unknown_params, num_initial_components=1,
                            initial_mixture_prior_variance=initial_var,
                            config=config, seed=seed)

    experiment.run_experiment()

if __name__ == '__main__':
    import experiments.VIPS.configs.default as config
    config.COMMON['mmd_alpha'] = 20
    unknown_params = [1,2] + np.arange(4,12).tolist()
   # unknown_params = np.arange(1,20).tolist()
    num_dimensions = len(unknown_params)
    initial_var = 1e-1 * np.ones(num_dimensions)

    experiment = Goodwin_oscillator(unknown_params=unknown_params, num_initial_components=1,
                            initial_mixture_prior_variance=initial_var,
                            config=config, seed=1)

    experiment.obtain_groundtruth()
    experiment.enable_progress_logging(config, 5)
    experiment.run_experiment()

    print("Done")