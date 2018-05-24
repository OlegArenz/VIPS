import os
import numpy as np

from python.cppWrapper.MMD import MMD

class FriskEvaluator:
    def __init__(self, mmd_alpha):
        self.alpha = mmd_alpha
        self.groundtruth = np.load("../groundtruth/frisk/10ksamples_burned4M_thinned120k.npy")
        self.mmd = MMD(self.groundtruth)
        self.mmd.set_kernel(self.alpha)


    def compute_MMD_frisk_vboost(self, basepath):
        mmds = []
        time_stamps = []
        n_fevals = []
        n_comps = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.startswith("vboost") and fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    n_fevals.append(tmp['arr_2'].tolist())
                    samples = np.array(tmp['arr_0'].tolist())
                    this_time_stamps = np.array(tmp['arr_1'].tolist())
                    this_time_stamps -= this_time_stamps[0]
                    time_stamps.append(this_time_stamps[1:])
                    mmds.append(self.mmd.compute_MMD_gt(samples, True))
                    n_comps.append(len(time_stamps[-1]))
        permutation = np.argsort(n_comps)
        n_fevals = np.array(n_fevals)[permutation]
        time_stamps = time_stamps[permutation[-1]]
        mmds = np.array(mmds)[permutation]
        n_comps = np.array(n_comps)[permutation]
        return [n_fevals, time_stamps, mmds, n_comps]

    def compute_MMD_frisk_hmc(self, basepath):
        mmds = []
        time_stamps = []
        n_fevals = []
        n_comps = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = np.array(tmp['samples'].tolist())
                    this_time_stamps = np.array(tmp['wallclocktime'].tolist())
                    time_stamps.append(this_time_stamps)
                    mmds.append(self.mmd.compute_MMD_gt(samples, True))
                    n_comps.append(len(time_stamps[-1]))
        permutation = np.argsort(n_comps)
        n_fevals = np.array(n_fevals)[permutation]
        time_stamps = time_stamps[permutation[-1]]
        mmds = np.array(mmds)[permutation]
        n_comps = np.array(n_comps)[permutation]
        return [n_fevals, time_stamps, mmds, n_comps]

if __name__ == "__main__":
    evaluator = FriskEvaluator(mmd_alpha=100)
   #  [n_fevals, time_stamps, mmds] = evaluator.compute_MMD_frisk_vboost("/home/arenz/Seafile/shared/learnToSample/data/ICML/frisk/vboost/rank1_seed1")
    [n_fevals, time_stamps, mmds] = evaluator.compute_MMD_frisk_hmc("../ICML/frisk/hmc/")
    print("done")