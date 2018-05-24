from time import time

import numpy as np
from scipy.stats import multivariate_normal as normal
from experiments.lnpdfs.create_target_lnpfs import build_GPR_iono_lnpdf
from sampler.elliptical_slice.bovy_mcmc.elliptical_slice import elliptical_slice as ess_update

num_dimensions = 34
prior_chol = np.eye(num_dimensions)
prior = normal(np.zeros(34), np.eye(num_dimensions))

target_lnpdf = build_GPR_iono_lnpdf()

def sample(n_samps, path=None):
    samples = np.empty((n_samps, num_dimensions))
    likelihoods = np.empty((n_samps))
    iters = []
    nfevals = []
    target_lnpdf.counter = 0
    timestamps = [time()]
    cur_theta = prior.rvs(1)
    cur_lnpdf = target_lnpdf(cur_theta, without_prior=True)
    for i in range(0, n_samps):
        if i % 10000 == 0:
            print('iter' + str(i))
            iters.append(i)
            nfevals.append(target_lnpdf.counter)
            timestamps.append(time())
        [cur_theta, cur_lnpdf] = ess_update(cur_theta, prior_chol, target_lnpdf, pdf_params=(True,),
                                               cur_lnpdf=cur_lnpdf)
        samples[i] = cur_theta
        likelihoods[i] = cur_lnpdf # without prior!

    iters.append(i)
    nfevals.append(target_lnpdf.counter)
    timestamps.append(time())
    if path is not None:
        np.savez(path+"processed_data", iter=iters, samples=np.array(all_samples), fevals=np.array(nfevals), timestamps=np.array(timestamps))
    print("done")


if __name__ == '__main__':
    sample(1000)

