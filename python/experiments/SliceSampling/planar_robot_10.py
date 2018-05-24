from scipy.stats import multivariate_normal as normal
import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link
from sampler.SliceSampling.slice_sampler import slice_sample

num_dimensions = 10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1
cart_likelihood_var = np.array([1e-4, 1e-4])

lnpdf = build_target_likelihood_planar_n_link(num_dimensions, conf_likelihood_var, cart_likelihood_var)[0]

prior = normal(np.zeros((num_dimensions)), conf_likelihood_var * np.eye((num_dimensions)))
initial = prior.rvs(1)

def sample(n_samps, sigma, path):
    start = time()
    [samples, fevals, timestamps] = slice_sample(lnpdf, initial, n_samps, sigma * np.ones(num_dimensions))
    timestamps -= start
    samples = samples.transpose().reshape(len(timestamps),-1,num_dimensions).copy()
    np.savez(path + 'processed_data', samples=samples, fevals=fevals, timestamps = timestamps)

sample(100, 0.1, "slice_test")
print("done")

