import numpy as np
from time import time
import os
from experiments.lnpdfs.create_target_lnpfs import build_breast_cancer_lnpdf
from autograd import grad
from pyhmc import hmc

tmp_lnpdf = build_breast_cancer_lnpdf(with_autograd=True)
def lnpdf(theta):
    input = np.atleast_2d(theta)
    lnpdf.counter += len(input)
    output = np.empty((len(input)))
    grad_out = np.empty((len(input),input.shape[1]))
    for i in range(len(input)):
        output[i] = tmp_lnpdf(input[i])
        grad_out[i,:] = grad(tmp_lnpdf)(input[i])
    return np.squeeze(output), np.squeeze(grad_out)
lnpdf.counter = 0

def sample_with_progress(repeats, n_samps, n_steps, epsilon, path=None):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    last = np.random.randn(31)
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
        print('finished iter' + str(i))

    timestamps.append(time())
    if path is not None:
        np.savez(path, samples=all_samples, timestamps=timestamps, nfevals=nfevals)

if __name__ == '__main__':
    sample_with_progress(10, 1000, 10, 1e-3)

