import numpy as np
from experiments.VIPS.configs.ConfigUtils import ConfigUtils
from scipy.stats import multivariate_normal as normal_pdf

from experiments.GMM import GMM
from experiments.VIPS.abstract_experiment import AbstractExperiment
from sampler.VIPS.VIPS import VIPS


class AbstractVIPSExperiment(AbstractExperiment):
    def __init__(self, filepath, num_dimensions, num_initial_components, initial_mixture_prior_variance):
        AbstractExperiment.__init__(self, filepath, num_dimensions)
        self.initial_mixture = self.construct_initial_mixture(num_dimensions, num_initial_components, initial_mixture_prior_variance)

    def run_experiment_VIPS(self, target_lnpdf, config, groundtruth_samples = None, groundtruth_lnpdfs=None):
        self.sampler = VIPS(self.num_dimensions, target_lnpdf, self.initial_mixture, config, groundtruth_samples, groundtruth_lnpdfs)
        self.sampler.learn_sampling()

    def load_initial_mixture_from_file(self, filename):
        gmm = np.load(filename)
        initial_mixture = GMM(self.num_dimensions)
        num_initial_components = len(gmm['arr_2'])
        for i in range(0, num_initial_components):
            initial_mixture.add_component(gmm['arr_3'][i], gmm['arr_4'][i])
        initial_mixture.set_weights(gmm['arr_2'])
        return initial_mixture

    def construct_initial_mixture(self, num_dimensions, num_initial_components, prior_variance):
        initial_mixture = GMM(num_dimensions)
        prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))

        for i in range(0, num_initial_components):
            # this_mean = prior.rvs()
            if num_initial_components == 1:
                this_mean = np.zeros(num_dimensions)
            else:
                this_mean = prior.rvs()
            this_cov = prior.cov
            initial_mixture.add_component(this_mean, this_cov)
        return initial_mixture

    def enable_progress_logging(self, config, progress_rate):
        ConfigUtils.enable_progress_logging(self.experiment_path, config, progress_rate)


