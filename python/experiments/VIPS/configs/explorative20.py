from plotting.default_plot import default_plots

COMMON = {
    # number of threads to use
    'num_threads': 6,

    # groundtruth sample set for evaluations
    'groundtruth_samples': None,
    'groundtruth_likelihoods': None,

    # frequency for computing the Maximum Mean Discrepancy
    'mmd_rate': 20,

    # default bandwidth for the SE-kernel used for computing the MMD (usually overwritten by experiment script)
    'mmd_alpha': 20,

    # average mmd by redrawing samples 'num_mmd_evals' times
    'num_mmd_evals': 1,

    # path to dump learning progress
    'progress_path': None,

    # store progress every <progress_rate> outer iteration
    'progress_rate': -1,

    ### On top of the progress data we also store the GMM parameters.
    # We do not use the progress class for this, because keeping many GMM dumps in memory might ask for trouble
    # the path to save the GMM parameters (n-evals and timestamps are stored as well -> plotting)
    'gmm_dumps_path': "/home/oleg_new/biac_gmm_dumps/",

    # the rate at which the GMMs should be dumped to hard drive
    'gmm_dumps_rate': 10
}

# Hyperparameters of the Learn-To-Sample algorithm
LTS = {
    # Integer storing the maximum number of allowed components
    'max_components': 20,

    # upper bounds on the bonus for staying away from the current mixture when adding a new component
    # the bounds are specified as a list, which gets cycled through
    'max_exploration_gains': [2000], #ToDo: use 200,100 for BIAC

    # each outer iterations consists of 1) sampling, 2) updating the component weights, 3) updating the components
    'outer_iterations': 10000,

    # defines how often to alternate between 2) and 3) after each sampling step
    'iterations_for_mixture_updates': 1,

    # use KL subsampling
    'use_KL_subsampling': True,

    # number of reused samples per component and dimension, ignored if use_KL_subsampling==False
    'num_reused_samples': 40,

    # desired number of effective samples per component and dimension, ignored if use_KL_subsampling==False
    'desired_num_eff_samples': 20,

    # We will activate the the N = <sample_reuse_factor> * num_components newest samples for learning
    # Ignored if use_KL_subsampling=True
    'sample_reuse_factor': 2,

    # number of samples (per component per dimension), ignored if use_KL_subsampling==True
    'num_samples_per_iteration': 10,

    # How many samples should be drawn initially?
    'num_initial_samples': 20,

    # <new_components_to_add> new components are added every <component_adding_rate>th iteration
    'new_components_to_add': 1,
    'component_adding_rate': 1000,
    'component_deletion_rate': 200, # change to 200?

    # delete components with weight < <min_components_weight>
    'min_components_weight': 1e-6,

    # an offset fo the lagrangian on the entropy objective (fixed to 1)
    'offset_on_entropy_lagrangian': 0,

    # initialize new components covariance matrices using a linesearch
    'use_linesearch_for_new_covs': True,

    # initialize new components as isotropic rather than by interpolation (ignored if 'use_linesearch_for_new_covs'==True)
    'initialize_new_covs_isotropic': False
}

WEIGHT_OPTIMIZATION = {
    # KL bound (greedy optimization, if >= 100)
    'epsilon': 1000
}

# Hyperparameters for optimizing the mixture components' mean and Sigma using MORE
COMPONENT_OPTIMIZATION = {
    # range of possible kl bounds. The actual kl bound is adapted based on the improvement
    'max_kl_bound': 5.,
    'min_kl_bound': 1e-1,

    # regularization coefficient for fitting the quadratic surrogate
    'ridge_for_MORE': 1e-14,

    # if true, the ridge_coefficient will be adapted for each component
    'adapt_ridge_multipliers': True,

    # when set to True, learn only the diagonal entries for each component
    'no_correlations': False,

    # maximum amount of samples for each component that should be used for fitting the reward surrogate
    'max_active_samples': 500000
}

# Plotting parameters
PLOTTING = {
    # We only plot if iter % plot_rate == 0
    'rate': 10
}

FUNCTIONS = {
    # comparison-plot
    'plot_fctn': default_plots
}
