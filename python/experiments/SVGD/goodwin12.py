from time import time
import os
import numpy as np
from scipy.stats import multivariate_normal
from experiments.lnpdfs.create_target_lnpfs import build_Goodwin_grad
from sampler.SVGD.python.svgd import SVGD as SVGD

unknown_params = [1, 2] + np.arange(4, 12).tolist()
num_dimensions = len(unknown_params)
seed=1
target_lnpdf = build_Goodwin_grad(unknown_params, seed=seed, sigma=np.sqrt(0.2),
                                  parameters=np.array([10., 1.97, 0.46, 0.53,
                                                       0.02878028, 0.13585575, 1.57070286, 0.75737477,
                                                       0.28929913, 1.52671658, 1.26995194, 1.89562767]))

def dlnpdf(theta):
    input = np.atleast_2d(theta)
    dlnpdf.counter += len(input)
    return target_lnpdf(input)[1]

dlnpdf.counter = 0

def sample(n_samps, n_iter, epsilon, path):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    prior = multivariate_normal(np.zeros((num_dimensions)), np.eye(num_dimensions))
    x0 = prior.rvs(n_samps)
    start = time()
    samples = SVGD().update(x0, dlnpdf, n_iter=n_iter, stepsize=epsilon, path=path)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start, nfevals=dlnpdf.counter)
    print("done")

if __name__ == '__main__':
    sample(100, 100, 1e-2, "/tmp/svgd_frisk_test")

