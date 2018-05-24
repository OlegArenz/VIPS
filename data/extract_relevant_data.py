import numpy as np
import os
from scipy.stats import multivariate_normal as normal_pdf

directories = []
progresses = []
results = []
gt_samples = []
targetlnpdfs = []
my_groundtruth_lns = []
log_densities = []
confs = []
final_groundtruth_lns = []
final_learned_lns = []
fevals = []
mmd_hists = []
timestamps = []
gtlns = None
rootDir = '.'
startString = ''
for dirName, subdirList, fileList in os.walk(rootDir):
    for fname in fileList:
        if fname == "result.npz":
            if dirName.startswith(startString):
                tmp = np.load(dirName+'/'+fname)
                results.append(tmp)
                progresses.append(tmp['progress'].tolist())
                directories.append(dirName)
                gt_samples.append(np.asarray(tmp['configCOMMON']).tolist()['groundtruth_samples'])
                confs.append([results[-1]['configLTS'].tolist()['num_samples_per_iteration'],
                             results[-1]['configLTS'].tolist()['max_exploration_gain'],
                              results[-1]['configLTS'].tolist()['new_components_to_add'],
                              results[-1]['configLTS'].tolist()['initial_entropy_coeff'],
                              results[-1]['configLTS'].tolist()['entropy_coeff_dec'],
                              results[-1]['configLTS'].tolist()['outer_iterations'],
                              results[-1]['configCOMPOPT'].tolist()['upper_kl_bound_fac']])
                prior_variance = 4e-2 * np.ones(10)
                prior_variance[0] = 1
                likelihood_variance = np.array([1e-4, 1e-4])

                num_dimensions = 10
                prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
                prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
                likelihood = normal_pdf([0.7 * num_dimensions, 0], likelihood_variance * np.eye(2))
                l = np.ones(num_dimensions)

                def target_lnpdf(theta, without_prior=False):
                    target_lnpdf.counter += 1
                    y = 0
                    x = 0
                    for i in range(0, num_dimensions):
                        y += l[i] * np.sin(np.sum(theta[:i + 1]))
                        x += l[i] * np.cos(np.sum(theta[:i + 1]))
                    if without_prior:
                        return likelihood.logpdf(np.array([x, y]))
                    else:
                        return prior.logpdf(theta) + likelihood.logpdf(np.array([x, y]))

                target_lnpdf.counter = 0
                targetlnpdfs.append(target_lnpdf)
                if gtlns is None:
                    gtlns = [targetlnpdfs[-1](x) for x in gt_samples[-1]]

                my_groundtruth_lns.append(gtlns)


                final_groundtruth_lns.append(my_groundtruth_lns[-1])
                final_learned_lns.append(log_densities[-1])

for i in range(len(results)):
    fevals.append(progresses[i].num_feval)
    mmd_hists.append(progresses[i].mmd)
    timestamps.append(progresses[i].timestamps)

np.savez('extracted_data', directories = directories,
        confs = confs,
        final_groundtruth_lns = final_groundtruth_lns,
        final_learned_lns = final_learned_lns,
        fevals = fevals,
        mmd_hists = mmd_hists,
         timestamps = timestamps)