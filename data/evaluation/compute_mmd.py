from python.cppWrapper.MMD import MMD
import experiments.GMM as GMM
import numpy as np
import os

class MMD_Evaluator:
    def __init__(self, alpha):
        self.alpha = alpha

def get_processed_data_fnames(basepath):
    files = []
    for dirName, subdirList, fileList in os.walk(basepath):
        for fname in sorted(fileList):
            if fname.endswith('processed_data.npz'):
                files.append(dirName+'/'+fname)
    return files

def get_best_samples(N, samples, ratio, max_burnin):
    max_sample = int(len(samples)*ratio)
    available_samples = samples[:max_sample]
    if len(available_samples) > N+max_burnin:
        available_samples = available_samples[max_burnin:]
        thinning = int(np.floor(len(available_samples) / N))
        return available_samples[::thinning][:N].copy()
    else:
        return available_samples[-N:].copy()

def get_mmds_targetGMM(basepath, alpha, force_recompute=False):
    files = get_processed_data_fnames(basepath)
    for file in files:
        data = np.load(file)
        fevals = data['fevals']
        timestamps = data['timestamps']
        samples = data['samples']
        if "ptmcmc" in file:
            true_means = np.load(os.path.dirname(os.path.abspath(file))+'/true_means.npy')
            true_covs = np.load(os.path.dirname(os.path.abspath(file))+'/true_covs.npy')
        else:
            true_means = data['true_means']
            true_covs = data['true_covs']
        target_mixture = GMM.GMM(true_means.shape[1])
        for mean,cov in zip(true_means,true_covs):
            target_mixture.add_component(mean,cov)
        target_mixture.set_weights(1.0/len(true_means) * np.ones(len(true_means)))
        groundtruth = target_mixture.sample(10000)
        returned_timestamps = []
        returned_fevals = []
        mmds = []
        if force_recompute or not os.path.exists(file[:-4] + '_with_mmd_' + str(alpha) + ".npz"):
            mmd = MMD(groundtruth)
            mmd.set_kernel(alpha)
            print("processing: " + file)
            assert(len(fevals) == len(timestamps))
            assert(len(fevals) == len(samples))

            for i in range(0,len(fevals),np.maximum(1,np.floor(len(fevals)/20.0).astype(np.int32))):
                try:
                    if "svgd" in file or "vboost" in file or "npvi" in file or "vips" in file:
                        my_samples = samples[i]
                    else:
                        my_samples = samples[:i+1].reshape((-1,true_means.shape[1]))
                        if "ptmcmc" in file:
                            my_samples = np.unique(my_samples, axis=0)
                    # ToDo make sure to have enough burnin
                    my_samples = get_best_samples(2000, my_samples, 1, 10000)
                    mmds.append(mmd.compute_MMD_gt(my_samples.copy(), True))
                    returned_fevals.append(fevals[i])
                    returned_timestamps.append(timestamps[i])
                    print("MMD: " + str(mmds[-1]))
                except:
                    print("debug")
            np.savez(file[:-4] + '_with_mmd_' + str(mmd.alpha) + ".npz",
                     timestamps=returned_timestamps, samples=data['samples'], fevals=returned_fevals, mmds=mmds)
        else:
            print("skipping: " + file)

def get_mmds(basepath, mmd, dims, force_recompute=False):
    files = get_processed_data_fnames(basepath)
    for file in files:
        data = np.load(file)
        try:
            fevals = data['fevals']
            timestamps = data['timestamps']
            samples = data['samples']
            returned_timestamps = []
            returned_fevals = []
            mmds = []
            if force_recompute or not os.path.exists(file[:-4] + '_with_mmd_' + str(mmd.alpha) + ".npz"):
                print("processing: " + file)
                assert(len(fevals) == len(timestamps))
                assert(len(fevals) == len(samples))
                for i in range(0,len(fevals),np.maximum(1,np.floor(len(fevals)/20.0).astype(np.int32))):
                    try:
                        if "svgd" in file or "vboost" in file or "npvi" in file or "vips" in file:
                            my_samples = samples[i]
                            burnin = 0
                        else:
                            my_samples = samples[:i+1].reshape((-1,dims))
                            if "ptmcmc" in file:
                                my_samples = np.unique(my_samples, axis=0)
                            burnin = np.maximum(10000, 0.01*len(my_samples))
                        # ToDo make sure to have enough burnin
                        my_samples = get_best_samples(2000, my_samples, 1, burnin)
                        mmds.append(mmd.compute_MMD_gt(my_samples.copy(), True))
                        returned_fevals.append(fevals[i])
                        returned_timestamps.append(timestamps[i])
                        print("MMD: " + str(mmds[-1]))
                    except:
                        print("debug")
                np.savez(file[:-4] + '_with_mmd_' + str(mmd.alpha) + ".npz",
                         timestamps=returned_timestamps, samples=data['samples'], fevals=returned_fevals, mmds=mmds)
            else:
                print("skipping: " + file)
        except:
            print("could not unpickle " + file + " wrong Python version?")
        continue

if __name__ == '__main__':
    threeLink = False
    tenLink = False
    gmm = False
    breast_cancer = False
    german_credit = False
    frisk = True
    iono = False

    if threeLink:
        groundtruth = np.load("../groundtruth/3link/samples_after_10kburnin_1152thinning.npy")
        mmd = MMD(groundtruth)
        mmd.set_kernel(6)
        get_mmds("../ICML/3link/", mmd, groundtruth.shape[1])

    if tenLink:
        data = np.load("../groundtruth/10link/icml_10link_samples_10kof25.6mio.npz")
        groundtruth = np.array(data['arr_0'].tolist())
        mmd = MMD(groundtruth)
        mmd.set_kernel(6)
        get_mmds("../ICML/10link", mmd, groundtruth.shape[1])

    if gmm:
        get_mmds_targetGMM("../ICML/gmm/ptmcmc", 20.0, force_recompute=False)
        get_mmds_targetGMM("../ICML/gmm/ess", 20.0, force_recompute=False)
        get_mmds_targetGMM("../ICML/gmm/vips/run4_MT", 20.0, force_recompute=False)

    if breast_cancer:
        data = np.load("../groundtruth/breast_cancer/breastcancer_gt_with_lns_10k.npz")
        groundtruth = data['groundtruth']
        groundtruth_lnpdfs = data['groundtruth_lns']
        mmd = MMD(groundtruth)
        mmd.set_kernel(20)
        get_mmds("../ICML/breast_cancer/vips", mmd, groundtruth.shape[1])

        get_mmds("../ICML/breast_cancer", mmd, groundtruth.shape[1])

    if german_credit:
        groundtruth = np.load("../groundtruth/german_credit/german_credit10k.npy")
        groundtruth_lnpdfs = np.load("../groundtruth/german_credit/german_credit10k_lns.npy")
        mmd = MMD(groundtruth)
        mmd.set_kernel(20)
        get_mmds("../ICML/german_credit", mmd, groundtruth.shape[1])

    if frisk:
        groundtruth = np.load("../groundtruth/frisk/10ksamples_burned4M_thinned120k.npy")
        mmd = MMD(groundtruth)
        mmd.set_kernel(20)
        get_mmds("../ICML/frisk", mmd, groundtruth.shape[1])

    if iono:
        groundtruth= np.load("../groundtruth/ionosphere/samples_20kOf4.8M_1kburninPerChain.npy")
        mmd = MMD(groundtruth)
        mmd.set_kernel(20)
        get_mmds("../ICML/iono", mmd, groundtruth.shape[1])

    print('done')