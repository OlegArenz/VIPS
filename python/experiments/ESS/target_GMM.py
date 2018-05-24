from time import time

import numpy as np
from experiments.lnpdfs.create_target_lnpfs import build_GMM_lnpdf
from sampler.elliptical_slice.bovy_mcmc.elliptical_slice import elliptical_slice as ess_update

num_dimensions = 20

[target_lnpdf, prior, prior_chol, target_mixture] = build_GMM_lnpdf(num_dimensions=num_dimensions, num_true_components=10)

def sample(n_samps, path=None):
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
        np.savez(path+"processed_data", iter=iters, samples=np.array(all_samples), fevals=np.array(nfevals),
             true_means=target_mixture.get_numpy_means(), true_covs=target_mixture.get_numpy_covs(),
             timestamps=np.array(timestamps))
    print("done")


if __name__ == '__main__':
    sample(1000)

