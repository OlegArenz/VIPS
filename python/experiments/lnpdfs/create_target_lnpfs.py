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
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
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

def build_target_likelihood_planar_n_link_4(num_dimensions, prior_variance, likelihood_variance):
    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
    likelihood1 = normal_pdf([0.7 * num_dimensions, 0], likelihood_variance * np.eye(2))
    likelihood2 = normal_pdf([-0.7 * num_dimensions, 0], likelihood_variance * np.eye(2))
    likelihood3 = normal_pdf([0, 0.7 * num_dimensions], likelihood_variance * np.eye(2))
    likelihood4 = normal_pdf([0, -0.7 * num_dimensions], likelihood_variance * np.eye(2))
    l = np.ones(num_dimensions)
    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i+1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i+1],1))
      #  likelihood = likelihood2.logpdf(np.vstack((x,y)).transpose())
        likelihood = np.max(np.vstack((likelihood1.logpdf(np.vstack((x,y)).transpose()), likelihood2.logpdf(np.vstack((x,y)).transpose()), likelihood3.logpdf(np.vstack((x,y)).transpose()), likelihood4.logpdf(np.vstack((x,y)).transpose()))),axis=0)
        if without_prior:
            return np.squeeze(likelihood)
        else:
            return np.squeeze(prior.logpdf(theta) + likelihood)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol]

def build_target_likelihood_planar_n_link_4_autograd(num_dimensions, prior_variance, likelihood_variance):
    from autograd.scipy.stats import multivariate_normal as normal_auto
    import autograd.numpy as np
    l = np.ones(num_dimensions)
    def target_lnpdf(theta):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i+1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i+1],1))
        likelihood = np.max((
                normal_auto.logpdf(np.vstack((x,y)).transpose(),[0.7 * num_dimensions, 0], likelihood_variance * np.eye(2)),
                normal_auto.logpdf(np.vstack((x,y)).transpose(),[-0.7 * num_dimensions, 0], likelihood_variance * np.eye(2)),
                normal_auto.logpdf(np.vstack((x,y)).transpose(),[0, 0.7 * num_dimensions], likelihood_variance * np.eye(2)),
                normal_auto.logpdf(np.vstack((x,y)).transpose(),[0, -0.7 * num_dimensions], likelihood_variance * np.eye(2))))
        return np.squeeze(normal_auto.logpdf(theta, np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions)) + likelihood)
    target_lnpdf.counter = 0
    return target_lnpdf

def build_target_likelihood_planar_n_link_3(num_dimensions, prior_variance, likelihood_variance):
    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
    likelihood1 = normal_pdf([4,7], likelihood_variance * np.eye(2))
    likelihood2 = normal_pdf([5,3], likelihood_variance * np.eye(2))
    likelihood3 = normal_pdf([6,-2], likelihood_variance * np.eye(2))
    l = np.ones(num_dimensions)
    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i+1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i+1],1))
        likelihood = np.max(np.vstack((likelihood1.logpdf(np.vstack((x,y)).transpose()), likelihood2.logpdf(np.vstack((x,y)).transpose()), likelihood3.logpdf(np.vstack((x,y)).transpose()))),axis=0)
        if without_prior:
            return np.squeeze(likelihood)
        else:
            return np.squeeze(prior.logpdf(theta) + likelihood)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol]

