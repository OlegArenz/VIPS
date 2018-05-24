import numpy as np
from sampler.PTMCMC.PTMCMCSampler.PTMCMCSampler import PTSampler
from experiments.lnpdfs.create_target_lnpfs import build_target_likelihood_planar_n_link
from time import time
from mpi4py import MPI

num_dimensions = 10
conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
conf_likelihood_var[0] = 1
cart_likelihood_var = np.array([1e-4, 1e-4])

[target_lnpdf, prior, prior_chol] = build_target_likelihood_planar_n_link(num_dimensions, conf_likelihood_var, cart_likelihood_var)

def sample(n, path, known_prior, comm=MPI.COMM_WORLD):
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
    if comm.Get_rank() == 0:
        np.savez(path + '/processed_data', samples=samples, timestamps=timestamps, fevals=n_fevals)
        print("Done")

if __name__ == '__main__':
    sample(100000, './ptmcmcm_10link_default', True)

