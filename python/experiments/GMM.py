import numpy as np
from scipy.stats import multivariate_normal as normal_pdf
from scipy import log, exp


# A Gaussian Mixture Model
class GMM:
    # Class Constructor
    def __init__(self, num_dimensions):
        self.num_dimensions = num_dimensions
        self.num_components = 0
        self.weights = np.array([])
        self.mixture = []

    def add_component(self, mean, cov):
        self.mixture.append(normal_pdf(mean, cov))
        self.weights = np.ones(len(self.mixture)) / len(self.mixture)
        self.num_components+=1

    def evaluate(self, x, return_log=False):
        if return_log:
            if x.ndim == 1:
                logpdf = np.empty((self.num_components))
            else:
                logpdf = np.empty((self.num_components, x.shape[0]))
            for i in range(0, self.num_components):
                logpdf[i] = self.mixture[i].logpdf(x) + np.log(self.weights[i])
            maxLogPdf = np.max(logpdf,0)
            if x.ndim == 1:
                return log(sum(exp(logpdf - maxLogPdf))) + maxLogPdf
            else:
                return log(sum(exp(logpdf - maxLogPdf[np.newaxis,:]))) + maxLogPdf
        else:
            if x.ndim == 1:
                pdf = np.empty((self.num_components))
            else:
                pdf = np.empty((self.num_components, x.shape[0]))
            for i in range(0, self.num_components):
                pdf[i] = self.mixture[i].pdf(x) * self.weights[i]
            return sum(pdf, 0)

    def sample(self, n):
        sampled_components = np.random.choice(a=self.num_components, size=n, replace=True, p = self.weights)
        counts = np.bincount(sampled_components)
        different_components = np.where(counts > 0)[0]
        # sample from each chosen component
        samples = np.vstack(
            [self.mixture[idx].rvs(counts[idx]).reshape(-1, self.num_dimensions) for idx in different_components])

        # shuffle the samples in order to make sure that we are unbiased when using just the last N samples
        indices = np.arange(len(sampled_components))
        np.random.shuffle(indices)
        return samples[indices]

    def set_weights(self, weights):
        self.weights = weights

    def get_weights(self):
        return self.weights

    def get_numpy_means(self):
        return np.asarray([comp.mean for comp in self.mixture])

    def get_numpy_covs(self):
        return np.asarray([comp.cov for comp in self.mixture])