def build_target_likelihood_planar_n_link_4_2(num_dimensions, prior_variance, likelihood_variance):
    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)
    likelihood1 = normal_pdf([4,7], likelihood_variance * np.eye(2))
    likelihood2 = normal_pdf([5,3], likelihood_variance * np.eye(2))
    likelihood3 = normal_pdf([6,-2], likelihood_variance * np.eye(2))
    likelihood4 = normal_pdf([4,-6], likelihood_variance * np.eye(2))
    l = np.ones(num_dimensions)
    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        y = np.zeros((len(theta)))
        x = np.zeros((len(theta)))
        for i in range(0, num_dimensions):
            y += l[i] * np.sin(np.sum(theta[:,:i+1],1))
            x += l[i] * np.cos(np.sum(theta[:,:i+1],1))
        likelihood = np.max(np.vstack((likelihood1.logpdf(np.vstack((x,y)).transpose()), likelihood2.logpdf(np.vstack((x,y)).transpose()), likelihood3.logpdf(np.vstack((x,y)).transpose()), likelihood4.logpdf(np.vstack((x,y)).transpose()))),axis=0)
        if without_prior:
            return np.squeeze(likelihood)
        else:
            return np.squeeze(prior.logpdf(theta) + likelihood)
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
def build_GPR_lnpdf(X, y, prior_variance=1, prior_on_variance=True):
    import GPy
    from scipy.stats import multivariate_normal as mvn
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma.from_EV(1., 1))

    m = GPy.models.GPRegression(X, y, kernel=kernel)

    prior_mean = np.zeros(num_dimensions+1)
    prior_cov = prior_variance * np.eye(num_dimensions+1)
    prior = mvn(prior_mean, prior_cov)
    def target_lnpdf(input, without_prior=False):
        input = np.atleast_2d(input)
        thetas = np.exp(input)
        target_lnpdf.counter += len(thetas)
        output = []
        for theta,inp in zip(thetas,input):
            if prior_on_variance:
                m.kern.variance = theta[0]
                m.kern.lengthscale = theta[1:]
            else:
                m.kern.lengthscale = theta

            if without_prior:
                output.append(-m.objective_function() - prior.logpdf(inp))
            else:
                output.append(-m.objective_function())
        return np.squeeze(np.array(output))
    target_lnpdf.counter = 0
    return target_lnpdf, prior_cov, np.linalg.cholesky(prior_cov)

def build_GPR2_lnpdf(X, y, prior_variance=10, prior_on_variance=True):
    import GPy
    from scipy.stats import multivariate_normal as mvn
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma(1., 1))

    m = GPy.models.GPRegression(X, y, kernel=kernel)

    if prior_on_variance:
        prior_mean = np.zeros(num_dimensions+1)
        prior_cov = prior_variance * np.eye(num_dimensions+1)
    else:
        prior_mean = np.zeros(num_dimensions)
        prior_cov = prior_variance * np.eye(num_dimensions)
    prior = mvn(prior_mean, prior_cov)
    def target_lnpdf(input, without_prior=False):
        input = np.atleast_2d(input)
        thetas = np.exp(input)
        target_lnpdf.counter += len(thetas)
        output = []
        for theta,inp in zip(thetas,input):
            try:
                if prior_on_variance:
                    m.kern.variance = theta[0]
                    m.kern.lengthscale = theta[1:]
                else:
                    m.kern.lengthscale = theta

                if without_prior:
                    output.append(-m.objective_function() - prior.logpdf(inp))
                else:
                    output.append(-m.objective_function())
            except:
                output.append(np.NaN)
        return np.squeeze(np.array(output))
    target_lnpdf.counter = 0
    return target_lnpdf, prior_cov, np.linalg.cholesky(prior_cov)

# This version does not support autograd (due to GPy), but converts autograds ArrayNodes to numpy arrays
def build_GPR_with_grad_lnpdf_autograd(X, y, prior_on_variance=True):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma.from_EV(1., 1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)
    import autograd
    def target_lnpdf(theta, without_prior=False):
        if isinstance(theta, autograd.numpy.numpy_extra.ArrayNode):
            theta = theta.value
        theta = np.exp(theta)
        if prior_on_variance:
            m.kern.variance = theta[0]
            m.kern.lengthscale = theta[1:]
        else:
            m.kern.lengthscale = theta

        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            if prior_on_variance:
                grad_dexpTheta = m.objective_function_gradients()[:-1]
            else:
                grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
        target_lnpdf.counter += 1
    target_lnpdf.counter = 0
    return target_lnpdf


