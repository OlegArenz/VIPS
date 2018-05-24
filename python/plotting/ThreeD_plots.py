import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

class ThreeD_plots:

    def __init__(self, target_lnpdf, xmin, xmax, ymin, ymax, zmin, zmax):
        self.target_lnpdf = target_lnpdf
        self.xmin=xmin
        self.xmax=xmax
        self.ymin=ymin
        self.ymax=ymax
        self.zmin=zmin
        self.zmax=zmax
        self.firsttime = True

    def do_plots(self, sampler):
        if (self.firsttime):
            fig = plt.figure(21)
            ax = fig.add_subplot(111, projection='3d')
            ax.scatter(sampler.groundtruth_samples[::10, 0], sampler.groundtruth_samples[::10, 1],
                       sampler.groundtruth_samples[::10, 2])

        means = sampler.vips_c.get_mixture()[1]
        fig = plt.figure(22)
        plt.clf()
        ax = fig.add_subplot(111, projection='3d')
        ax.set_xlim3d(self.xmin, self.xmax)
        ax.set_ylim3d(self.ymin, self.ymax)
        ax.set_zlim3d(self.zmin, self.zmax)
        ax.scatter(means[-sampler.new_components_since_last_plot:, 0],
                   means[-sampler.new_components_since_last_plot:, 1],
                   means[-sampler.new_components_since_last_plot:, 2], marker='*', color='k')
        ax.scatter(means[:, 0], means[:, 1], means[:, 2], marker='^', color='r')
        sampler.new_components_since_last_plot = 0
        num_newest_samples = 1000
        ax.scatter(sampler.total_samples[-num_newest_samples:, 0], sampler.total_samples[-num_newest_samples:, 1], sampler.total_samples[-num_newest_samples:, 2])
