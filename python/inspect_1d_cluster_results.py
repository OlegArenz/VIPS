import numpy as np
import os
import matplotlib.pyplot as plt

directories = []
progresses = []

rootDir = '../data/cluster_results/german_credit'
for dirName, subdirList, fileList in os.walk(rootDir):
    for fname in fileList:
        if fname == "result.npz":
            tmp = np.load(dirName+'/'+fname)
            progresses.append(tmp['progress'].tolist())
            directories.append(dirName)

expected_densities = []
for i in range(len(progresses)-1):
    expected_densities.append(np.asarray(progresses[i].expected_target_densities).flatten())

entropies=[]
for i in range(len(progresses)-1):
    entropies.append(np.asarray(progresses[i].entropies_components).flatten())

plt.figure()
for i in range(len(expected_densities)):
    plt.plot(expected_densities[i])

plt.figure()
for i in range(len(entropies)):
    plt.plot(entropies[i])

plt.pause(0.01)
