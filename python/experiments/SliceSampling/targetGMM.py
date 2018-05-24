from scipy.stats import multivariate_normal as normal
import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_GMM_lnpdf
from sampler.SliceSampling.slice_sampler import slice_sample

num_dimensions = 20

[lnpdf, prior, prior_chol, target_mixture]  = build_GMM_lnpdf(num_dimensions, 10)

prior = normal(np.zeros((num_dimensions)), 1e3 * np.eye((num_dimensions)))
initial = prior.rvs(1)

def sample(n_samps, sigma, path):
    np.savez(path+'_target', true_means=target_mixture.mixture.get_numpy_means(), true_covs=target_mixture.get_numpy_covs())
    start = time()
    [samples, fevals, timestamps] = slice_sample(lnpdf, initial, n_samps, sigma * np.ones(num_dimensions))
    timestamps -= start
    samples = samples.transpose().reshape(len(timestamps),-1,3).copy()
    np.savez(path+'processed_data', samples=samples, fevals=fevals, timestamps = timestamps, true_means=target_mixture.mixture.get_numpy_means(), true_covs=target_mixture.get_numpy_covs())
