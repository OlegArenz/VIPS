import numpy as np
import matplotlib.pyplot as plt
plt.ion()

class TwoD_plots:
    def __init__(self, target_lnpdf, min_x, max_x, num_x, min_y, max_y, num_y):
        np.seterr(under="warn")
        self.target_lnpdf = target_lnpdf
        self.min_x = min_x
        self.max_x = max_x
        self.min_y = min_y
        self.max_y = max_y
        self.x = np.linspace(min_x, max_x, num_x)
        self.y = np.linspace(min_y, max_y, num_y)
        self.a, self.b = np.meshgrid(self.x, self.y)

        self.create_target_data()
        self.firsttime = True

    def create_target_data(self):
        z_true_log = np.zeros((len(self.x), len(self.y)))
        for i in range(0, len(self.x)):
            for j in range(0, len(self.y)):
                z_true_log[i, j] = self.target_lnpdf(np.array([self.a[i, j], self.b[i, j]]))
        np.seterr(under="warn")

        self.z_true_log_normed = z_true_log - np.max(z_true_log)
        self.z_true_log_normed -= np.log(np.sum(np.exp(self.z_true_log_normed)))
        self.z_true_normed = np.exp(self.z_true_log_normed)


    def comp_plot(self, sampler, plot_KL=True):
        if self.firsttime:
            self.fig10 = plt.figure(10)
            plt.clf()
            plt.subplot(2, 1, 1)
            plt.title('True Log-Densities')
            plt.contourf(self.a, self.b, self.z_true_log_normed, 100)
            self.fig11 = plt.figure(11)
            plt.clf()
            plt.subplot(2, 1, 1)
            plt.title('True Densities')
            plt.contourf(self.a, self.b, self.z_true_normed)
            self.firsttime = False

        z = np.zeros((len(self.x), len(self.y)))
        for i in range(0, len(self.x)):
            for j in range(0, len(self.y)):
                z[i, j] = sampler.vips_c.get_log_densities_on_mixture(np.array([self.a[i, j], self.b[i, j]]).reshape((1, 2)))

        plt.figure(10)
        plt.subplot(2, 1, 2)
        plt.cla()
        plt.title('Approximated Log-Densities')
        z_normed = z - np.max(z)
        z_normed -= np.log(np.sum(np.exp(z_normed)))
        z_log_normed = z_normed.copy()
        z_normed = np.exp(z_normed)
        plt.contourf(self.a, self.b, z_log_normed, 100)
        ax = self.fig10.gca()
        ax.set_autoscale_on(False)
        means = sampler.vips_c.get_model()[1]
        plt.plot(means[:, 0], means[:, 1], 'g*', markersize=8)

        plt.figure(11)
        plt.subplot(2, 1, 2)
        plt.title('Approximated Densities')
        plt.cla()
        plt.contourf(self.a, self.b, z_normed)
        if plot_KL:
            try:
                discrete_KL_mode = z_normed.flatten().dot(z_log_normed.flatten() - self.z_true_log_normed.flatten())
                discrete_KL_mean = self.z_true_normed.flatten().dot(self.z_true_log_normed.flatten() - np.log(z_normed.flatten()))
                sampler.progress.add_discrete_KL_mode(discrete_KL_mode)
                sampler.progress.add_discrete_KL_mean(discrete_KL_mean)
                plt.figure(14)
                plt.clf()
                plt.title("Discrete KL")
                mode_plot, = plt.semilogy(sampler.progress.discrete_KLs_mode, label='mode')
                mean_plot, = plt.semilogy(sampler.progress.discrete_KLs_mean, label='mean')
                plt.legend([mode_plot, mean_plot], ['mode', 'mean'])
            except:
                print("error")
        plt.show()
        plt.pause(0.0001)