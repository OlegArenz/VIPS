import os
import numpy as np
from plotting.visualize_n_link import visualize_mixture
import matplotlib.pyplot as plt
from scipy.stats import multivariate_normal as normal
from experiments.GMM import GMM as GMM

def process_ess(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        all_time_stamps = []
        fnames = []
        all_samples = []
        all_fevals = []
        for fname in sorted(fileList):
            if not force_recompute and os.path.exists(dirName+'/'+fname+'_processed_data'+ ".npz"):
                print("data was already processed " + dirName)
                continue
            else:
                print("processing: " + fname)
            if '_processed_data' not in fname and fname.endswith(".npz"):
                tmp = np.load(dirName + '/' + fname)
                samples = np.array(tmp['samples'].tolist()).reshape(1,-1,samples.shape[-1])
                all_samples.append(samples)
                timestamps = np.array(tmp['timestamps'].tolist())
                timestamps = timestamps[1:] - timestamps[0]
                all_time_stamps.append(timestamps)
                fnames.append(fname)
                fevals = tmp['nfevals']
                all_fevals.append(fevals)
                np.savez(dirName+'/'+fname+'_processed_data', samples= samples, timestamps=timestamps, fnames=[fname], fevals=fevals)
    return

def process_vips(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        if os.path.exists(dirName+"/processed_data.npz") and not force_recompute:
            print("data was already processed " + dirName)
            continue

        timestamps = []
        fnames = []
        fevals = []
        samples = []
        fileFound = False
        for fname in sorted(fileList):
            if not force_recompute and os.path.exists(dirName+'/'+fname+'_processed_data'+ ".npz"):
                print("data was already processed " + fname)
                continue
            if not fileFound:
                print("processing " + dirName)
            fileFound = True
            if '_processed_data' not in fname and fname.endswith(".npz") and "gmm_dump" in fname:
                tmp = np.load(dirName + '/' + fname)
                weights = tmp['weights']
                means = tmp['means']
                covs = tmp['covs']
                mixture = GMM(means.shape[1])
                for mean, cov in zip(means, covs):
                    mixture.add_component(mean, cov)
                mixture.set_weights(weights)
                samples.append(mixture.sample(2000))
                timestamps.append(tmp['timestamps'][-1])
                fnames.append(fname)
                fevals.append(tmp['fevals'])
        if fileFound:
            timestamps = np.hstack(timestamps)
            permutation = np.argsort(timestamps)
            timestamps = timestamps[permutation]
            samples = np.array(samples)[permutation]
            fevals = np.hstack(fevals).astype(np.int32)[permutation]
            fnames = np.array(fnames)[permutation]
            if os.path.exists(dirName+'/target_mixture.npz'):
                target_mixture = np.load(dirName+'/target_mixture.npz')
                np.savez(dirName + '/processed_data', samples=samples, timestamps=timestamps, fnames=fnames,
                         fevals=fevals, true_means=target_mixture['true_means'] , true_covs=target_mixture['true_covs'] )
            else:
                np.savez(dirName+'/processed_data', samples= samples, timestamps=timestamps, fnames=fnames, fevals=fevals)
    return

def process_hmc(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        fnames = []
        all_samples = []
        all_timestamps = []
        all_fevals = []
        for fname in sorted(fileList):
            if not force_recompute and os.path.exists(dirName+'/'+fname[:-4]+'_processed_data'+ ".npz"):
                print("data was already processed " + fname)
                continue
            if 'iter' not in fname and '_processed_data' not in fname and fname.endswith(".npz"):
                print("processing " + fname)
                tmp = np.load(dirName + '/' + fname)
                samples = np.array(tmp['samples'].tolist())
                all_samples.append(samples)
                timestamps = np.array(tmp['timestamps'].tolist())
                timestamps = (timestamps - timestamps[0])[1:]
                all_timestamps.append(timestamps)
                fnames.append(fname)
                fevals = tmp['nfevals']
                all_fevals.append(fevals)
                np.savez(dirName+'/'+fname[:-4]+'_processed_data', samples= samples, timestamps=timestamps, fnames=[fname], fevals=fevals)
            #else:
            #    print("skipping: " + fname)
    return

def process_nuts(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        foundFile = False
        all_timestamps = []
        all_fnames = []
        all_fevals = []
        all_samples = []
        if not force_recompute and os.path.exists(dirName + '/processed_data' + ".npz"):
            print("data was already processed " + dirName)
            continue
        else:
            print("processing: " + dirName)
        for fname in sorted(fileList):
            if '_processed_data' not in fname and fname.endswith(".npz"):
                foundFile = True
                tmp = np.load(dirName + '/' + fname)
                samples = np.array(tmp['samples'].tolist()).reshape((-1,samples.shape[-1]))
                all_samples.append(samples)
                this_time_stamps = np.array(tmp['walltime'].tolist())
                all_fevals.append(np.array(tmp['n_evals'].tolist()))
                all_timestamps.append(this_time_stamps)
                all_fnames.append(fname)
        if foundFile:
            sorted_indices = np.argsort(all_fevals)
            all_fevals = np.hstack(all_fevals)[sorted_indices]
            all_timestamps = np.array(all_timestamps)[sorted_indices][-1]
            all_fnames = np.array(all_fnames)[sorted_indices]
            all_samples = np.array(all_samples)[sorted_indices]
            np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, samples=all_samples, fnames=all_fnames)
    return

def process_vboost(basepath, force_recompute=False):
    import pickle
    for dirName, subdirList, fileList in os.walk(basepath):
        foundFile = False
        all_fevals = []
        all_timestamps = []
        all_samples = []
        all_fnames = []
        all_pickl_fnames = []
        all_pickl_means = []
        if not force_recompute and os.path.exists(dirName + '_processed_data' + ".npz"):
            print("data was already processed " + dirName)
            continue
        else:
            print("processing: " + dirName)
        for fname in sorted(fileList):
            if not 'processed_data' in fname and fname.endswith(".npz"):
                foundFile = True
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
                means = np.empty((len(data),samples.shape[-1]))
                for i in range(0, len(data)):
                    means[i] = data[i][1][:samples.shape[-1]]
                all_pickl_means.append(means)
        if foundFile:
            sorted_indices = np.argsort(all_fevals)
            all_fevals = np.hstack(all_fevals)[sorted_indices]
            all_timestamps = np.array(all_timestamps)[sorted_indices][-1]
            all_timestamps = (all_timestamps - all_timestamps[0])[1:]
            all_fnames = np.array(all_fnames)[sorted_indices]
            all_samples = np.array(all_samples)[sorted_indices]
            all_pickl_means = np.array(all_pickl_means)[sorted_indices]
            np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, samples=all_samples, fnames=all_fnames, means=all_pickl_means)
    return

def process_svgd(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        foundFile = False
        all_timestamps = []
        all_fnames = []
        n_evals = []
        all_samples = []
        true_means = None
        true_covs = None
        if not force_recompute and os.path.exists(dirName + '_processed_data' + ".npz"):
            print("data was already processed " + dirName)
            continue
        else:
            print("processing: " + dirName)
        for fname in sorted(fileList):
            if '_processed_data' not in fname and 'iter' in fname and fname.endswith(".npz"):
                foundFile = True
                tmp = np.load(dirName + '/' + fname)
                samples = tmp['samples']
                all_samples.append(samples)
                this_time_stamps = tmp['timestamp']
                try:
                    n_evals.append(tmp['nfevals'])
                except:
                    print('debug')
                all_timestamps.append(this_time_stamps)
                all_fnames.append(fname)
                if os.path.exists(dirName + '/' + "svgd.npz"):
                    tmp = np.load(dirName + '/' + "svgd.npz")
                    if "true_means" in tmp.keys():
                        true_covs = tmp['true_covs']
                        true_means = tmp['true_means']
            elif 'initial' in fname:
                start = np.load(dirName + '/' + fname)['timestamp']
        if foundFile:
            all_fevals = np.array(n_evals)
            sorted_indices = np.argsort(all_fevals)
            all_fevals = all_fevals[sorted_indices]
            all_timestamps = np.hstack(all_timestamps) - start
            all_timestamps = all_timestamps[sorted_indices]
            all_fnames = np.array(all_fnames)[sorted_indices]
            all_samples = np.array(all_samples)[sorted_indices]
            if true_means is not None:
                np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, samples=all_samples,
                         fnames=all_fnames, true_means=true_means, true_covs=true_covs)
                print("found target gmm")
            else:
                np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, samples=all_samples, fnames=all_fnames)
    return

def process_slice(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        foundFile = False
        all_timestamps = []
        all_fnames = []
        n_evals = []
        all_samples = []
        for fname in sorted(fileList):
            if not force_recompute and os.path.exists(dirName+'/'+fname+'_processed_data'+ ".npz"):
                print("data was already processed " + fname)
                continue
            else:
                print("processing: " + fname)
            if '_processed_data' not in fname and fname.endswith(".npz"):
                foundFile = True
                tmp = np.load(dirName + '/' + fname)
                samples =  np.array(tmp['samples'].tolist()).transpose()
                all_samples.append(samples)
                this_time_stamps = np.array(tmp['wallclocktime'].tolist())
                all_timestamps.append(this_time_stamps)
                all_fnames.append(fname)
                try:
                    n_evals.append(tmp['n_fevals'])
                except:
                    print("debug")
                all_fevals = np.array(n_evals)
                sorted_indices = np.argsort(all_fevals)
                all_fevals = all_fevals[sorted_indices]
                all_timestamps = np.array(all_timestamps)[sorted_indices][-1]
                all_fnames = np.array(all_fnames)[sorted_indices]
                all_samples = np.array(all_samples)[sorted_indices]
                np.savez(dirName + '/' + fname + '_processed_data', fevals=all_fevals, timestamps=all_timestamps, samples=all_samples,
                         fnames=all_fnames)
    return

def process_npvi(basepath, force_recompute=False):
    for dirName, subdirList, fileList in os.walk(basepath):
        all_timestamps = []
        all_fnames = []
        all_fevals = []
        mus = []
        sigmas = []
        all_samples = []
        final_mus = []
        final_covs = []
        true_means = None
        true_covs = None
        found_files = False
        if not force_recompute and os.path.exists(dirName + '_processed_data' + ".npz"):
            print("data was already processed " + dirName)
            continue
        else:
            print("processing: " + dirName)
        for fname in sorted(fileList):
            if '_processed_data' in fname:
                continue
            if 'iter' in fname and fname.endswith(".npz"):
                found_files = True
                tmp = np.load(dirName + '/' + fname)
                if true_means is None and 'true_means' in tmp.keys():
                    true_means = tmp['true_means']
                    true_covs = tmp['true_covs']
                all_fevals.append(tmp['n_feval'])
                this_time_stamps = tmp['timestamps']
                all_timestamps.append(this_time_stamps)
                all_fnames.append(fname)
                mus.append(tmp['mu'])
                sigmas.append(tmp['sigma'])
                samples = []
                for i in range(len(mus[-1])):
                    samples.append(
                        normal(mus[-1][i], sigmas[-1][i] * np.eye(len(mus[-1][i]))).rvs(int(2000 / len(mus[-1]))))
                all_samples.append(np.vstack(samples))
            elif '-comp' in fname:
                tmp = np.load(dirName + '/' + fname)
                final_mus = np.array(tmp['arr_1'].tolist())
                final_covs = [np.eye(len(final_mus[0])) * sigma2 for sigma2 in np.array(tmp['arr_2'].tolist())]
        if found_files:
            all_fevals = np.array(all_fevals)
            sorted_indices = np.argsort(all_fevals)
            all_fevals = all_fevals[sorted_indices]
            all_timestamps = np.array(all_timestamps)[sorted_indices][-1]
            all_timestamps = (all_timestamps - all_timestamps[0])[1:]
            all_fnames = np.array(all_fnames)[sorted_indices]
            all_samples = np.array(all_samples)[sorted_indices]
            if true_means is None:
                np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, fnames=all_fnames,
                    final_mus=final_mus, final_covs=final_covs, mus=mus, sigmas=sigmas, samples=all_samples)
            else:
                np.savez(dirName+'_processed_data', fevals=all_fevals, timestamps=all_timestamps, fnames=all_fnames,
                    final_mus=final_mus, final_covs=final_covs, mus=mus, sigmas=sigmas, samples=all_samples,
                         true_means=true_means, true_covs=true_covs)
    return



def process_path(path, force_recompute=False):
    process_vips(path + 'vips', force_recompute)
    process_vboost(path + 'vboost', force_recompute)
    process_npvi(path + 'npvi', force_recompute)
    process_hmc(path + 'hmc', force_recompute)
    process_svgd(path + 'svgd', force_recompute)

def process_3link(force_recompute=False):
    process_path('../ICML/3link/', force_recompute)

def process_10link(force_recompute=False):
    process_path('../ICML/10link/', force_recompute)

def process_GMM(force_recompute=False):
    process_path('../ICML/gmm/', force_recompute)

def process_frisk(force_recompute=False):
    process_path('../ICML/frisk/', force_recompute)

def process_german_credit(force_recompute=False):
    process_path('../ICML/german_credit/', force_recompute)

def process_breast_cancer(force_recompute=False):
    process_path('../ICML/breast_cancer/', force_recompute)

if __name__ == "__main__":
#    process_npvi("../ICML/breast_cancer/npvi", True)
    process_vboost("/data/icml/learnToSample/data/ICML/10link/vboost/run1/rank10/seed0/", True)
    process_vips("/data/icml/learnToSample/data/ICML/frisk/vips/run3")
    process_vboost("/data/icml/learnToSample/data/ICML/frisk/vboost/run2/", True)
    process_vboost("/data/icml/learnToSample/data/ICML/german_credit/vboost/run1/", True)
    process_svgd("/data/icml/learnToSample/data/ICML/breast_cancer/svgd/run1")
    process_german_credit()
    process_frisk()
    process_breast_cancer()
    process_svgd("../ICML/10link/svgd/run2")
    process_vips("/data/icml/learnToSample/data/ICML/gmm/vips/run4_MT/explorative40_2")
    process_npvi("../ICML/gmm/npvi", True)
   # process_vips('../ICML/gmm/vips', True)
    process_10link()
    process_3link()
    process_german_credit()
    process_breast_cancer()
    process_frisk()
    process_GMM()

    print('wait')
