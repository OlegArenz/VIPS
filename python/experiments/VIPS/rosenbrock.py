from sampler.VIPS.VIPS import VIPS
from experiments.GMM import GMM
from plotting.TwoD_plots import TwoD_plots
import matplotlib.pyplot as plt
import numpy as np

# Define the (unnormalized) target log-density function
from scipy.optimize import rosen
def target_lnpdf(theta):
    target_lnpdf.counter+=1
    theta = np.atleast_2d(theta)
    return -np.array([rosen(x) for x in theta])
target_lnpdf.counter=0

# Construct initial mixture (we will use a single Gaussian)
num_dimensions=2
initial_mixture = GMM(num_dimensions)
mean = 5 * np.random.random(2)
cov = 5 * np.eye(2)
initial_mixture.add_component(mean, cov)
initial_mixture.set_weights(np.array([1.]))

# If we do not want to write a new config, we can also modify an existing one
import experiments.VIPS.configs.fast_adding as config
config.PLOTTING['rate'] = -1 # disable plotting
config.LTS['max_components'] = 30
config.LTS['outer_iterations'] = 50
config.LTS['num_initial_samples'] = 0

# Learn the GMM approximation
sampler = VIPS(num_dimensions, target_lnpdf, initial_mixture, config)
sampler.learn_sampling()

# Get result
weights, means, covs = sampler.vips_c.get_model()
samples, _ = sampler.vips_c.draw_samples(1000, 1.0)
print("best mean: " + str(means[np.argmax(weights)]))

# Visualize the result
# Discretize and compare true pdf and learned pdf
plotter = TwoD_plots(sampler.target_lnpdf, -5, 5, 100, -2, 20, 100)
plotter.comp_plot(sampler, False)
# Plot samples from the GMM
plt.figure()
plt.title('Samples')
plt.plot(samples[:,0], samples[:,1], 'x')
plt.pause(0.0001)
input()