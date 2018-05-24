import os
import numpy as np
import matplotlib.pyplot as plt
from plotting.visualize_n_link import visualize_mixture


def visualize_processed_data(basepath):
    for dirName, subdirList, fileList in os.walk(basepath):
        for fname in sorted(fileList):
            if fname.endswith('_processed_data.npz'):
                data = np.load(dirName + '/' + fname)
                if 'samples' in data.keys():
                    samples = data['samples'][-1]
                    if len(samples > 2000):
                        samples = samples[1000:]
                    samples = samples[::int(len(samples) / 200)]
                    plt.figure()
                    visualize_mixture(np.ones(len(samples)), samples)
                    plt.title(data['fnames'][-1])
                else:
                    print(fname[-1] + "does not contain samples")