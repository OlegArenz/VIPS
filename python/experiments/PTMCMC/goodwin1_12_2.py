import numpy as np
from sampler.PTMCMC.PTMCMCSampler.PTMCMCSampler import PTSampler
from time import time
from experiments.lnpdfs.create_target_lnpfs import build_Goodwin
from scipy.stats import multivariate_normal as normal_pdf

seed = 1
unknown_params = [1,2] + np.arange(4, 12).tolist()
num_dimensions = len(unknown_params)
initial_var = 1e-1 * np.ones(num_dimensions)

target_lnpdf = build_Goodwin(unknown_params, seed=seed, sigma=np.sqrt(0.2),
                                  parameters=np.array([10., 1.97, 0.46, 0.53,
                                                       0.02878028, 0.13585575, 1.57070286, 0.75737477,
                                                       0.28929913, 1.52671658, 1.26995194, 1.89562767]))


def sample(n, path):
    def lnlikefn(theta):
            lnlikefn.counter += 1
            return target_lnpdf(theta)
    def lnpriorfn(theta):
        return 0

    prior = normal_pdf(np.zeros(num_dimensions), 1e-1 * np.eye(num_dimensions))

    lnlikefn.counter = 0

    print('path: ' + str(path))
    sampler = PTSampler(num_dimensions, lnlikefn, lnpriorfn, np.copy(prior.cov), outDir=path, progressPath=path, progressRate=1000)
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

if __name__ == '__main__':
    sample(5000, './ptmcmcm_goodwin_default')
