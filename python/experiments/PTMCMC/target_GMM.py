import numpy as np
from sampler.PTMCMC.PTMCMCSampler.PTMCMCSampler import PTSampler
from experiments.lnpdfs.create_target_lnpfs import build_GMM_lnpdf
from time import time

num_dimensions = 20

[target_lnpdf, prior, prior_chol, target_mixture] = build_GMM_lnpdf(num_dimensions, 10)

def sample(n, path, known_prior):
    if known_prior:
        def lnlikefn(theta):
            lnlikefn.counter += 1
            return target_lnpdf(theta, without_prior=True)

        def lnpriorfn(theta):
            return prior.logpdf(theta)
    else:
        def lnlikefn(theta):
            lnlikefn.counter += 1
            return target_lnpdf(theta, without_prior=False)

        def lnpriorfn(theta):
            return 0

    lnlikefn.counter = 0

    cov = np.eye(num_dimensions) * 0.1 ** 2
    print('path: ' + str(path))
    sampler = PTSampler(num_dimensions, lnlikefn, lnpriorfn, np.copy(cov), outDir=path, progressPath=path, progressRate=1000)
    p0 = prior.rvs(1)
    start = time()
    sampler.sample(p0, n, burn=2, thin=1, covUpdate=500,
                   SCAMweight=20, AMweight=20, DEweight=20)
    samples = np.loadtxt(path + '/chain_1.0.txt')[:, :-4]
    progress = np.load(path + '/progress.npz')
    timestamps = progress['timestamps']
    timestamps = timestamps - start
    n_fevals = progress['n_fevals']
    samples = samples.reshape(len(n_fevals), -1, num_dimensions)
    #  n_fevals = np.hstack((n_fevals, lnlikefn.counter))
    np.savez(path + '/processed_data', samples=samples, timestamps=timestamps, fevals=n_fevals)
    print("Done")
    np.save(path+'/true_means', target_mixture.get_numpy_means())
    np.save(path+'/true_covs', target_mixture.get_numpy_covs())
    print("Done")

if __name__ == '__main__':
    sample(50000, './ptmcmcm_gmm_default', True)
