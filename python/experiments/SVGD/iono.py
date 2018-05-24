from time import time

import numpy as np
from scipy.stats import multivariate_normal

from experiments.lnpdfs.create_target_lnpfs import build_GPR_iono_with_grad_lnpdf
from sampler.SVGD.python.svgd import SVGD as SVGD

num_dimensions = 34

tmp_lnpdf = build_GPR_iono_with_grad_lnpdf(True)
def dlnpdf(theta):
    input = np.atleast_2d(theta)
    output = []
    for i in range(len(input)):
      output.append(tmp_lnpdf(input[i])[1])
    dlnpdf.counter += len(input)
    return output

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
    sample(100, 100, 1e-2, "/tmp/svgd_test")

