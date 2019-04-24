#include "VIPS_PythonWrapper.h"

using namespace std;
using namespace arma;

VIPS_PythonWrapper::VIPS_PythonWrapper(int num_dimensions, int num_threads, double min_kl_bound, double max_kl_bound)
        : learner(num_dimensions, num_threads, min_kl_bound, max_kl_bound), learner_backup(learner), num_dimensions(num_dimensions),
        last_KLs_components(), last_KL_weights(), last_expected_rew(), last_expected_target_densities(){}

VIPS_PythonWrapper::~VIPS_PythonWrapper(void) {}

/**
* Adds new components<br>.
* @param new_weights - new weights of the GMM (including existing components)
* @param new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @param new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* of the new components
*/
  void VIPS_PythonWrapper::add_components(
      double * new_weights_in, int new_weights_in_dim1,
      double * new_means_in, int new_means_in_dim1, int new_means_in_dim2,
      double * new_covs_in,  int new_covs_in_dim1, int new_covs_in_dim2, int new_covs_in_dim3) {
        vec new_weights(new_weights_in, new_weights_in_dim1, false, true);
        mat new_means(new_means_in, new_means_in_dim2, new_means_in_dim1, false, true);
        cube new_covs(new_covs_in, new_covs_in_dim3, new_covs_in_dim2, new_covs_in_dim1, false, true);
        learner.add_components(new_weights, new_means, new_covs, true);
}

/**
* Selects promising locations among the current samples and create new components at these positions.<br>
* The covariance matrices are given by the weighted sums of the covariance matrices and weights of the
* current model, where the weights are given by the responsibilities of the model components for the new location.
* Locations are promising if the residual given by
* residual = log(p_intractable(x)) - log(p_model(x) + exp(max_exploration_bonus))
* is high.
*
* @param N - the number of samples to be promoted <br>
* @param max_exploration_bonus - maximum bonus for samples that have low density on the current model <br>
* @param only_check_active_samples - if set to true, the residual is computed on the active samples only,
* otherwise, the residual is computed for all samples in the sample database. <br>
 * @param tau - can be used to assign higher weight to the bonus for samples that have low density on the current model
* @param max_samples - maximum number of samples to be considered <br>
* @param scale_entropy - if true, scale the entropy of the newly created component such that it corresponds to the average entropy \sum_o p(o) H(p(x|o))
* @param isotropic - if true, initialize new components as isotropic (identity-matrix if scale_entropy = False) instead of interpolating.
*/
void VIPS_PythonWrapper::promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples, bool scale_entropy, bool isotropic) {
 learner.promote_samples_to_components(N, max_exploration_bonus, tau, only_check_active_samples, max_samples, scale_entropy, isotropic);
}

void VIPS_PythonWrapper::delete_low_weight_components(double min_weight, int n_del) {
  learner.model.delete_low_weight_components(min_weight, n_del);
}

