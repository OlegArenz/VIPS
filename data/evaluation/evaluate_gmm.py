import os
import numpy as np

from experiments.GMM import GMM
from python.cppWrapper.MMD import MMD

class GMMEvaluator:
    def __init__(self, mmd_alpha):
        self.alpha = mmd_alpha

    def sample_from_target(self, means, covs, N=20000):
        self.target_mixture = GMM(20)
        for i in range(len(means)):
            self.target_mixture.add_component(means[i], covs[i])
        return self.target_mixture.sample(N)

    def evaluate_hmc(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = np.array(tmp['samples'].tolist())
                    gt_samples = self.sample_from_target(tmp['true_means'], tmp['true_covs'], N=20000)
                    mmd = MMD(gt_samples)
                    mmd.set_kernel(self.alpha)

                    all_samples.append(samples)
                    this_time_stamps = np.array(tmp['wallclocktime'].tolist())
                    time_stamps.append(this_time_stamps)
                    mmds.append(mmd.compute_MMD_gt(samples[10000::15].copy(), True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, time_stamps, fnames]

    def compute_MMD_gmm_ess(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        n_evals = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith("_2.npz"):
                    tmp = np.load(dirName + '/' + fname)
                    self.mmd = MMD(self.groundtruth)
                    self.mmd.set_kernel(self.alpha)
                    samples = np.array(tmp['samples'].tolist()).reshape((-1,10))
                    all_samples.append(samples)
                    this_time_stamps = np.array(tmp['walltime'].tolist())
                    n_evals.append(np.array(tmp['n_evals'].tolist()))
                    time_stamps.append(this_time_stamps)
                    mmds.append(self.mmd.compute_MMD_gt(samples[200::].copy(), True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, n_evals, time_stamps, fnames]

if __name__ == "__main__":
    evaluator =GMMEvaluator(mmd_alpha=100)
   # [mmds, samples, n_evals, time_stamps, fnames] = evaluator.compute_MMD_gmm_ess("../ICML/gmm/ess/")
    [mmds, samples, time_stamps, fnames] = evaluator.evaluate_hmc("../data/icml/GMM")

    print("done")