import numpy as np
from experiments.GMM import GMM
from scipy.stats import multivariate_normal as normal_pdf

import os
file_path = os.path.dirname(os.path.realpath(__file__))
data_path = os.path.abspath(os.path.join(file_path, os.pardir, os.pardir, os.pardir)) + "/data/"


### Gaussian Mixture Model experiment
def build_GMM_lnpdf(num_dimensions, num_true_components, prior_variance=1e3):
    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
    target_mixture = GMM(num_dimensions)
    for i in range(0, num_true_components):
        this_cov = 0.1 * np.random.normal(0, num_dimensions, (num_dimensions * num_dimensions)).reshape(
            (num_dimensions, num_dimensions))
        this_cov = this_cov.transpose().dot(this_cov)
        this_cov += 1 * np.eye(num_dimensions)
        this_mean = 100 * (np.random.random(num_dimensions) - 0.5)
        target_mixture.add_component(this_mean, this_cov)

    target_mixture.set_weights(np.ones(num_true_components) / num_true_components)
    def target_lnpdf(theta, without_prior=False):
        target_lnpdf.counter += 1
        if without_prior:
            return np.squeeze(target_mixture.evaluate(theta, return_log=True) - prior.logpdf(theta))
        else:
            return np.squeeze(target_mixture.evaluate(theta, return_log=True))

    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol, target_mixture]

def build_GMM_lnpdf_autograd(num_dimensions, num_true_components):
    import autograd.scipy.stats.multivariate_normal as normal_auto
    from autograd.scipy.misc import logsumexp
    import autograd.numpy as np
    means = np.empty((num_true_components, num_dimensions))
    covs = np.empty((num_true_components, num_dimensions, num_dimensions))
    for i in range(0, num_true_components):
        covs[i] = 0.1 * np.random.normal(0, num_dimensions, (num_dimensions * num_dimensions)).reshape(
            (num_dimensions, num_dimensions))
        covs[i] = covs[i].transpose().dot(covs[i])
        covs[i] += 1 * np.eye(num_dimensions)
        means[i] = 100 * (np.random.random(num_dimensions) - 0.5)

        def target_lnpdf(theta):
            theta = np.atleast_2d(theta)
            target_lnpdf.counter += len(theta)
            cluster_lls = []
            for i in range(0, num_true_components):
                cluster_lls.append(np.log(1./num_true_components) + normal_auto.logpdf(theta, means[i], covs[i]))
            return np.squeeze(logsumexp(np.vstack(cluster_lls), axis=0))

        target_lnpdf.counter = 0
    return [target_lnpdf, means, covs]


### Planar-N-Link experiment
def build_target_likelihood_planar_n_link(num_dimensions, prior_variance, likelihood_variance):
    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
    likelihood = normal_pdf([0.7 * num_dimensions, 0], likelihood_variance * np.eye(2))
    l = np.ones(num_dimensions)
    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i+1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i+1],1))
        if without_prior:
            return np.squeeze(likelihood.logpdf(np.vstack((x,y)).transpose()))
        else:
            return np.squeeze(prior.logpdf(theta) + likelihood.logpdf(np.vstack((x,y)).transpose()))
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol]

def build_target_likelihood_planar_autograd(num_dimensions):
    from autograd.scipy.stats import multivariate_normal as normal_auto
    import autograd.numpy as np

    conf_likelihood_var = 4e-2 * np.ones(num_dimensions)
    conf_likelihood_var[0] = 1
    cart_likelihood_var = np.array([1e-4, 1e-4])
    prior_mean = np.zeros(num_dimensions)
    prior_cov = conf_likelihood_var * np.eye(num_dimensions)
    likelihood_mean = [0.7 * num_dimensions, 0]
    likelihood_cov = cart_likelihood_var * np.eye(2)
    l = np.ones(num_dimensions)

    def target_lnpdf(theta):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i + 1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i + 1],1))
        return normal_auto.logpdf(theta, prior_mean, prior_cov) + normal_auto.logpdf(np.vstack([x, y]).transpose(),
                                                                                       likelihood_mean, likelihood_cov)

    target_lnpdf.counter = 0
    return [target_lnpdf, num_dimensions, None]


### Logistic regression experiments
def build_logist_regression_autograd(X, y, prior_variance):
    import autograd.numpy as np
    import autograd.scipy.stats.multivariate_normal as normal_auto

    num_dimensions = X.shape[1]
    prior_mean = np.zeros(num_dimensions)
    prior_cov = prior_variance * np.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        weighted_sum = np.dot(theta, X.transpose())
        offset = np.maximum(weighted_sum, np.zeros(weighted_sum.shape))
        denominator = offset + np.log(np.exp(weighted_sum - offset) + np.exp(-offset))
        log_prediction = -denominator
        swapped_y = -(y - 1)
        log_prediction = log_prediction + swapped_y[np.newaxis, :] * (weighted_sum)

        #log_prediction[np.where(np.isinf(log_prediction))] = 0
        if (np.any(np.isnan(log_prediction)) or np.any(np.isinf(log_prediction))):
            print('nan')
        loglikelihood = np.sum(log_prediction,1)
        if without_prior:
            return np.squeeze(loglikelihood)
        else:
            return np.squeeze(normal_auto.logpdf(theta, prior_mean, prior_cov) + loglikelihood)
    target_lnpdf.counter = 0
    return target_lnpdf