/**
* Sample from the current GMM approximation, but use the specified component coefficients.
* @param N - the numb er of samples to been drawn
* @param weights - the weights (coefficients) to be used
* @returns samples - N Samples drwan from the mixture with the given weights
* @returns indices - for each sample, the index of the component that was used for drawing it
*/
void VIPS_PythonWrapper::draw_samples_weights(
    // inputs:
    double N,
    double * new_weights_in, int new_weights_in_dim1,
    // outputs:
    double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
    int **indices_out, int *indices_out_dim1
) {
  vec weights(new_weights_in, new_weights_in_dim1, false, true);
  mat samples(num_dimensions, N, fill::none);
  uvec used_components(N, fill::none);
  std::tie(samples, used_components) = learner.model.sample_from_mixture_weights(N, weights);

  Col<int> indices = conv_to<Col<int>>::from(used_components);
  *indices_out_dim1 = indices.n_rows;
  *indices_out = (int *) malloc(sizeof(int) * (*indices_out_dim1));
  memcpy(*indices_out, indices.memptr(), sizeof(int) * (*indices_out_dim1));

  *samples_out_dim1 = samples.n_cols;
  *samples_out_dim2 = samples.n_rows;
  *samples_out_ptr = (double *) malloc(sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
  memcpy(*samples_out_ptr, samples.memptr(), sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
}

/**
* Sample from the current GMM approximation, but use the specified temperature to to adapt the weights, i.e.
* the coefficient are replaced by p'(o) \tilde exp(log(p(o)*temperature))
* @param N - the numb er of samples to been drawn
* @param weights - the weights (coefficients) to be used
* @returns samples - N Samples drwan from the mixture with the given weights
* @returns indices - for each sample, the index of the component that was used for drawing it
*/
void VIPS_PythonWrapper::draw_samples(
        // inputs:
        double N, double temperature,
        // outputs:
        double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
        int **indices_out, int *indices_out_dim1) {
  mat samples(num_dimensions, N, fill::none);
  uvec used_components(N, fill::none);
  std::tie(samples, used_components) = learner.model.sample_from_mixture(N, temperature);

  Col<int> indices = conv_to<Col<int>>::from(used_components);
  *indices_out_dim1 = indices.n_rows;
  *indices_out = (int *) malloc(sizeof(int) * (*indices_out_dim1));
  memcpy(*indices_out, indices.memptr(), sizeof(int) * (*indices_out_dim1));

  *samples_out_dim1 = samples.n_cols;
  *samples_out_dim2 = samples.n_rows;
  *samples_out_ptr = (double *) malloc(sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
  memcpy(*samples_out_ptr, samples.memptr(), sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
}


/**
 * Adds new samples to the database.
 * Note that the samples will not be used for learning, until they have been activated (see activate_newest_samples).<br>
 * The samples are assumed to have been drawn from a Gaussian with specified mean and covariance matrix
 * @param new_samples - a matrix of size N_dimensions X N_samples
 * @param new_target_densities - a vector of size N_samples containing the unnormalized densities on the target distribution
 * @param used_mean - a vector containing the mean of the Gaussian used for drawing the samples
 * @param used_cov - a matrix containing the covariance matrix of the Gaussian used for drawing the samples
 * @see activate_newest_samples
 */
void VIPS_PythonWrapper::add_samples_mean_cov(
        // inputs:
        double *samples_ptr, int samples_dim1, int samples_dim2,
        double *target_densities_ptr, int td_dim1,
        double *mean_in, int mean_in_dim1,
        double *cov_in, int cov_in_dim1, int cov_in_dim2) {
  mat new_samples(samples_ptr, samples_dim2, samples_dim1, false, true);
  vec new_target_densities(target_densities_ptr, td_dim1, false, true);
  vec mean(mean_in, mean_in_dim1, false, true);
  mat cov(cov_in, cov_in_dim2, cov_in_dim1, false, true);
  mat invChol = inv(chol(cov, "lower"));
  mat means = repmat(mean, 1, new_samples.n_cols);
  cube covs(mean_in_dim1, mean_in_dim1, new_samples.n_cols, fill::none);
  cube invChols(mean_in_dim1, mean_in_dim1, new_samples.n_cols, fill::none);
  for (int i=0; i<new_samples.n_cols;i++) {
    covs.slice(i) = cov;
    invChols.slice(i) = invChol;
  }
  learner.sampleDatabase.add_samples(new_samples, new_target_densities, means, invChols, covs);
}


/**
 * Adds new samples to the database.
 * Note that the samples will not be used for learning, until they have been activated (see activate_newest_samples).<br>
 * The samples are assumed to have been drawn from the current model and the indices of the relevant components
 * are to be provided for computing background distributions when necessary.
 * @param new_samples - a matrix of size N_dimensions X N_samples
 * @param used_components - a vector of size N_samples containing the indices of the components the corresponding samples have been drawn from
 * @param new_target_densities - a vector of size N_samples containing the unnormalized densities on the target distribution
 * @see activate_newest_samples
 */
void VIPS_PythonWrapper::add_samples(
        // inputs:
        double *samples_ptr, int samples_dim1, int samples_dim2,
        int *indices_ptr, int indices_dim1,
        double *target_densities_ptr, int td_dim1) {
  mat new_samples(samples_ptr, samples_dim2, samples_dim1, false, true);
  vec new_target_densities(target_densities_ptr, td_dim1, false, true);
  Col<int> used_components(indices_ptr, indices_dim1, false, true);
  learner.add_samples_to_database(new_samples, new_target_densities, conv_to<uvec>::from(used_components));
}

/**
 * Selects the N most recent samples and activates them (i.e. uses them for the upcoming learning iteration).<br>
 * Makes sure, that all relevant data (e.g. densities, importance weights, etc.) gets updated
 * @param N - the maximum number of recent samples to be activated, actually number of activated samples
 * might be less, iff the sample database does not contain sufficient samples.<br>
 * @param keep_old - iff set to true, the currently active sample will remain active
 */
void VIPS_PythonWrapper::activate_newest_samples(int N, bool keep_old){
      learner.activate_newest_samples(N, keep_old);
}

/**
 * This function is used for building a mixture model for importance sampling.<br>
 * For each component p(x|o) in the current approximation, iteratively sample num_comps components p(x|i) from the sample database
 * (these have been used for drawing samples before) according to p \propto p(mu_i|o) - n_usages
 * Adds all samples from each chosen component and stops if num_samples are selected <br>
 * @param num_comps - maximum number of components that should be selected for each component in the approximation <br>
 * @param num_samples - maximum number of samples that should be aselected for each component in the approximation <br>
 * @param temperature - temperature for scaling the probability for sampling components <br>
 * @returns a vector containing the number of effective samples for each component
 */
void VIPS_PythonWrapper::select_active_samples(int num_comps, int num_samples, double temperature,
                            double ** num_eff_out_ptr, int * num_eff_out_dim1
) {
  vec num_eff = learner.select_active_samples(num_comps, num_samples, temperature);

  *num_eff_out_dim1 = num_eff.n_rows;
  *num_eff_out_ptr = (double *) malloc(sizeof(double) * (*num_eff_out_dim1));
  memcpy(*num_eff_out_ptr, num_eff.memptr(), sizeof(double) * (*num_eff_out_dim1));
}

/**
* Sets the current components p(s|o) and the current weight distribution p(o) as the target for the respective
* KL bounds.
*/
void VIPS_PythonWrapper::update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets) {
  learner.update_targets_for_KL_bounds(update_weight_targets, update_comp_targets);
}

/**
 * update the component weights p(o)
 * @param epsilon - KL bound <br>
 * @param tau - entropy coefficient <br>
 * @param max_entropy_decrease - lower bound on entropy <br>
 * @param be_greedy - if true, don't perform KL-bound optimization but use the greedy optimal weights
 */
void VIPS_PythonWrapper::update_weights(double epsilon, double tau, double max_entropy_decrease, bool be_greedy) {
  vec weights = learner.model.getWeights();
  vec log_weights = learner.model.getLogWeights();
 // double entropy_bound = - as_scalar(weights.t() * log_weights) - max_entropy_decrease; %ToDo Fix me
  double entropy_bound = max_entropy_decrease;
  std::tie(last_KL_weights, last_expected_rew, last_expected_target_densities) = learner.update_weights(epsilon, tau, entropy_bound, be_greedy);
}


/**
 * Lower bounds all weights and renormalizes by scaling those weights that have not been modified.
 * Currently, we do not check whether weights that got rescaled drop below their lower bound.
 * @param lb_weights_in - vector containing the lower bound for all weights.
 * The sum of lb_weights_in needs to be <= 1
 */
void VIPS_PythonWrapper::apply_lower_bound_on_weights(double * lb_weights_in, int lb_weights_in_dim1) {
    vec weights = learner.model.getWeights();
    vec lb_weights(lb_weights_in, lb_weights_in_dim1, false, true);
    vec bounded_weights = arma::max(weights, lb_weights);
    weights = normalise(bounded_weights, 1);
    learner.model.setWeights(weights);
   // learner.recompute_densities(false, false);
}



/**
 * Updates the components p(s|o).
 * @param tau - entropy coefficient <br>
 * @param ridge_coefficient - coefficient used for regularization when fitting the quadratic surrogate <br>
 * @param max_entropy_decrease - maximum allowed decrease in entropy for each component <br>
 * @param max_active_samples - size of the subset of samples that should be used for each component update <br>
 * @param dont_learn_correlations - iff true, fit a quadratic surrogate where R is diagonal (experimental) <br>
 * @param dont_recompute_densities - do not recompute the densities after the component update <br>
 * @param adapt_ridge_multipliers - if true, the ridge_coefficient will be adapted for each component <br>
 */
void VIPS_PythonWrapper::update_components(double tau, double ridge_coefficient,
 double max_entropy_decrease, double max_active_samples, bool dont_learn_correlations, bool dont_recompute_densities, bool adapt_ridge_multipliers) {
  vec entropy_bounds = learner.model.getEntropies() - max_entropy_decrease;
  last_KLs_components = learner.update_components(tau, ridge_coefficient, entropy_bounds, max_active_samples, dont_learn_correlations, dont_recompute_densities, adapt_ridge_multipliers);
}

/**
 * Recomputes the densities of various distributions as well as the importance weights.
 * This is usually necessary, after the samples or the model has changed.
 * @param only_weights_changed - if this flag is set to true, assume that only the model weights have changed
 * and avoid recomputing the component densities p(s|o).
 */
void VIPS_PythonWrapper::recompute_densities(bool only_weights_changed) {
    learner.recompute_densities(only_weights_changed);
}

// Methods for inspection
/**
* Returns the learned GMM.
* @return weights - weights for each component
* @return means - means for each component
* @return covs - covariance matrices for each component
*/
    void VIPS_PythonWrapper::get_model(
    //outputs
    double ** weights_out_ptr, int * weights_out_dim1,
    double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
    double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3) {
    cube covs = learner.model.getCovs();
    mat means = learner.model.getMeans();
    vec weights = learner.model.getWeights();

    *covs_out_dim1 = covs.n_slices;
    *covs_out_dim2 = num_dimensions;
    *covs_out_dim3 = num_dimensions;
    *covs_out_ptr = (double *) malloc(sizeof(double) * (*covs_out_dim1) * (*covs_out_dim2) * (*covs_out_dim3));
    memcpy(*covs_out_ptr, covs.memptr(), sizeof(double) * (*covs_out_dim1) * (*covs_out_dim2) * (*covs_out_dim3));

    *means_out_dim1 = means.n_cols;
    *means_out_dim2 = num_dimensions;
    *means_out_ptr = (double *) malloc(sizeof(double) * (*means_out_dim1) * (*means_out_dim2));
    memcpy(*means_out_ptr, means.memptr(), sizeof(double) * (*means_out_dim1) * (*means_out_dim2));

    *weights_out_dim1 = weights.n_rows;
    *weights_out_ptr = (double *) malloc(sizeof(double) * (*weights_out_dim1));
    memcpy(*weights_out_ptr, weights.memptr(), sizeof(double) * (*weights_out_dim1));
}

/**
* Returns the entropies of the learned model
* @return entropies_out_ptr - vector containing the entropy of each component of the learned GMM
*/
void VIPS_PythonWrapper::get_model_entropies(
        //outputs
        double ** entropies_out_ptr, int * entropies_out_dim1) {
        vec entropies = learner.model.getEntropies();
        *entropies_out_dim1 = entropies.n_rows;
        *entropies_out_ptr = (double *) malloc(sizeof(double) * (*entropies_out_dim1));
        memcpy(*entropies_out_ptr, entropies.memptr(), sizeof(double) * (*entropies_out_dim1));
        }
        
/**
* Returns the background distribution used for computing importance weights.
* @return weights - weights for each component
* @return means - means for each component
* @return covs - covariance matrices for each component
*/
    void VIPS_PythonWrapper::get_background(
    //outputs
    double ** weights_out_ptr, int * weights_out_dim1,
    double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
    double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3) {
    cube covs = learner.backgroundDistribution.getCovs();
    mat means = learner.backgroundDistribution.getMeans();
    vec weights = learner.backgroundDistribution.getWeights();

    *covs_out_dim1 = covs.n_slices;
    *covs_out_dim2 = num_dimensions;
    *covs_out_dim3 = num_dimensions;
    *covs_out_ptr = (double *) malloc(sizeof(double) * (*covs_out_dim1) * (*covs_out_dim2) * (*covs_out_dim3));
    memcpy(*covs_out_ptr, covs.memptr(), sizeof(double) * (*covs_out_dim1) * (*covs_out_dim2) * (*covs_out_dim3));

    *means_out_dim1 = means.n_cols;
    *means_out_dim2 = num_dimensions;
    *means_out_ptr = (double *) malloc(sizeof(double) * (*means_out_dim1) * (*means_out_dim2));
    memcpy(*means_out_ptr, means.memptr(), sizeof(double) * (*means_out_dim1) * (*means_out_dim2));

    *weights_out_dim1 = weights.n_rows;
    *weights_out_ptr = (double *) malloc(sizeof(double) * (*weights_out_dim1));
    memcpy(*weights_out_ptr, weights.memptr(), sizeof(double) * (*weights_out_dim1));
}

/**
 * Get the KLs of the last update iteration
 * @return KL_weights_out, the KL D(p_new(o)||p_old(new)) after the last weight update
 * @return KL_comps_out, a vector containing the KLs D(p_new(x|o)||p_old(x|o)) for each component o.
 */
void VIPS_PythonWrapper::get_last_KLs(double * KL_weights_out, double ** kls_comp_out, int * kls_comp_out_dim1) {
  *KL_weights_out = last_KL_weights;

  *kls_comp_out_dim1 = last_KLs_components.n_rows;
  *kls_comp_out = (double *) malloc(sizeof(double) * (*kls_comp_out_dim1));
  memcpy(*kls_comp_out,  last_KLs_components.memptr(), sizeof(double) * (*kls_comp_out_dim1));
}

/**
 * Get the GMM weights
 * @return weights_out_ptr, the weights p(o)
 * @return log_weights_out_ptr, the log-weights log(p(o))
 */
void VIPS_PythonWrapper::get_weights(
    double ** weights_out_ptr, int * weights_out_dim1,
    double ** log_weights_out_ptr, int * log_weights_out_dim1
){
    vec weights = learner.model.getWeights();
    vec log_weights = learner.model.getLogWeights();

    *weights_out_dim1 = weights.n_rows;
    *weights_out_ptr = (double *) malloc(sizeof(double) * (*weights_out_dim1));
    memcpy(*weights_out_ptr, weights.memptr(), sizeof(double) * (*weights_out_dim1));

    *log_weights_out_dim1 = log_weights.n_rows;
    *log_weights_out_ptr = (double *) malloc(sizeof(double) * (*log_weights_out_dim1));
    memcpy(*log_weights_out_ptr, log_weights.memptr(), sizeof(double) * (*log_weights_out_dim1));
}

/**
* Gets the number of samples.
* @return num_samples - the number of samples that are currently activated for learning
* @return num_samples_total - the number of samples that have ever been added to the database.
*/
void VIPS_PythonWrapper::get_num_samples(int * num_samples, int * num_samples_total) {
    *num_samples = learner.getNumSamples();
    *num_samples_total = learner.sampleDatabase.getNumSamples();
}

/**
* Returns the expected rewards and expected target densities
* @return expected_rewards_out a vector containing for each component the expect reward that was used
* during the last weight optimization
* @return expected_target_densities_out a vector containing the WIS estimates of E[f(x)]
*/
void VIPS_PythonWrapper::get_expected_rewards(
        double ** expected_rewards_out, int * expected_rewards_out_dim1,
        double ** expected_target_densities_out, int * expected_target_densities_out_dim1,
        double ** comp_etd_history_out_ptr, int * comp_etd_history_out_dim1, int * comp_etd_history_out_dim2,
        double ** comp_reward_history_out_ptr, int * comp_reward_history_out_dim1, int * comp_reward_history_out_dim2
) {
  *expected_rewards_out_dim1 = last_expected_rew.n_rows;
  *expected_rewards_out = (double *) malloc(sizeof(double) * (*expected_rewards_out_dim1));
  memcpy(*expected_rewards_out, last_expected_rew.memptr(), sizeof(double) * (*expected_rewards_out_dim1));

  *expected_target_densities_out_dim1 = last_expected_target_densities.n_rows;
  *expected_target_densities_out = (double *) malloc(sizeof(double) * (*expected_target_densities_out_dim1));
  memcpy(*expected_target_densities_out, last_expected_target_densities.memptr(), sizeof(double) * (*expected_target_densities_out_dim1));

  mat comp_etd_history = learner.model.comp_etd_history;
  *comp_etd_history_out_dim1 = comp_etd_history.n_cols;
  *comp_etd_history_out_dim2 = comp_etd_history.n_rows;
  *comp_etd_history_out_ptr = (double *) malloc(sizeof(double) * (*comp_etd_history_out_dim1) * (*comp_etd_history_out_dim2));
  memcpy(*comp_etd_history_out_ptr, comp_etd_history.memptr(), sizeof(double) * (*comp_etd_history_out_dim1) * (*comp_etd_history_out_dim2));
  
  mat comp_reward_history = learner.model.comp_reward_history;
  *comp_reward_history_out_dim1 = comp_reward_history.n_cols;
  *comp_reward_history_out_dim2 = comp_reward_history.n_rows;
  *comp_reward_history_out_ptr = (double *) malloc(sizeof(double) * (*comp_reward_history_out_dim1) * (*comp_reward_history_out_dim2));
  memcpy(*comp_reward_history_out_ptr, comp_reward_history.memptr(), sizeof(double) * (*comp_reward_history_out_dim1) * (*comp_reward_history_out_dim2));
}

/**
 * For a given component, find the best interpolation between the current covariance matrix and a spherical one using a linear linesearch. <br>
 * The quality of the covariance matrix is estimated based on an importance weighted Monte Carlo estimate of the expected loglikelihood on the target distribution. <br>
 * The Monte Carlo estimate is computed based on a given set of samples, the corresponding target loglikelihoods and the loglikelihood of the sampling distribution. <br>
 * IMPORTANT: This method will change the component to the best interpolation. <br>
 * @param index - index specifying which component of the current model should be adapted <br>
 * @param samples_ptr - samples for the Monte Carlo estimate <br>
 * @param target_densities_ptr - vector containing the loglikelihood under the target distribution for each sample <br>
 * @param target_densities2_ptr - vector containing the loglikelihood of the distribution that was used for drawing the samples <br>
 * @param scaling_factor - the spherical covariance matrix is given by scaling_factor * eye() <br>
 */
void VIPS_PythonWrapper::get_best_interpolation(int index,
                                double *samples_ptr, int samples_dim1, int samples_dim2,
                                double *target_densities_ptr, int td_dim1,
                                double *target_densities2_ptr, int td2_dim1,
                                double scaling_factor
    ) {
      mat samples = mat(samples_ptr, samples_dim2, samples_dim1, false, true);
      vec target_densities(target_densities_ptr, td_dim1, false, true);
      vec background_densities(target_densities2_ptr, td2_dim1, false, true);
      learner.getBestInterpolation(index, samples, target_densities, background_densities, scaling_factor);
    }


/**
 * Evaluates the samples on the learned GMM and returns log(p(samples))
 * @param samples_ptr - The samples to be evaluated
 * @return sample_densities - the log densities on the GMM
 */
void VIPS_PythonWrapper::get_log_densities_on_mixture(
        double * samples_ptr, int samples_dim1, int samples_dim2,
        double ** sample_densities_out, int * sample_densities_out_dim1
) {
  mat samples = mat(samples_ptr, samples_dim2, samples_dim1, false, true);
  vec log_densities = learner.model.evaluate_GMM_densities(samples, true);

  *sample_densities_out_dim1 = log_densities.n_rows;
  *sample_densities_out = (double *) malloc(sizeof(double) * (*sample_densities_out_dim1));
  memcpy(*sample_densities_out, log_densities.memptr(), sizeof(double) * (*sample_densities_out_dim1));
}


/**
 * Returns a (weighted importance sampling) Monte-Carlo estimate of the entropy of the learned model.
 * The entropy is computed based on the active samples.
 * As this entropy is computed based on precomputed values [importance weights and log(p(x))] th evaluation is very
 * fast.
 * However, if the number of active samples is still low or the samples are not "fresh" (low importance weights),
 * the estimate can be quite bad.
 * @see get_entropy_estimate_on_gmm_samples() for a slower, but usually more accurate estimate.
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
void VIPS_PythonWrapper::get_entropy_estimate_on_active_samples(double * entropy) {
  *entropy = learner.get_entropy_estimate_on_active_samples();
}

/**
 * Returns a Monte-Carlo estimate of the entropy of the learned model.
 * This methods draws new samples from the learned model and evaluated their log-densities log(p(x))
 * The entropy of the learned model is then approximated as H(p) \approx -1/num_samples \sum_x log(p(x))
 * @see get_entropy_estimate_on_active_samples() for a faster, but usually less accurate estimate.
 * @param num_samples - the number of samples that should be drawn for computing the estimate
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
void VIPS_PythonWrapper::get_entropy_estimate_on_gmm_samples(
        // output
        double * entropy,
        // input
        int num_samples) {
  *entropy = learner.get_entropy_estimate_on_gmm_samples(num_samples);
}

/**
 * Returns the number of components of the GMM approximation.
 * @return the number of components
 */
    void VIPS_PythonWrapper::get_num_components(int * num_components_out) {
    * num_components_out = learner.model.getNumComponents();
    }

/**
* Get various densities, importance weights, etc. for debug purposes.
* @return a tuple, st. <br>
* tuple[0] contains the samples <br>
* tuple[1] contains the unnormalized target densities <br>
* tuple[2] contains the log densities on each model p(s|o) <br>
* tuple[3] contains the joint log densities p(s,o) <br>
* tuple[4] contains the GMM densities p(s) <br>
* tuple[5] contains the log responsibilities p(o|s) <br>
* tuple[6] contains the densitis on the background distribution q(s) <br>
* tuple[7] contains the importance weights <br>
* tuple[8] contains the normalized importance weights <br>
* tuple[9] contains the indices of the active samples <br>
* tuple[10] contains the history of the number of samples drawn from each component
*/
    void VIPS_PythonWrapper::get_debug_info(
        double ** samples_out_ptr, int * samples_out_dim1, int * samples_out_dim2,
        double ** target_densities_out_ptr, int * target_densities_out_dim1,
        double ** log_densities_on_model_comps_out_ptr, int * log_densities_on_model_comps_out_dim1, int * log_densities_on_model_comps_out_dim2,
        double ** log_joint_densities_out_ptr, int * log_joint_densities_out_dim1, int * log_joint_densities_out_dim2,
        double ** log_densities_on_model_out_ptr, int * log_densities_on_model_out_dim1,
        double ** log_responsibilities_out_ptr, int * log_responsibilities_out_dim1, int * log_responsibilities_out_dim2,
        double ** log_densities_on_background_out_ptr, int * log_densities_on_background_out_dim1,
        double ** importance_weights_out_ptr, int * importance_weights_out_dim1, int * importance_weights_out_dim2,
        double ** importance_weights_normalized_out_ptr, int * importance_weights_normalized_out_dim1, int * importance_weights_normalized_out_dim2,
        int **indices_out, int *indices_out_dim1,
        int **num_samples_history_out_ptr, int *num_samples_history_out_dim1, int *num_samples_history_out_dim2
    ) {
    mat samples, log_densities_on_model_comps, log_joint_densities, log_responsibilities, importance_weights, importance_weights_normalized;
    vec target_densities, log_densities_on_model, log_densities_on_background;
    std::tie(samples, target_densities, log_densities_on_model_comps, log_joint_densities, log_densities_on_model,
                log_responsibilities, log_densities_on_background, importance_weights, importance_weights_normalized)
                 = learner.get_debug_info();
    uvec active_samples = learner.getActiveSamples();
    *samples_out_dim1 = samples.n_cols;
    *samples_out_dim2 = samples.n_rows;
    *samples_out_ptr = (double *) malloc(sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
    memcpy(*samples_out_ptr, samples.memptr(), sizeof(double) * (*samples_out_dim1) * (*samples_out_dim2));
    
    *target_densities_out_dim1 = target_densities.n_rows;
    *target_densities_out_ptr = (double *) malloc(sizeof(double) * (*target_densities_out_dim1));
    memcpy(*target_densities_out_ptr, target_densities.memptr(), sizeof(double) * (*target_densities_out_dim1));
    
    *log_densities_on_model_comps_out_dim1 = log_densities_on_model_comps.n_cols;
    *log_densities_on_model_comps_out_dim2 = log_densities_on_model_comps.n_rows;
    *log_densities_on_model_comps_out_ptr = (double *) malloc(sizeof(double) * (*log_densities_on_model_comps_out_dim1) * (*log_densities_on_model_comps_out_dim2));
    memcpy(*log_densities_on_model_comps_out_ptr, log_densities_on_model_comps.memptr(), sizeof(double) * (*log_densities_on_model_comps_out_dim1) * (*log_densities_on_model_comps_out_dim2));
    
    *log_joint_densities_out_dim1 = log_joint_densities.n_cols;
    *log_joint_densities_out_dim2 = log_joint_densities.n_rows;
    *log_joint_densities_out_ptr = (double *) malloc(sizeof(double) * (*log_joint_densities_out_dim1) * (*log_joint_densities_out_dim2));
    memcpy(*log_joint_densities_out_ptr, log_joint_densities.memptr(), sizeof(double) * (*log_joint_densities_out_dim1) * (*log_joint_densities_out_dim2));
    
    *log_densities_on_model_out_dim1 = log_densities_on_model.n_rows;
    *log_densities_on_model_out_ptr = (double *) malloc(sizeof(double) * (*log_densities_on_model_out_dim1));
    memcpy(*log_densities_on_model_out_ptr, log_densities_on_model.memptr(), sizeof(double) * (*log_densities_on_model_out_dim1));
      
    *log_responsibilities_out_dim1 = log_responsibilities.n_cols;
    *log_responsibilities_out_dim2 = log_responsibilities.n_rows;
    *log_responsibilities_out_ptr = (double *) malloc(sizeof(double) * (*log_responsibilities_out_dim1) * (*log_responsibilities_out_dim2));
    memcpy(*log_responsibilities_out_ptr, log_responsibilities.memptr(), sizeof(double) * (*log_responsibilities_out_dim1) * (*log_responsibilities_out_dim2));
        
    *log_densities_on_background_out_dim1 = log_densities_on_background.n_rows;
    *log_densities_on_background_out_ptr = (double *) malloc(sizeof(double) * (*log_densities_on_background_out_dim1));
    memcpy(*log_densities_on_background_out_ptr, log_densities_on_background.memptr(), sizeof(double) * (*log_densities_on_background_out_dim1));
    
    *importance_weights_out_dim1 = importance_weights.n_cols;
    *importance_weights_out_dim2 = importance_weights.n_rows;
    *importance_weights_out_ptr = (double *) malloc(sizeof(double) * (*importance_weights_out_dim1) * (*importance_weights_out_dim2));
    memcpy(*importance_weights_out_ptr, importance_weights.memptr(), sizeof(double) * (*importance_weights_out_dim1) * (*importance_weights_out_dim2));
    
    *importance_weights_normalized_out_dim1 = importance_weights_normalized.n_cols;
    *importance_weights_normalized_out_dim2 = importance_weights_normalized.n_rows;
    *importance_weights_normalized_out_ptr = (double *) malloc(sizeof(double) * (*importance_weights_normalized_out_dim1) * (*importance_weights_normalized_out_dim2));
    memcpy(*importance_weights_normalized_out_ptr, importance_weights_normalized.memptr(), sizeof(double) * (*importance_weights_normalized_out_dim1) * (*importance_weights_normalized_out_dim2));

    Col<int> indices = conv_to<Col<int>>::from(active_samples);
    *indices_out_dim1 = active_samples.n_rows;
    *indices_out = (int *) malloc(sizeof(int) * (*indices_out_dim1));
    memcpy(*indices_out, indices.memptr(), sizeof(int) * (*indices_out_dim1));

    Mat<int> num_samples_history = conv_to<Mat<int>>::from(learner.model.comp_num_samples_history);
    *num_samples_history_out_dim1 = num_samples_history.n_cols;
    *num_samples_history_out_dim2 = num_samples_history.n_rows;
    *num_samples_history_out_ptr = (int *) malloc(sizeof(int) * (*num_samples_history_out_dim1) * (*num_samples_history_out_dim2));
    memcpy(*num_samples_history_out_ptr, num_samples_history.memptr(), sizeof(int) * (*num_samples_history_out_dim1) * (*num_samples_history_out_dim2));
}

    /** creates a backup of the the current state of the learner (overwriting previous backup).
    * @see restore_backup()
    */
    void VIPS_PythonWrapper::backup_learner() {
        learner_backup = VIPS(learner);
    }

    /** restores the state of the learner from a backup.
    * @see backup_learner()
    */
    void VIPS_PythonWrapper::restore_learner() {
        learner = VIPS(learner_backup);
    }

    /**
    * For each component of the current approximation
    * compute the KL w.r.t. each component that is stored in the database.
    * If the parameter reverse_KL is set to true,
    * computes instead the KL for each database component w.r.t. each GMM component
    * @param reverse_KL - if set to bool compute the KL between database_componets w.r.t. GMM components
    * @returns a matrix of size components_in_gmm x components_in_database (or transposed if computing the reverse KL)
    * containing the relative entropies.
    */
    void VIPS_PythonWrapper::compute_KLs_between_GMM_and_DB_components(bool reverse_KL,
                                                   float ** KL_mat_out_ptr, int * KL_mat_out_dim1, int * KL_mat_out_dim2) {
      fmat KL_mat = std::get<0>(learner.sampleDatabase.compute_KLs_between_GMM_and_DB_components(learner.model, reverse_KL));
      *KL_mat_out_dim1 = KL_mat.n_cols;
      *KL_mat_out_dim2 = KL_mat.n_rows;
      *KL_mat_out_ptr = (float *) malloc(sizeof(float) * (*KL_mat_out_dim1) * (*KL_mat_out_dim2));
      memcpy(*KL_mat_out_ptr, KL_mat.memptr(), sizeof(float) * (*KL_mat_out_dim1) * (*KL_mat_out_dim2));
    }