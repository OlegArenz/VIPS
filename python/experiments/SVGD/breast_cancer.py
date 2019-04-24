from time import time
from autograd import elementwise_grad
import numpy as np
from scipy.stats import multivariate_normal
import os

from experiments.lnpdfs.create_target_lnpfs import build_breast_cancer_lnpdf
from sampler.SVGD.python.svgd import SVGD as SVGD
num_dimensions = 31
tmp_lnpdf = build_breast_cancer_lnpdf(with_autograd=True)

def dlnpdf(theta):
    input = np.atleast_2d(theta)
    dlnpdf.counter += len(input)
    return np.squeeze(elementwise_grad(tmp_lnpdf)(input))

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
    sample(100, 100, 1e-2, "/tmp/svgd_breast_cancer_test")

