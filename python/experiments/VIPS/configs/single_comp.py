from plotting.default_plot import default_plots

COMMON = {
    # number of threads to use
    'num_threads': 6,

    # groundtruth sample set for evaluations
    'groundtruth_samples': None,
    'groundtruth_likelihoods': None,

    # frequency for computing the Maximum Mean Discrepancy
    'mmd_rate': 100,

    # default bandwidth for the SE-kernel used for computing the MMD (usually overwritten by experiment script)
    'mmd_alpha': 100,

    # average mmd by redrawing samples 'num_mmd_evals' times
    'num_mmd_evals': 1,

    # path to dump learning progress
    'progress_path': None,

    # store progress every <progress_rate> outer iteration
    'progress_rate': -1,

    ### On top of the progress data we also store the GMM parameters.
    # We do not use the progress class for this, because keeping many GMM dumps in memory might ask for trouble
    # the path to save the GMM parameters (n-evals and timestamps are stored as well -> plotting)
    'gmm_dumps_path': None,

    # the rate at which the GMMs should be dumped to hard drive
    'gmm_dumps_rate': -1
}

# Hyperparameters of the Learn-To-Sample algorithm
LTS = {
    # Integer storing the maximum number of allowed components
    'max_components': 1,

    # upper bound on the bonus for staying away from the current mixture when adding a new component
    'initial_max_exploration_gain': 500,

    # rate for decreasing the exploration gain
    'decrease_rate_for_exploration_gain': 0,

    # each outer iterations consists of 1) sampling, 2) updating the component weights, 3) updating the components
    'outer_iterations': 1000,

    # defines how often to alternate between 2) and 3) after each sampling step
    'iterations_for_mixture_updates': 10,

    # number of samples (per component per dimension) that should be generated during step 1)
    'num_samples_per_iteration': 10,

    # We will activate the the N = <sample_reuse_factor> * num_components newest samples for learning
    'sample_reuse_factor': 3,

    # How many samples should be drawn initially?
    'num_initial_samples': 20,

    # <new_components_to_add> new components are added every <component_adding_rate>th iteration
    'new_components_to_add': 0,
    'component_adding_rate': 100000,

    # delete components with weight < <min_components_weight>
    'min_components_weight': 1e-7,

    # an offset fo the lagrangian on the entropy objective (fixed to 1)
    'offset_on_entropy_lagrangian': 0
}

WEIGHT_OPTIMIZATION = {
    # KL bound
    'epsilon': 1e-2
}

# Hyperparameters for optimizing the mixture components' mean and Sigma using MORE
COMPONENT_OPTIMIZATION = {
    # KL bound for MORE
    'epsilon': 1e-3,

    # The upper bound of the stepsize is given by <upper_kl_bound_fac> * num_eff_samples
    'upper_kl_bound_fac': 1e-5,

    # regularization coefficient for fitting the quadratic surrogate
    'ridge_for_MORE': 1e-10,

    # when set to True, learn only the diagonal entries for each component
    'no_correlations': False,

    # maximum amount of samples for each component that should be used for fitting the reward surrogate
    'max_active_samples': 1000
}

# Plotting parameters
PLOTTING = {
    # We only plot if iter % plot_rate == 0
    'rate': 1000
}

FUNCTIONS = {
    # comparision-plot
    'plot_fctn': default_plots
}
