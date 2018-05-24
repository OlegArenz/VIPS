import os

import numpy as np


class AbstractExperiment:
    def __init__(self, experiment_path, num_dimensions):
        self.num_dimensions = num_dimensions
        file_path = os.path.dirname(os.path.realpath(__file__))
        self.data_path = os.path.abspath(os.path.join(file_path, os.pardir, os.pardir, os.pardir)) + "/data/"
        self.experiment_path = os.path.abspath(os.path.join(self.data_path, experiment_path))

    def set_targetlnpdf(self, target_lnpdf):
        self.target_lnpdf = target_lnpdf

    def run_experiment(self):
        raise NotImplementedError("Please Implement this method")

    def obtain_groundtruth(self):
        return [None, None]

    def create_ess_sampler(self, target_lnpdf, prior_chol, prior, num_dimensions):
        def generate_ess_samples(num_ess_samples, initial_sample=None):
            from sampler.ESS import elliptical_slice
            target_lnpdf.counter = 0
            if initial_sample is None:
                cur_theta = prior.rvs(1)
            else:
                cur_theta = initial_sample
            last_lnpdf = target_lnpdf(cur_theta, without_prior=True)
            ess_sample = np.empty((num_ess_samples, num_dimensions))
            likelihoods = np.empty((num_ess_samples))
            target_lnpdf.counter = 0
            for i in range(0, num_ess_samples):
                [cur_theta, last_lnpdf] = elliptical_slice(cur_theta, prior_chol, target_lnpdf, pdf_params=(True,),
                                                           cur_lnpdf=last_lnpdf)
                ess_sample[i] = cur_theta
                likelihoods[i] = last_lnpdf
            return [ess_sample, likelihoods]

        return generate_ess_samples

