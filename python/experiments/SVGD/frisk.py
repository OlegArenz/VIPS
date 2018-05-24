from time import time

import numpy as np
from scipy.stats import multivariate_normal
from autograd import elementwise_grad
from experiments.lnpdfs.create_target_lnpfs import build_frisk_autograd
from sampler.SVGD.python.svgd import SVGD as SVGD

[tmp_lnpdf,_,_,num_dimensions] = build_frisk_autograd()

def dlnpdf(theta):
    input = np.atleast_2d(theta)
    dlnpdf.counter += len(input)
    return np.squeeze(elementwise_grad(tmp_lnpdf)(input))

dlnpdf.counter = 0

def sample(n_samps, n_iter, epsilon, path):
    prior = multivariate_normal(np.zeros((num_dimensions)), np.eye(num_dimensions))
    x0 = prior.rvs(n_samps)
    start = time()
    samples = SVGD().update(x0, dlnpdf, n_iter=n_iter, stepsize=epsilon, path=path)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start, nfevals=dlnpdf.counter)
    print("done")

if __name__ == '__main__':
    sample(100, 100, 1e-2, "/tmp/svgd_frisk_test")

