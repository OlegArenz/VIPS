import numpy as np
import os
import re
import matplotlib
#matplotlib.use('Qt4Agg')
import matplotlib.pyplot as plt


def matches_settings(evaluation, settings, keys, values):
    for i in range(0, len(settings)):
        if settings[i] != '':
            if not evaluation[settings[i]].tolist()[keys[i]] == values[i]:
                return False
        else:
            if type(evaluation[keys[i]]) is np.ndarray:
                if not np.all(evaluation[keys[i]] == values[i]):
                    return False
            if not evaluation[keys[i]] == values[i]:
                return False
    return True

class Data_OPS:
    def __init__(self):
        self.data_path = os.path.dirname(os.path.realpath(__file__))
        self.evaluations = []

    def load_files(self, relpath, regexp):
        path = self.data_path+os.sep+relpath+os.sep
        print('loaded: ' + str(self.show_files(relpath, regexp)))
        self.evaluations += [np.load(path + fn) for fn in os.listdir(path) if re.match(regexp, fn)]

    def show_files(self, relpath, regexp):
        path = self.data_path+os.sep+relpath+os.sep
        return [fn for fn in os.listdir(path) if re.match(regexp, fn)]

    def plot_groundtruth(self, settings, keys, values):
        plt.figure()
        [plt.plot(evaluation['gt_hist_mean']) for evaluation in self.evaluations if matches_settings(evaluation, settings, keys, values)]

