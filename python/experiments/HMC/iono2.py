import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_GPR_iono2_with_grad_lnpdf_no_autograd
from pyhmc import hmc
import os
num_dimensions=34
tmp_lnpdf = build_GPR_iono2_with_grad_lnpdf_no_autograd()
def lnpdf(theta):
    input = np.atleast_2d(theta)
    output = np.empty((len(input)))
    lnpdf.counter += len(input)
    grad_out = np.empty((len(input),num_dimensions))
    for i in range(len(input)):
        [val, grad] = tmp_lnpdf(input[i])
        output[i] = val
        grad_out[i,:] = grad
    return np.squeeze(output), np.squeeze(grad_out)
lnpdf.counter = 0

def sample(n_samps, n_steps, epsilon, path):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    start = time()
    samples = hmc(lnpdf, x0=np.random.randn(num_dimensions), n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start)
    #samples = np.vstack([c[0] for c in chain])
    print("done")

def sample_with_progress(repeats, n_samps, n_steps, epsilon, path=None):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    last = np.random.randn(num_dimensions)
    timestamps = []
    all_samples = []
    nfevals = []
    for i in range(repeats):
        timestamps.append(time())
        samples = hmc(lnpdf, x0=last, n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
        last = samples[-1]
        nfevals.append(lnpdf.counter)
        all_samples.append(samples)
        if path is not None:
            np.savez(path+'_iter'+str(i), samples=last, timestamps=timestamps, nfevals=nfevals)

    timestamps.append(time())
    if path is not None:
        np.savez(path, samples=all_samples, timestamps=timestamps, nfevals=nfevals)

if __name__ == '__main__':
    sample_with_progress(10, 100, 1, 1e-3)

