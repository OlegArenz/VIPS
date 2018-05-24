from python.cppWrapper.MMD import MMD
import numpy as np
import os
from experiments.GMM import GMM

class MMD_Evaluator:
    def __init__(self, alpha):
        self.alpha = alpha

    def get_best_samples(self, N, samples, ratio, max_burnin):
        max_sample = int(len(samples)*ratio)
        available_samples = samples[:max_sample]
        if len(available_samples) > N+max_burnin:
            available_samples = available_samples[max_burnin:]
            thinning = int(np.floor(len(available_samples) / N))
            return available_samples[::thinning][:N].copy()
        else:
            return available_samples[-N:].copy()

    def compute_mmds_ptmcmc(self, dir, alpha):
        mmds = []
        means = np.load(dir + 'true_means.npy')
        covs = np.load(dir + 'true_covs.npy')

        target_mixture = GMM(means.shape[1])
        for mean, cov in zip(means, covs):
            target_mixture.add_component(mean, cov)
        groundtruth_samples = target_mixture.sample(20000)
        mmd = MMD(groundtruth_samples)
        mmd.set_kernel(alpha)

        dataFile = dir + 'processed_data.npz'
        data = np.load(dataFile)
        if 'samples' in data.keys():
            samples = data['samples']
            fevals = data['n_fevals']
            timestamps = data['timestamps']
            for i in range(0, len(fevals), 100):
                available_samples = samples[:int(np.floor(len(samples) * (i + 1.) / len(fevals)))]
                available_samples = np.unique(available_samples,axis=0)
                best_samples = self.get_best_samples(2000, available_samples, 1, 1000)
                mmds.append(mmd.compute_MMD_gt(best_samples, True))
                print('n_fevals: ' + str(fevals[i])
                      + ' time: ' + str(timestamps[i])
                      + 'mmd: ' + str(mmds[-1]))
            np.savez(dataFile[:-4]+'with_mmd'+str(alpha), n_fevals=fevals, timestamps=timestamps, mmds=mmds)
        else:
            print(dataFile[-1] + "does not contain samples")

        return [mmds, fevals, timestamps]

if __name__ == '__main__':
    mmd_evaluator = MMD_Evaluator(-1)

    [mmds, fevals, timestamps] = mmd_evaluator.compute_mmds_ptmcmc(
        '/home/oleg/learnToSample/python/ptmcmc_targetGMM_15_10_100k/', 20)

    print('done')