def build_logist_regression(X, y, prior_variance):
    import numpy as anp
    num_dimensions = X.shape[1]
    prior = normal_pdf(anp.zeros(num_dimensions), prior_variance * anp.eye(num_dimensions))
    prior_chol = anp.sqrt(prior_variance) * anp.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        theta = anp.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        weighted_sum = theta.dot(X.transpose())
        offset = anp.maximum(weighted_sum, np.zeros(weighted_sum.shape))
        denominator = offset + anp.log(anp.exp(weighted_sum - offset) + anp.exp(-offset))
        log_prediction = -denominator
        log_prediction[:,np.where(y == 0)] += weighted_sum[:,np.where(y == 0)]
        log_prediction[np.where(anp.isinf(log_prediction))] = 0
        if (anp.any(anp.isnan(log_prediction)) or anp.any(anp.isinf(log_prediction))):
            print('nan')
        loglikelihood = anp.sum(log_prediction,1)
        if without_prior:
            return np.squeeze(loglikelihood)
        else:
            return np.squeeze(prior.logpdf(theta) + loglikelihood)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol]


def build_breast_cancer_lnpdf(with_autograd=False):
    if with_autograd:
        import autograd.numpy as np
    else:
        import numpy as np
    data = np.loadtxt(data_path + "datasets/breast_cancer.data")
    y = data[:, 1]
    X = data[:, 2:]
    X /= np.std(X, 0)[np.newaxis, :]
    X = np.hstack((np.ones((len(X), 1)), X))
    prior_vars = 100
    if with_autograd:
        tmp = build_logist_regression_autograd(X, y, prior_vars)
        def lnpdf(theta):
            input = np.atleast_2d(theta)
            lnpdf.counter += len(input)
            return tmp(input)
        lnpdf.counter = 0
        return lnpdf
    return build_logist_regression(X, y, prior_vars)

def build_german_credit_lnpdf(with_autograd=False):
    data = np.loadtxt(data_path + "datasets/german.data-numeric")
    y = data[:, -1] - 1
    X = data[:, :-1]
    X /= np.std(X, 0)[np.newaxis, :]
    X = np.hstack((np.ones((len(X), 1)), X))
    prior_vars = 100
    if with_autograd:
        return build_logist_regression_autograd(X, y, prior_vars)
    return build_logist_regression(X, y, prior_vars)



### GP Regression Experiments
def build_GPR_lnpdf(X, y, prior_on_variance=False):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))

    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(input, without_prior=False):
        thetas = np.atleast_2d(input)
        thetas = np.exp(thetas)
        target_lnpdf.counter += len(thetas)
        output = []
        for theta in thetas:
            if prior_on_variance:
                m.kern.variance = theta[0]
                m.kern.lengthscale = theta[1:]
            else:
                m.kern.lengthscale = theta

            if without_prior:
                output.append(m.log_likelihood())
            else:
                output.append(-m.objective_function())
        return np.squeeze(np.array(output))
    target_lnpdf.counter = 0
    return target_lnpdf

# This version does not support autograd (due to GPy), but converts autograds ArrayNodes to numpy arrays
def build_GPR_with_grad_lnpdf_autograd(X, y):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)
    import autograd
    def target_lnpdf(theta, without_prior=False):
        if isinstance(theta, autograd.numpy.numpy_extra.ArrayNode):
            theta = theta.value
        theta = np.exp(theta)
        m.kern.lengthscale = theta

        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
        target_lnpdf.counter += 1
    target_lnpdf.counter = 0
    return target_lnpdf


def build_GPR_with_grad_lnpdf(X, y):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(theta, without_prior=False):
        theta = np.exp(theta.value)
        m.kern.lengthscale = theta

        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
        target_lnpdf.counter += 1
    target_lnpdf.counter = 0
    return target_lnpdf

def build_GPR_with_grad_lnpdf_absolutly_no_autograd(X, y):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(theta, without_prior=False):
        theta = np.exp(theta)
        m.kern.lengthscale = theta
        target_lnpdf.counter += 1

        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
    target_lnpdf.counter = 0
    return target_lnpdf

def build_GPR_iono_lnpdf(prior_on_variance=False):
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[:, -1].reshape((-1,1))
    X = data[:, :-1]
    return build_GPR_lnpdf(X, y, prior_on_variance=prior_on_variance)

def build_GPR_iono_with_grad_lnpdf(remove_autograd=False):
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[:, -1].reshape((-1,1))
    X = data[:, :-1]
    if remove_autograd:
        return build_GPR_with_grad_lnpdf_autograd(X,y)
    else:
        return build_GPR_with_grad_lnpdf(X, y)

def build_GPR_iono_with_grad_lnpdf_no_autograd():
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[:, -1].reshape((-1, 1))
    X = data[:, :-1]
    return build_GPR_with_grad_lnpdf_absolutly_no_autograd(X, y)

### Frisk Experiment
def build_frisk_lnpdf(prior_variance=1):
    import experiments.lnpdfs.StopAndFrisk.frisk as frisk
    lnpdf, _, num_dimensions, _, _= frisk.make_model_funs(precinct_type=1)

    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        target_lnpdf.counter += 1
        if without_prior:
            return lnpdf(theta) - prior.logpdf(theta)
        else:
            return lnpdf(theta)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol, num_dimensions]

def build_frisk_autograd(prior_variance=1):
    import experiments.lnpdfs.StopAndFrisk.frisk_autograd as frisk
    lnpdf, _, num_dimensions, _, _= frisk.make_model_funs(precinct_type=1)

    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        target_lnpdf.counter += 1
        if without_prior:
            return lnpdf(theta) - prior.logpdf(theta)
        else:
            return lnpdf(theta)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol, num_dimensions]
