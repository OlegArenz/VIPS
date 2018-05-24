import os
import numpy as np

from python.cppWrapper.MMD import MMD

class TenLinkEvaluator:
    def __init__(self, mmd_alpha):
        self.alpha = mmd_alpha
        data = np.load("../data/groundtruth/10link/icml_10link_samples_10kof25.6mio.npz")
        self.groundtruth = np.array(data['arr_0'].tolist())
        self.mmd = MMD(self.groundtruth)
        self.mmd.set_kernel(self.alpha)

    def compute_MMD_10link_svgd(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        n_evals = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = tmp['samples']
                    all_samples.append(samples)
                    this_time_stamps = tmp['timestamp']
                    time_stamps.append(this_time_stamps)
                    mmds.append(self.mmd.compute_MMD_gt(samples, True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, n_evals, time_stamps, fnames]

    def compute_MMD_10link_nuts(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        n_evals = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = np.array(tmp['samples'].tolist()).reshape((-1,10))
                    all_samples.append(samples)
                    this_time_stamps = np.array(tmp['walltime'].tolist())
                    n_evals.append(np.array(tmp['n_evals'].tolist()))
                    time_stamps.append(this_time_stamps)
                    mmds.append(self.mmd.compute_MMD_gt(samples[200::].copy(), True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, n_evals, time_stamps, fnames]

    def compute_MMD_10link_hmc(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = np.array(tmp['samples'].tolist())
                    all_samples.append(samples)
                    this_time_stamps = np.array(tmp['wallclocktime'].tolist())
                    time_stamps.append(this_time_stamps)
                    mmds.append(self.mmd.compute_MMD_gt(samples[1000::20,:].copy(), True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, time_stamps, fnames]

    def compute_MMD_10link_slice(self, basepath):
        mmds = []
        time_stamps = []
        fnames = []
        all_samples = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = np.array(tmp['samples'].tolist()).transpose()
                    all_samples.append(samples)
                    this_time_stamps = np.array(tmp['wallclocktime'].tolist())
                    time_stamps.append(this_time_stamps)
                    a = self.mmd.compute_MMD_gt(samples[100000::450].copy(), True)
                    mmds.append(1/10 *
                        self.mmd.compute_MMD_gt(samples[100000::450].copy(), True) +
                                self.mmd.compute_MMD_gt(samples[90000::450].copy(), True) +
                                self.mmd.compute_MMD_gt(samples[80000::450].copy(), True) +
                                self.mmd.compute_MMD_gt(samples[70000::450].copy(), True)+
                                self.mmd.compute_MMD_gt(samples[60000::450].copy(), True)+
                                self.mmd.compute_MMD_gt(samples[50000::450].copy(), True)+
                                self.mmd.compute_MMD_gt(samples[40000::450].copy(), True)+
                                self.mmd.compute_MMD_gt(samples[30000::450].copy(), True)+
                                self.mmd.compute_MMD_gt(samples[20000::450].copy(), True) +
                                self.mmd.compute_MMD_gt(samples[10000::450].copy(), True))
                    fnames.append(fname)
                    print(mmds[-1])
        return [mmds, all_samples, time_stamps, fnames]

    def visualize_vboost_mixtures(self, basepath):
        #from plotting.visualize_n_link import visualize_mixture
        #import matplotlib.pyplot as plt
        import pickle
        all_fevals = []
        all_timestamps = []
        all_samples = []
        all_fnames = []
        all_pickl_fnames = []
        all_pickl_means = []
        for dirName, subdirList, fileList in os.walk(basepath):
            for fname in sorted(fileList):
                if fname.endswith(".npz"):
                    tmp = np.load(dirName + '/' + fname)
                    samples = tmp['arr_0']
                    timestamps = tmp['arr_1']
                    nfevals = tmp['arr_2']
                    all_fevals.append(nfevals)
                    all_timestamps.append(timestamps)
                    all_samples.append(samples)
                    all_fnames.append(fname)
                if fname.endswith(".pkl"):
                    all_pickl_fnames.append(fname)
                    f = open(dirName + '/' + fname)
                    data = pickle.load(f)
                    means = np.empty((len(data),10))
                    for i in range(0, len(data)):
                        means[i] = data[7][1][:10]
                    all_pickl_means.append(means)
                  #  plt.figure()
                 ##   visualize_mixture(np.ones(200), samples[::10])
                  #  plt.title(fname)
        return [all_fevals, all_timestamps, all_samples, all_fnames]



if __name__ == "__main__":
    evaluator =TenLinkEvaluator(mmd_alpha=6)
   #  [n_fevals, time_stamps, mmds] = evaluator.compute_MMD_frisk_vboost("/home/arenz/Seafile/shared/learnToSample/data/ICML/frisk/vboost/rank1_seed1")
    [mmds, samples, time_stamps, fnames] = evaluator.compute_MMD_10link_hmc("../data/icml/10link")
    #[mmds, samples, time_stamps, fnames] = evaluator.compute_MMD_10link_slice("../ICML/10link/slice/Tuning")
    #[mmds, samples, fevals, time_stamps, fnames] = evaluator.compute_MMD_10link_nuts("../ICML/10link/nuts/nuts_samples1k")
    #evaluator.visualize_vboost_mixtures('../data/ICML/10link/vboost/paper')

   # svgd_steps = [0.00001,0.00002,0.00005,0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2,0.5,1,2,5]
   # all_mmds = []
   # all_samples = []
   # all_fnames = []
   # all_timestamps = []
   # for step in svgd_steps:
   #     [mmds, samples, n_evals, time_stamps, fnames] = evaluator.compute_MMD_10link_svgd(
   #         "/data/icml/learnToSample/data/ICML/10link/svgd/run1/step_"+str(step))
   #     all_mmds.append(mmds)
   #     all_samples.append(samples)
   #     all_fnames.append(fnames)
   #     all_timestamps.append(time_stamps)

    print("done")