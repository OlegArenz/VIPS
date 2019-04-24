from scipy.stats import multivariate_normal as normal
import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_GPR_iono_lnpdf
from sampler.SliceSampling.slice_sampler import slice_sample

num_dimensions = 35

lnpdf = build_GPR_iono_lnpdf()[0]

prior = normal(np.zeros((num_dimensions)), np.eye((num_dimensions)))
initial = prior.rvs(1)

def sample(n_samps, sigma, path):
    start = time()
    samples = slice_sample(lnpdf, initial, n_samps, sigma * np.ones(num_dimensions), path)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start, n_fevals=lnpdf.counter)

print("done")

