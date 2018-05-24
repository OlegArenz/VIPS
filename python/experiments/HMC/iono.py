import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_GPR_iono_with_grad_lnpdf_no_autograd
from pyhmc import hmc


tmp_lnpdf = build_GPR_iono_with_grad_lnpdf_no_autograd()
def lnpdf(theta):
    input = np.atleast_2d(theta)
    output = np.empty((len(input)))
    lnpdf.counter += len(input)
    grad_out = np.empty((len(input),34))
    for i in range(len(input)):
        [val, grad] = tmp_lnpdf(input[i])
        output[i] = val
        grad_out[i,:] = grad
    return np.squeeze(output), np.squeeze(grad_out)
lnpdf.counter = 0

def sample(n_samps, n_steps, epsilon, path):
    start = time()
    samples = hmc(lnpdf, x0=np.random.randn(34), n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
    end = time()
    np.savez(path, samples=samples, wallclocktime=end-start)
    #samples = np.vstack([c[0] for c in chain])
    print("done")

def sample_with_progress(repeats, n_samps, n_steps, epsilon, path=None):
    last = np.random.randn(34)
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

