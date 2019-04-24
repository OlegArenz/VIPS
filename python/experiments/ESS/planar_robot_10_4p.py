from time import time

import numpy as np
import os
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link_4
from sampler.elliptical_slice.bovy_mcmc.elliptical_slice import elliptical_slice as ess_update

num_dimensions = 10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1e0
cart_likelihood_var = np.array([1e-4, 1e-4])

[target_lnpdf, prior, prior_chol] = build_target_likelihood_planar_n_link_4(num_dimensions, conf_likelihood_var, cart_likelihood_var)


def sample(n_samps, path=None):
    if path is not None:
        dirname = os.path.dirname(path)
        if not os.path.exists(dirname):
            os.makedirs(dirname)
    iters = []
    nfevals = []
    target_lnpdf.counter = 0
    start = time()
    timestamps = []
    cur_theta = prior.rvs(1)
    cur_lnpdf = target_lnpdf(cur_theta, without_prior=True)
    all_samples = []
    samples = []
    for i in range(1, n_samps+1):
        [cur_theta, cur_lnpdf] = ess_update(cur_theta, prior_chol, target_lnpdf, pdf_params=(True,),
                                               cur_lnpdf=cur_lnpdf)
        samples.append(cur_theta)
        if i> 1 and i % 1000 == 0:
            all_samples.append(np.array(samples))
            samples = []
            iters.append(i)
            nfevals.append(target_lnpdf.counter)
            timestamps.append(time() - start)
    if path is not None:
        np.savez(path+"processed_data", iter=iters, samples=np.array(all_samples), fevals=np.array(nfevals), timestamps=np.array(timestamps))
    print("done")


if __name__ == '__main__':
    sample(100000)


