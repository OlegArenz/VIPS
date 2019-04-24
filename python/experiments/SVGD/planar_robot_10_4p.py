from time import time

import numpy as np
from autograd import grad
from scipy.stats import multivariate_normal

from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link_4_autograd
from sampler.SVGD.python.svgd import SVGD as SVGD
import os

num_dimensions = 10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1e0
cart_likelihood_var = np.array([1e-4, 1e-4])

tmp_lnpdf = build_target_likelihood_planar_n_link_4_autograd(num_dimensions, conf_likelihood_var, cart_likelihood_var)
def dlnpdf(theta):
    input = np.atleast_2d(theta)
    dlnpdf.counter += len(input)
    grads = np.empty((len(input),num_dimensions))
    for i in range(len(input)):
        grads[i]= grad(tmp_lnpdf)(input[i])
    return grads

dlnpdf.counter = 0

def sample(n_samps, n_iter, epsilon, path):
    if not os.path.exists(path):
        os.makedirs(path)
    path=path+"/svgd"
    prior = multivariate_normal(np.zeros((num_dimensions)), conf_likelihood_var * np.eye(num_dimensions))
    x0 = prior.rvs(n_samps)
    start = time()
    samples = SVGD().update(x0, dlnpdf, n_iter=n_iter, stepsize=epsilon, path=path)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start, nfevals=dlnpdf.counter)
    print("done")

if __name__ == '__main__':
    sample(1000, 1000, 1e-2, "/tmp/svgd_test")

