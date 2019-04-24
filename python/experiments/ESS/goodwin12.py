from time import time

import numpy as np
import os
from sampler.elliptical_slice.bovy_mcmc.elliptical_slice import elliptical_slice as ess_update
from experiments.lnpdfs.create_target_lnpfs import build_Goodwin
from scipy.stats import multivariate_normal as normal_pdf

def sample(n_samps, seed=1, path=None):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    unknown_params = [1,2] + np.arange(4,12).tolist()
    num_dimensions = len(unknown_params)
    target_lnpdf = build_Goodwin(unknown_params, seed=seed, sigma=np.sqrt(0.2),
                                 parameters=np.array([10., 1.97, 0.46, 0.53,
                                                      0.02878028, 0.13585575, 1.57070286, 0.75737477,
                                                      0.28929913, 1.52671658, 1.26995194, 1.89562767]))

    prior = normal_pdf(np.zeros(num_dimensions), 1e1 * np.eye(num_dimensions))
    prior_chol = np.linalg.cholesky(prior.cov)

    iters = []
    nfevals = []
    target_lnpdf.counter = 0
    def target_lnpdf_no_prior(theta):
        return target_lnpdf(theta) - prior.logpdf(theta)

    start = time()
    timestamps = []

    cur_theta = prior.rvs(1)
    cur_lnpdf = target_lnpdf_no_prior(cur_theta)
    all_samples = []
    samples = []
    for i in range(1, n_samps+1):
        [cur_theta, cur_lnpdf] = ess_update(cur_theta, prior_chol, target_lnpdf_no_prior, pdf_params=(),
                                               cur_lnpdf=cur_lnpdf)
        samples.append(cur_theta)
        if i> 1 and i % 1000 == 0:
            all_samples.append(np.array(samples))
            samples = []
            iters.append(i)
            nfevals.append(target_lnpdf.counter)
            timestamps.append(time() - start)
    if path is not None:
        np.savez(path+"processed_data", iter=iters, samples=np.exp(np.array(all_samples)), fevals=np.array(nfevals),
             timestamps=np.array(timestamps))
    print("done")


if __name__ == '__main__':
    sample(1000)

