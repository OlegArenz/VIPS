import numpy as np
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_GMM_lnpdf_autograd
from autograd import grad
from pyhmc import hmc

num_dimensions = 20
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1
cart_likelihood_var = np.array([1e-4, 1e-4])

[tmp_lnpdf, true_means, true_covs] = build_GMM_lnpdf_autograd(num_dimensions, 10)
def lnpdf(theta):
    input = np.atleast_2d(theta)
    lnpdf.counter += len(input)
    output = np.empty((len(input)))
    grad_out = np.empty((len(input),num_dimensions))
    for i in range(len(input)):
        output[i] = tmp_lnpdf(input[i])
        grad_out[i,:] = grad(tmp_lnpdf)(input[i])
    return np.squeeze(output), np.squeeze(grad_out)
lnpdf.counter = 0

def sample(n_samps, n_steps, epsilon, path):
    start = time()
    samples = hmc(lnpdf, x0=np.random.randn(num_dimensions), n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
    end = time()
    np.savez(path, samples=samples, true_means=true_means, true_covs=true_covs, wallclocktime=end-start, fevals=lnpdf.counter)
    #samples = np.vstack([c[0] for c in chain])
    print("done")

def sample_with_progress(repeats, n_samps, n_steps, epsilon, path=None):
    last = np.random.randn(num_dimensions)
    timestamps = []
    all_samples = []
    nfevals = []
    start = time()
    for i in range(repeats):
        samples = hmc(lnpdf, x0=last, n_samples=int(n_samps), n_steps=n_steps, epsilon=epsilon)
        last = samples[-1]
        nfevals.append(lnpdf.counter)
        all_samples.append(samples)
        if path is not None:
            np.savez(path+'_iter'+str(i), true_means=true_means, true_covs=true_covs, samples=last, timestamps=timestamps, nfevals=nfevals)
        timestamps.append(time()-start)
    if path is not None:
        np.savez(path, samples=np.array(all_samples), true_means=true_means, true_covs=true_covs, timestamps=np.array(timestamps), fevals=np.array(nfevals))

if __name__ == '__main__':
    sample_with_progress(10, 100, 1, 1e-3)

