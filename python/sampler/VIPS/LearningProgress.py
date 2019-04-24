import numpy as np
class LearningProgress:
    def __init__(self, num_dimensions):
        self.num_dimensions = num_dimensions
        # History of E[log(f(x))] for each component
        self.comp_reward_history = []

        # number of function evaluations
        self.num_feval = np.array([])

        # time at the beginning of each
        self.timestamps = np.array([])

        # achieved KLs / entropies
        self.kl_weights = np.array([])
        self.entropy_weights = np.array([])
        self.kl_components = []
        self.entropies_components = []

        # desired KLs
        self.kl_bounds_weights = np.array([])
        self.kl_bounds_components = []

        # Evaluation of old objective based on groundtruth samples
        self.groundtruth_obj_mean = np.array([])
        self.groundtruth_obj_mode = np.array([])

        # MMD to groundtruth samples
        self.mmd = np.array([])

        # Discretized KLs for low dimensional problems
        self.discrete_KLs_mode = np.array([])
        self.discrete_KLs_mean = np.array([])

        # Evaluation of old objective based on own samples
        self.obj_mean = np.array([])
        self.obj_mode = np.array([])

        # indices of illconditioned components
        self.illconditioned_components = []

        # indicies of rescaled components
        self.rescaled_components = []

        # weight history of the learned mixture
        self.weights = []

        # expected rewards per component
        self.expected_rewards = []
        self.expected_rewards2 = []
        self.expected_rewards3 = []
        self.expected_target_densities = []

        # mixture information
        self.component_means = []

        # number of components
        self.num_components = np.array([])

        # number of times a component was updates
        self.num_updates_per_component = []

        # densities on groundtruth samples
        self.target_densities_on_gt = []
        self.mixture_densities_on_gt = []

        # estimated entropy of the gmm
        self.gmm_entropy = []
        self.desired_entropy = []

        # entropy coefficient
        self.taus = []

        # effective samples after KL-based subsampling
        self.neffs = []

    def add_timestamp(self, timestamp):
        self.timestamps = np.hstack((self.timestamps, np.array([timestamp])))

    def add_feval(self, numfeval):
        self.num_feval = np.hstack((self.num_feval, np.array([numfeval])))

    def add_KL_weights(self, kl_weights):
        self.kl_weights = np.hstack((self.kl_weights, np.array([kl_weights])))

    def add_entropy_weights(self, entropy_weights):
        self.entropy_weights = np.hstack((self.entropy_weights, np.array([entropy_weights])))

    def add_KL_components(self, kl_components):
        self.kl_components.append(kl_components)

    def add_KL_bounds_weights(self, kl_bound_weights):
        self.kl_bounds_weights = np.hstack((self.kl_bounds_weights, np.array([kl_bound_weights])))

    def add_KL_bounds_components(self, kl_bounds_components):
        self.kl_bounds_components.append(kl_bounds_components)

    def add_groundtruth_objectives(self, gt_mean, gt_mode):
        self.groundtruth_obj_mean = np.hstack((self.groundtruth_obj_mean, np.array([gt_mean])))
        self.groundtruth_obj_mode = np.hstack((self.groundtruth_obj_mode, np.array([gt_mode])))

    def add_objective_evals(self, KL_mean, KL_mode):
        self.obj_mean = np.hstack((self.obj_mean, np.array([KL_mean])))
        self.obj_mode = np.hstack((self.obj_mode, np.array([KL_mode])))

    def add_ill_conditioned(self, illconditioned_components):
        self.illconditioned_components.append(illconditioned_components)

    def add_rescaled_components(self, rescaled_components):
        self.rescaled_components.append(rescaled_components)

    def add_weights(self, weights):
        self.weights.append(weights)

    def add_discrete_KL_mode(self, discrete_KL):
        self.discrete_KLs_mode = np.hstack((self.discrete_KLs_mode, np.array([discrete_KL])))

    def add_discrete_KL_mean(self, discrete_KL):
        self.discrete_KLs_mean = np.hstack((self.discrete_KLs_mean, np.array([discrete_KL])))

    def add_mmd(self, mmd):
        self.mmd = np.hstack((self.mmd, np.array([mmd])))

    def add_expected_rewards(self, expected_rewards):
        self.expected_rewards.append(expected_rewards)

    def add_expected_rewards2(self, expected_rewards):
        self.expected_rewards2.append(expected_rewards)

    def add_expected_rewards3(self, expected_rewards):
        self.expected_rewards3.append(expected_rewards)

    def add_num_components(self, num_components):
        self.num_components = np.hstack((self.num_components, np.array([num_components])))

    def add_entropy_components(self, entropy_components):
        self.entropies_components.append(entropy_components)

    def add_component_means(self, component_means):
        self.component_means.append(component_means)

    def add_expected_target_densities(self, expected_target_densities):
        self.expected_target_densities.append(expected_target_densities)

    def add_num_updates_per_component(self, num_updates):
        self.num_updates_per_component.append(num_updates)

    def set_groundtruth_likelihoods(self, groundtruth_likelihoods):
        self.target_densities_on_gt = groundtruth_likelihoods

    def add_learned_densities_on_gt(self, densities_on_gt):
        self.mixture_densities_on_gt.append(densities_on_gt)

    def add_mixture_entropy(self, new_entropy):
        self.gmm_entropy.append(new_entropy)

    def add_desired_entropy(self, new_entropy):
        self.desired_entropy.append(new_entropy)

    def add_tau(self, new_tau):
        self.taus.append(new_tau)

    def add_neff(self, neff):
            self.neffs.append(neff)