def build_GPR_with_grad_lnpdf(X, y, prior_on_variance=True):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma.from_EV(1., 1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(theta, without_prior=False):
        theta = np.exp(theta.value)
        if prior_on_variance:
            m.kern.variance = theta[0]
            m.kern.lengthscale = theta[1:]
        else:
            m.kern.lengthscale = theta

        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            if prior_on_variance:
                grad_dexpTheta = m.objective_function_gradients()[:-1]
            else:
                grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
        target_lnpdf.counter += 1
    target_lnpdf.counter = 0
    return target_lnpdf

def build_GPR2_with_grad_lnpdf_absolutly_no_autograd(X, y, prior_on_variance=True):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma(1., 1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(theta, without_prior=False):
        theta = np.exp(theta)
        target_lnpdf.counter += 1
        if prior_on_variance:
            m.kern.variance = theta[0]
            m.kern.lengthscale = theta[1:]
        else:
            m.kern.lengthscale = theta
        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            if prior_on_variance:
                grad_dexpTheta = m.objective_function_gradients()[:-1]
            else:
                grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
    target_lnpdf.counter = 0
    return target_lnpdf

def build_GPR_with_grad_lnpdf_absolutly_no_autograd(X, y, prior_on_variance=True):
    import GPy
    num_dimensions = X.shape[1]
    kernel = GPy.kern.RBF(num_dimensions, lengthscale=np.ones(num_dimensions), ARD=True)
    kernel.lengthscale.set_prior(GPy.priors.Gamma.from_EV(1., 0.1))
    if prior_on_variance:
        kernel.variance.set_prior(GPy.priors.Gamma.from_EV(1., 1))
    m = GPy.models.GPRegression(X, y, kernel=kernel)

    def target_lnpdf(theta, without_prior=False):
        theta = np.exp(theta)
        target_lnpdf.counter += 1
        if prior_on_variance:
            m.kern.variance = theta[0]
            m.kern.lengthscale = theta[1:]
        else:
            m.kern.lengthscale = theta
        if without_prior:
            grad_dexpTheta = -m._log_likelihood_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [m.log_likelihood(), grad_dtheta]
        else:
            if prior_on_variance:
                grad_dexpTheta = m.objective_function_gradients()[:-1]
            else:
                grad_dexpTheta = m.objective_function_gradients()[1:-1]
            grad_dtheta = grad_dexpTheta * theta
            return [-m.objective_function(), grad_dtheta]
    target_lnpdf.counter = 0
    return target_lnpdf

def build_GPR_iono_lnpdf(prior_on_variance=True):
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[::3, -1].reshape((-1,1))[:100].copy()
    X = data[::3, :-1][:100].copy()
    return build_GPR_lnpdf(X, y, prior_on_variance=prior_on_variance)

def build_GPR2_iono_lnpdf(prior_on_variance=True):
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[::3, -1].reshape((-1,1))[:100].copy()
    X = data[::3, :-1][:100].copy()
    return build_GPR2_lnpdf(X, y, prior_on_variance=prior_on_variance)

def build_GPR_iono_with_grad_lnpdf(remove_autograd=False):
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[::3, -1].reshape((-1,1))[:100].copy()
    X = data[::3, :-1][:100].copy()
    if remove_autograd:
        return build_GPR_with_grad_lnpdf_autograd(X,y)
    else:
        return build_GPR_with_grad_lnpdf(X, y)

def build_GPR_iono_with_grad_lnpdf_no_autograd():
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[::3, -1].reshape((-1,1))[:100].copy()
    X = data[::3, :-1][:100].copy()
    return build_GPR_with_grad_lnpdf_absolutly_no_autograd(X, y)

def build_GPR_iono2_with_grad_lnpdf_no_autograd():
    data = np.loadtxt(data_path + "datasets/ionosphere.data")
    y = data[::3, -1].reshape((-1,1))[:100].copy()
    X = data[::3, :-1][:100].copy()
    return build_GPR2_with_grad_lnpdf_absolutly_no_autograd(X, y, prior_on_variance=False)

### Frisk Experiment
def build_frisk_lnpdf(prior_variance=1):
    import experiments.lnpdfs.StopAndFrisk.frisk as frisk
    lnpdf, _, num_dimensions, _, _= frisk.make_model_funs(precinct_type=1)

    prior = normal_pdf(np.zeros(num_dimensions), prior_variance * np.eye(num_dimensions))
    prior_chol = np.sqrt(prior_variance) * np.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        theta = np.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        if without_prior:
            return lnpdf(theta) - prior.logpdf(theta)
        else:
            return lnpdf(theta)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol, num_dimensions]

def build_frisk_autograd(prior_variance=1):
    import experiments.lnpdfs.StopAndFrisk.frisk_autograd as frisk
    import autograd.numpy as anp
    lnpdf, _, num_dimensions, _, _= frisk.make_model_funs(precinct_type=1)

    prior = normal_pdf(anp.zeros(num_dimensions), prior_variance * anp.eye(num_dimensions))
    prior_chol = anp.sqrt(prior_variance) * anp.eye(num_dimensions)

    def target_lnpdf(theta, without_prior=False):
        theta = anp.atleast_2d(theta)
        target_lnpdf.counter += len(theta)
        if without_prior:
            return lnpdf(theta) - prior.logpdf(theta)
        else:
            return lnpdf(theta)
    target_lnpdf.counter = 0
    return [target_lnpdf, prior, prior_chol, num_dimensions]

### Goodwin Oscillator
def build_Goodwin(target_labels, sigma=0.1, steps=81, deltaS=1.0, startTimeToObserv=41, nosOfObserv=2, gamma_shape=2., gamma_rate=1., parameters=None, seed=None):
    from experiments.lnpdfs.goodwinoscillator.GoodwinOscillator import GoodwinOscillator as GoodwinOscillator
    if parameters is None:
        a1 = 1.0
        a2 = 3.0
        alpha = 0.5
        rho = 10
        g = 3  # number of genes
        kappa = []
        for i in range(g - 1):
            if i == 0:
                kappa.append(2.0)
            else:
                kappa.append(1.0)
        kappa = np.array(kappa)
        ###############################################################

        # setup parameters
        parameters = np.concatenate(([rho, a1, a2, alpha], kappa))
    else:
        g = len(parameters) - 3
    nosOfS = steps

    # starting point
    x0 = np.zeros(g)

    #### an instance for Goodwin model
  #  observ = np.load(data_path+"/datasets/goodwin_observations_12345.npy")
   # goodwin = GoodwinOscillator(parameters=parameters, x0=x0, target_param_label=target_labels, nosOfS=nosOfS,
   #                             deltaS=deltaS, \
   #                             gamma_shape=gamma_shape, gamma_rate=gamma_rate, \
   #                             nosOfObserv=nosOfObserv, sigma=sigma, \
   #                             startTimeToObserv=startTimeToObserv,
   #                             observations=observ)
    goodwin = GoodwinOscillator(parameters=parameters, x0=x0, target_param_label=target_labels, nosOfS=nosOfS,
                                deltaS=deltaS, \
                                gamma_shape=gamma_shape, gamma_rate=gamma_rate, \
                                nosOfObserv=nosOfObserv, sigma=sigma, \
                                startTimeToObserv=startTimeToObserv, seed=seed)
    def target_lnpdf(thetas):
        thetas = np.atleast_2d(np.exp(thetas))
        target_lnpdf.counter += len(thetas)
        lnpdfs = np.empty(len(thetas))
        for i in range(len(thetas)):
            lnpdfs[i] = goodwin.conditionalPosterior(thetas[i])
        return lnpdfs
    target_lnpdf.counter = 0
    return target_lnpdf


def build_Goodwin_grad_with_lnpdf(target_labels, sigma=0.1, steps=81, deltaS=1.0, startTimeToObserv=41, nosOfObserv=2, gamma_shape=2., gamma_rate=1., parameters=None, seed=None):
    from experiments.lnpdfs.goodwinoscillator.GoodwinOscillator import GoodwinOscillator as GoodwinOscillator
    if parameters is None:
        a1 = 1.0
        a2 = 3.0
        alpha = 0.5
        rho = 10
        g = 3  # number of genes
        kappa = []
        for i in range(g - 1):
            if i == 0:
                kappa.append(2.0)
            else:
                kappa.append(1.0)
        kappa = np.array(kappa)
        ###############################################################

        # setup parameters
        parameters = np.concatenate(([rho, a1, a2, alpha], kappa))
    else:
        g = len(parameters) - 3
    nosOfS = steps

    # starting point
    x0 = np.zeros(g)
    num_dimensions = len(target_labels)
    goodwin = GoodwinOscillator(parameters=parameters, x0=x0, target_param_label=target_labels, nosOfS=nosOfS,
                                deltaS=deltaS, \
                                gamma_shape=gamma_shape, gamma_rate=gamma_rate, \
                                nosOfObserv=nosOfObserv, sigma=sigma, \
                                startTimeToObserv=startTimeToObserv, seed=seed)
    def target_lnpdf(thetas):
        thetas = np.atleast_2d(np.exp(thetas))
        target_lnpdf.counter += len(thetas)
        lnpdfs = np.empty(len(thetas))
        grads = np.empty((len(thetas), num_dimensions))
        for i in range(len(thetas)):
            lnpdfs[i] = goodwin.conditionalPosterior(thetas[i])
            grads[i] = goodwin.gradient_logposterior(thetas[i]) * thetas[i]
        return lnpdfs, grads
    target_lnpdf.counter = 0
    return target_lnpdf


def build_Goodwin_grad(target_labels, sigma=0.1, steps=81, deltaS=1.0, startTimeToObserv=41, nosOfObserv=2, gamma_shape=2., gamma_rate=1., parameters=None, seed=None):
    from experiments.lnpdfs.goodwinoscillator.GoodwinOscillator import GoodwinOscillator as GoodwinOscillator
    if parameters is None:
        a1 = 1.0
        a2 = 3.0
        alpha = 0.5
        rho = 10
        g = 3  # number of genes
        kappa = []
        for i in range(g - 1):
            if i == 0:
                kappa.append(2.0)
            else:
                kappa.append(1.0)
        kappa = np.array(kappa)
        ###############################################################

        # setup parameters
        parameters = np.concatenate(([rho, a1, a2, alpha], kappa))
    else:
        g = len(parameters) - 3
    nosOfS = steps

    # starting point
    x0 = np.zeros(g)
    num_dimensions = len(target_labels)
    goodwin = GoodwinOscillator(parameters=parameters, x0=x0, target_param_label=target_labels, nosOfS=nosOfS,
                                deltaS=deltaS, \
                                gamma_shape=gamma_shape, gamma_rate=gamma_rate, \
                                nosOfObserv=nosOfObserv, sigma=sigma, \
                                startTimeToObserv=startTimeToObserv, seed=seed)
    def target_lnpdf(thetas):
        thetas = np.atleast_2d(np.exp(thetas))
        target_lnpdf.counter += len(thetas)
        lnpdfs = np.empty(len(thetas))
        grads = np.empty((len(thetas), num_dimensions))
        for i in range(len(thetas)):
            lnpdfs[i] = -1 # goodwin.conditionalPosterior(thetas[i])
            grads[i] = goodwin.gradient_logposterior(thetas[i]) * thetas[i]
        return lnpdfs, grads
    target_lnpdf.counter = 0
    return target_lnpdf


def build_1d():
    def likelihood(x):
            return 10 * (0.5 * np.exp(-0.5 * np.square(x - 7) / 20)
            - 30 * (-5 < x < 5)
            + 0.48 * np.exp(-0.5 * np.square(x + 7) / 20)
            - np.square(x) / 1000)

    def target_lnpdf(theta, without_prior=False):
        target_lnpdf.counter += 1
        lnpdfs = []
        theta = np.atleast_1d(theta)
        theta = theta.flatten()
        for x in theta:
            lnpdfs.append(likelihood(x))
        return np.array(lnpdfs)

    target_lnpdf.counter = 0
    return target_lnpdf


def build_ball_in_a_cup_lnpdf_parallel(poolsize, prior_var=2):
    import pathos.multiprocessing as multiprocessing
    from scipy.stats import multivariate_normal
    from pathos.helpers import mp
    from SLGetInfo_SWIG_barrett import SLGetInfo_SWIG
    from SLSendTrajectory_SWIG_barrett import SLSendTrajectory_SWIG
    import time
    p = multiprocessing.Pool(poolsize)

    timesteps = 1400
    numDimensions = 7
    dmpStartPos = np.array([ 0.39421758,  0.69157279, -1.11048341,  1.33390546,  0.60440922,
       -0.08549518, -0.6456306 ])
    dmpStartVel = np.zeros(7)
    dmpGoalVel = np.zeros(7)
    tau = 0.07142857
    dmpAlphaX = 6.25
    dmpBetaX = 6.25
    dmpAmplitudeModifier = np.ones((1, numDimensions))
    dt = 0.01

   # basis = np.load('biac_basis2.npy')
    basis = np.load('basis_1400_5.npy')
    def referenceTrajectory(theta):
       # dmpGoalPos = theta[:numDimensions]
        dmpGoalPos = dmpStartPos
        dmpWeights = theta  * 100
        referencePos = np.zeros((timesteps, numDimensions))
        referenceVel = np.zeros((timesteps, numDimensions))

        referencePos[0, :] = dmpStartPos
        referenceVel[0, :] = dmpStartVel

        forcingFunction = basis.dot(dmpWeights.reshape((numDimensions, -1)).transpose())
        goalVel = dmpGoalVel * tau / (dt * timesteps)
        for i in range(0, timesteps - 1):

            movingGoal = dmpGoalPos - goalVel * dt * (timesteps - i)

            acc = dmpAlphaX * (dmpBetaX * (movingGoal - referencePos[i, :]) * tau ** 2 + (goalVel - referenceVel[i,:]) * tau) + \
                  dmpAmplitudeModifier * forcingFunction[i, :] * tau ** 2

            referenceVel[i + 1, :] = referenceVel[i,:] + dt * acc

            referencePos[i + 1, :] = referencePos[i,:] + dt * referenceVel[i + 1, :]
     #   plt.figure(123)
     #   plt.clf()
     #   plt.plot(referencePos)
     #   plt.pause(0.01)
        return referencePos

    joint_limits = np.array([[-2.6,2.6],[-2.1,2.],[-2.8,2.8],[-0.9, 3.2], [-4.8, 1.3], [-1.6,1.6],[-2.2,2.2]])
    def clip_to_jointlimits(traj):
        return np.clip(traj, joint_limits[:, 0], joint_limits[:, 1])
      #  return not(np.any(np.min(traj,axis=0) < joint_limits[:,0]) or np.any(np.max(traj,axis=0) > joint_limits[:,1]))

    shm_offsets = 7 * np.arange(poolsize)
    def target_lnpdf_single(dmp_params):
        params_with_goal = dmp_params
      #  threadID = int(mp.context.threading.currentThread().name.split('-')[-1]) % poolsize
        threadID = int(mp.context.process.current_process().name.split('-')[-1]) % poolsize
        shm_offset = int(shm_offsets[threadID])
        initState = np.array([0., 0.])

        [N_DOFS, N_DOFS_SHM, _] = SLGetInfo_SWIG()

        maxCommands = 2
        numCommand = 1
        waitTime = 0.0
        zero_trajectory = np.repeat(np.reshape(dmpStartPos, (1,-1)),1000, axis=0)
      #  np.zeros((1000, N_DOFS_SHM))
        timeOut = 20
        stateBuffer = initState
        refTraj = clip_to_jointlimits(referenceTrajectory(params_with_goal))
        [trajState, flag] = SLSendTrajectory_SWIG(numCommand,
                                                  maxCommands,
                                                  waitTime,
                                                  zero_trajectory,
                                                  stateBuffer,
                                                  timeOut,
                                                  shm_offset)
     #   traj = SLGetEpisodeSWIG(2,shm_offset)[0]
     #   if not np.all(np.isfinite(traj)):
     #       print("something went wrong")
        #time.sleep(0.)
        [trajState, flag] = SLSendTrajectory_SWIG(2,
                                                  maxCommands,
                                                  waitTime,
                                                  refTraj,
                                                  np.zeros((0)),
                                                  timeOut,
                                                  shm_offset)
     #   time.sleep(1)
      #  traj = SLGetEpisodeSWIG(2,shm_offset)[0]
      #  if not np.all(np.isfinite(traj)):
      #      print("something went wrong")
       # print(trajState[0])
      #  import hashlib
      #  filename = "/tmp/biacdebug/"+ hashlib.md5(str(params_with_goal).encode('utf-8')).hexdigest()
       # np.save("/tmp/biacdebug/"+ hashlib.md5(str(params_with_goal).encode('utf-8')).hexdigest(),trajState)
        if flag == 1:
            reward = trajState[0]
        else:
            reward= -np.Inf
        return 5 * reward

   # prior = multivariate_normal(np.zeros(numDimensions*9), prior_var * np.eye(numDimensions*9))
    def target_lnpdf(theta):
        input = np.atleast_2d(theta)

      #  manager = multiprocessing.Manager()
      #  idQueue = manager.Queue()

    #    for i in ids:
   #         idQueue.put(i)

        rewards = p.map(target_lnpdf_single, input)
        if np.any(np.asarray(rewards) > -1):
            print('error')
        print(rewards)
      #  print(prior.logpdf(input))
        return rewards #+ prior.logpdf(input)
    return target_lnpdf


def build_ball_in_a_cup_lnpdf():
    from SLGetInfo_SWIG_barrett import SLGetInfo_SWIG
    from SLSendTrajectory_SWIG_barrett import SLSendTrajectory_SWIG
    import time

    timesteps = 1000
    numDimensions = 7
    dmpStartPos = np.array([ 0.39421758,  0.69157279, -1.11048341,  1.33390546,  0.60440922,
       -0.08549518, -0.6456306 ])
    dmpStartVel = np.zeros(7)
    dmpGoalVel = np.zeros(7)
    tau = 0.1
    dmpAlphaX = 6.25
    dmpBetaX = 6.25
    dmpAmplitudeModifier = np.ones((1, numDimensions))
    dt = 0.01

   # basis = np.load('biac_basis2.npy')
    basis = np.load('basisFctn4.npy')
    def referenceTrajectory(theta):
       # dmpGoalPos = theta[:numDimensions]
        dmpGoalPos = dmpStartPos
        dmpWeights = theta * 100
        referencePos = np.zeros((timesteps, numDimensions))
        referenceVel = np.zeros((timesteps, numDimensions))

        referencePos[0, :] = dmpStartPos
        referenceVel[0, :] = dmpStartVel

        forcingFunction = basis.dot(dmpWeights.reshape((numDimensions, -1)).transpose())
        goalVel = dmpGoalVel * tau / (dt * timesteps)
        for i in range(0, timesteps - 1):
            movingGoal = dmpGoalPos - goalVel * dt * (timesteps - i)

            acc = dmpAlphaX * (dmpBetaX * (movingGoal - referencePos[i, :]) * tau ** 2 + (goalVel - referenceVel[i,:]) * tau) + \
                  dmpAmplitudeModifier * forcingFunction[i, :] * tau ** 2

            referenceVel[i + 1, :] = referenceVel[i,:] + dt * acc

            referencePos[i + 1, :] = referencePos[i,:] + dt * referenceVel[i + 1, :]
        return referencePos

#    joint_limits = np.array([[-2.6,2.6],[-2.1,2.],[-2.8,2.8],[-0.9, 3.2], [-4.8, 1.3], [-1.6,1.6],[-2.2,2.2]])
    joint_limits = np.array([[-2.4,2.4],[-1.9,1.8],[-2.6,2.6],[-0.7, 3.0], [-4.6, 1.1], [-1.4,1.4],[-2.0,2.0]])

    def clip_to_jointlimits(traj):
        return np.clip(traj, joint_limits[:, 0], joint_limits[:, 1])

    def target_lnpdf_single(dmp_params):
        params_with_goal = dmp_params
        initState = np.array([0., 0.])

        [N_DOFS, N_DOFS_SHM, _] = SLGetInfo_SWIG()

        maxCommands = 2
        numCommand = 1
        waitTime = 0.0
        zero_trajectory = np.repeat(np.reshape(dmpStartPos, (1,-1)),1000, axis=0)
        timeOut = 20
        stateBuffer = initState
        refTraj = referenceTrajectory(params_with_goal)
        if (np.any(((refTraj-joint_limits.T[1][np.newaxis:7])/joint_limits.T[1][np.newaxis:7])>5)
            or np.any(((refTraj-joint_limits.T[0][np.newaxis:7])/joint_limits.T[0][np.newaxis:7])>5)):
            return -2000
        refTraj = clip_to_jointlimits(refTraj)
        [trajState, flag] = SLSendTrajectory_SWIG(numCommand,
                                                  maxCommands,
                                                  waitTime,
                                                  zero_trajectory,
                                                  stateBuffer,
                                                  timeOut,
                                                  0)

        [trajState, flag] = SLSendTrajectory_SWIG(2,
                                                  maxCommands,
                                                  waitTime,
                                                  refTraj,
                                                  np.zeros((0)),
                                                  timeOut,
                                                  0)

        SLSendTrajectory_SWIG(-1, 1, 0.0, 0 * zero_trajectory,
                              np.array([]),
                              10,
                              0)

     #   time.sleep(1)
      #  traj = SLGetEpisodeSWIG(2,shm_offset)[0]
      #  if not np.all(np.isfinite(traj)):
      #      print("something went wrong")
       # print(trajState[0])
      #  import hashlib
      #  filename = "/tmp/biacdebug/"+ hashlib.md5(str(params_with_goal).encode('utf-8')).hexdigest()
       # np.save("/tmp/biacdebug/"+ hashlib.md5(str(params_with_goal).encode('utf-8')).hexdigest(),trajState)
        if flag == 1:
            reward = trajState[0]
            if (reward > 10000 or reward < -10000):
                print('strange reward')
                reward = -10000
        else:
            reward= -10000
        return reward

    def target_lnpdf(theta):
        input = np.atleast_2d(theta)
        target_lnpdf.counter += len(input)
        input = np.repeat(np.linspace(1.,10.,int(input.shape[1]/7)).reshape((1,-1)),[7],axis=0).flatten() * input
        rewards = np.empty((len(input)))
        for i in range(len(rewards)):
            rewards[i] = target_lnpdf_single(input[i])
       # if np.any(np.asarray(rewards) > -1):
       #     print('error')
        print(rewards)
        return 0.5 * rewards
    target_lnpdf.counter = 0
    return target_lnpdf
