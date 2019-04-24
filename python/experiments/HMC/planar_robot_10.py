import numpy as np
import os
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_autograd
from autograd import elementwise_grad
from pyhmc import hmc

num_dimensions = 10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1
cart_likelihood_var = np.array([1e-4, 1e-4])

tmp_lnpdf = build_target_likelihood_planar_autograd(num_dimensions)[0]
def lnpdf(theta):
    input = np.atleast_2d(theta)
    lnpdf.counter += len(input)
    return np.squeeze(tmp_lnpdf(input)), np.squeeze(elementwise_grad(tmp_lnpdf)(input))
lnpdf.counter = 0

def sample(n_samps, n_steps, epsilon, path):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    start = time()
    samples = hmc(lnpdf, x0=np.random.randn(10), n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start)
    #samples = np.vstack([c[0] for c in chain])
    print("done")

def sample_with_progress(repeats, n_samps, n_steps, epsilon, path=None):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    last = np.random.randn(10)
    timestamps = []
    all_samples = []
    nfevals = []
    start = time()
    for i in range(repeats):
        timestamps.append(time())
        samples = hmc(lnpdf, x0=last, n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
        last = samples[-1]
        nfevals.append(lnpdf.counter)
        all_samples.append(samples)
        if path is not None:
            np.savez(path + '_iter' + str(i), samples=last, timestamps=timestamps, nfevals=nfevals)
        timestamps.append(time() - start)
    if path is not None:
        np.savez(path, samples=np.array(all_samples),   timestamps=np.array(timestamps), fevals=np.array(nfevals))

if __name__ == '__main__':
    sample_with_progress(10, 100, 1, 1e-3)
