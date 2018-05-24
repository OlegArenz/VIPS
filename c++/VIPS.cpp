#include "VIPS.h"
#include "Reps.h"
#include "More.h"

#include <omp.h>

using namespace std;
using namespace arma;

/**
 * Main class implementing the Learn-To-Sample algorithm
 */
VIPS::VIPS(int num_dimensions, int num_threads)
        : model(num_dimensions), sampleDatabase(num_dimensions), num_dimensions(num_dimensions),
          num_threads(num_threads), num_samples(0), samples(num_dimensions, 0), target_densities(),
          backgroundDistribution(num_dimensions) {
  omp_set_num_threads(num_threads);
  arma_rng::set_seed_random();
}

VIPS::~VIPS(void) {};

/**
 * Selects promising locations among the current samples and create new components at these positions.
 * The covariance matrices are given by the weighted sums of the covariance matrices current model,
 * where the weights are given by the responsibilities of the model components for the new location.
 * Locations are promising if the residual given by
 * residual = log(p_intractable(x)) - log(p_model(x) + exp(max_exploration_bonus))
 * is high.
 *
 * @param N - the number of samples to be promoted
 * @param max_exploration_bonus - maximum bonus for samples that have low density on the current model
 * @param only_check_active_samples - if set to true, the residual is computed on the active samples only,
 * otherwise, the resiudal is computed for all samples in the sample database.
 * @param max_samples - maximum number of samples to be considered
 */
void VIPS::promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples) {
  uvec available_indices;
  vec residual;
  vec my_log_densities_on_model;
  vec my_target_densities;
  mat my_samples;

  if (only_check_active_samples) {
    available_indices = linspace<uvec>(0, num_samples - 1, num_samples);
    my_samples = samples;
    my_log_densities_on_model = log_densities_on_model;
    my_target_densities = target_densities;
  } else {
    my_samples = sampleDatabase.getSamples();
    if (my_samples.n_rows > max_samples) {
        uvec shuffled = shuffle(linspace<uvec>(0, my_samples.n_cols - 1, my_samples.n_cols));
        my_samples = my_samples.cols(shuffled.head_rows(max_samples));
    }
    available_indices = linspace<uvec>(0, my_samples.n_cols - 1, my_samples.n_cols);
    my_log_densities_on_model = model.evaluate_GMM_densities_low_mem(my_samples);
    my_target_densities = sampleDatabase.getTargetDensities();
  }

  vec offsets(my_log_densities_on_model.n_rows, fill::none);
  offsets.fill(arma::max(log_densities_on_model) - max_exploration_bonus);

  vec max_vals = arma::max(my_log_densities_on_model, offsets);
  vec log_mixture_densities_with_offset =
          max_vals + log(exp(my_log_densities_on_model - max_vals) + exp(offsets - max_vals));
  residual = my_target_densities - (1+tau) * log_mixture_densities_with_offset;

  uvec chosen_indices(N, fill::none);
  int num_added_components;
  for (num_added_components = 0; num_added_components < N; num_added_components++) {
    int best_index = residual.index_max();
    chosen_indices.at(num_added_components) = best_index;
    uvec this_index(1, fill::none);
    this_index.at(0) = available_indices.at(best_index);
    model.add_components_at_locations(sampleDatabase.getSamples(this_index));

    // ignore all samples that are covered by the newly added component
    vec this_densities = model.compute_component_densities(model.getNumComponents() - 1, my_samples, true);
    uvec covered_samples = find(this_densities > as_scalar(arma::max(this_densities) - 12));
    residual.rows(covered_samples).fill(-datum::inf);
  }

  if (num_added_components < N) {
    N = num_added_components;
    chosen_indices = chosen_indices.head(num_added_components);
  }

  //recompute_densities();
  // ToDo: Right now we assume that a new sample set is activated after the promotion of samples to new components.
  // However, if this is not the case, we would need to recompute the densities here.
}

/**
 * Removes all components with weight below the given threshold, and renormalized the weights afterwards
 * @param min_weight - threshold for keeping components
 */
void VIPS::delete_low_weight_components(double min_weight) {
  model.delete_low_weight_components(min_weight);
  recompute_densities(); // ToDo: Only recompute responsibilities
}

/**
 * Adds new samples to the database.
 * Note that the samples will not be used for learning, until they have been activated (@see activate_newest_samples)
 * The samples are assumed to have been drawn from the current model and the indices of the relevant components
 * are to be provided for computing background distributions when necessary.
 * @param new_samples - a matrix of size N_dimensions X N_samples
 * @param new_target_densities - a vector of size N_samples containing the unnormalized densities on the target distribution
 * @param used_components - a vector of size N_samples containing the indices of the components the corresponding samples have been drawn from
 */
void VIPS::add_samples_to_database(arma::mat new_samples, arma::vec new_target_densities, arma::uvec used_components) {
  cube invChols = model.getInvChols();
  cube usedInvChols(num_dimensions, num_dimensions, used_components.n_rows, fill::none);
  for (int i = 0; i < used_components.n_rows; i++)
    usedInvChols.slice(i) = invChols.slice(used_components.at(i));

  sampleDatabase.add_samples(new_samples, new_target_densities, model.getMeans(used_components), usedInvChols);
}

/**
 * Recomputes the densities of various distributions as well as the importance weights.
 * Manual invocation is in general not necessary, as the densities are automatic updated,
 * e.g. after weight changes, component changes, adding components, etc.
 * @param update_log_densities_on_model_comps - if this flag is set to false, assume that the density-evaluations for each
 * GMM component is up-to-date, e.g. because only the GMM weights have changed
 * @param update_log_densities_on_model_background_dist - if this flag is set to false, assume that the density evaluations for
 * the background distribution are up-to-date, e.g. because it was not changed at all
 */
void VIPS::recompute_densities(bool update_log_densities_on_model_comps, bool update_log_densities_on_background_dist) {
  if (num_samples == 0)
    return;
  if (update_log_densities_on_model_comps)
    std::tie(log_joint_densities, log_densities_on_model_comps, offsets_for_model_joint_densities,
             sum_of_joint_densities_with_offsets, log_densities_on_model, log_responsibilities)
            = model.compute_log_marginals(samples);
  else
     std::tie(log_joint_densities, offsets_for_model_joint_densities,
            sum_of_joint_densities_with_offsets, log_densities_on_model, log_responsibilities)
            = model.compute_log_marginals_from_comp_densities(log_densities_on_model_comps);

  if (update_log_densities_on_background_dist)
    log_densities_on_background_dist = backgroundDistribution.evaluate_GMM_densities(samples, true);
  mat log_importance_weights =
          log(1.0 / num_samples) +
          (log_densities_on_model_comps - repmat(log_densities_on_background_dist.t(), model.getNumComponents(), 1));


  importance_weights = arma::exp(log_importance_weights);
  importance_weights_normalized = log_importance_weights.each_col() - arma::max(log_importance_weights, 1);
  importance_weights_normalized =
          importance_weights_normalized.each_col() - log(sum(exp(importance_weights_normalized), 1));
  importance_weights_normalized = exp(importance_weights_normalized);
}

/**
 * Selects the N most recent samples and activates them (i.e. uses them for the upcoming learning iteration).
 * Makes sure, that all relevant data (e.g. densities, importance weights, etc.) gets updated
 * @param N - the maximum number of recent samples to be activated, actually number of activated samples
 * might be less, iff the sample database does not contain sufficient samples.
 */
void VIPS::activate_newest_samples(int N) {
  std::tie(samples, target_densities, backgroundDistribution) = sampleDatabase.select_newest_samples(N);
  num_samples = samples.n_cols;
  recompute_densities();
}

/**
 * Sets the current components p(s|o) and the current weight distribution p(o) as the target for the respective
 * KL bounds.
 * @param update_weight_targets - only update the weight targets if this is set to true
 * @param update_comp_targets - only update the component targets if this ist set to true
 */
void VIPS::update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets) {
  model.update_targets_for_KL_bounds(update_weight_targets, update_comp_targets);
}

/**
 * update the component weights p(o)
 * @param epsilon is the KL bound
 * @param tau is the entropy coefficient
 * @return a tuple, s.t.
 * tuple[0] contains the KL D(p_new(o)||p_old(o))
 * tuple[1] contains the rewards for each component that was used during the optimization
 * tuple[2] contains a sample-estimate of the expected, unnormalized log-densities of the desired distribution
 */
  std::tuple<double,vec,vec> VIPS::update_weights(double epsilon, double tau, double entropy_bound) {
  mat reward = importance_weights_normalized %
               (repmat(target_densities.t(), model.getNumComponents(), 1) + (1 + tau) * log_responsibilities);
  // compute reward
  vec reward_per_option = sum(reward, 1) + (1+tau) * model.getEntropies();
  vec optimal_weights_greedy = reward_per_option - arma::max(reward_per_option);
  optimal_weights_greedy = optimal_weights_greedy  - log(sum(exp(optimal_weights_greedy)));

  // run optimization
  Reps reps_optimizer(optimal_weights_greedy.n_cols);
  reps_optimizer.set_bounds(epsilon, entropy_bound+1); //Todo: remove +1 if entropy bound actually corresponds to a bound
  reps_optimizer.set_target_dist(std::get<3>(model.getTargetsForKLBounds()));
  reps_optimizer.set_reward(optimal_weights_greedy );
  std::vector<double> initial{1, entropy_bound}; // Todo: warm-start
  int res = reps_optimizer.optimize(initial, true);

  // update model
  model.setWeights(reps_optimizer.p, reps_optimizer.log_p);
  recompute_densities(false, false);

  mat weighted_target_densities = importance_weights_normalized % repmat(target_densities.t(), model.getNumComponents(), 1);
  vec expected_target_densities = sum(weighted_target_densities,1);
  model.update_histories(expected_target_densities, reward_per_option, model.getWeights());
  return std::make_tuple(reps_optimizer.KL, reward_per_option, expected_target_densities);
}

/**
 * Adapts the KL bound based on the number of effective samples.
 * The KL bound for each component is set to min(max_kl_bound, factor * num_eff_samples(o))
 * @param max_kl_bound - hard upper bound for KL
 * @param factor - factor for computing the KL bound based on the number of effective samples
 */
vec VIPS::adapt_KL_bound_for_comp_update(double max_kl_bound, double factor) {
  mat responsibilities = exp(log_responsibilities);
  vec num_eff_samples = arma::square(arma::sum(importance_weights, 1)) / arma::sum(arma::square(importance_weights), 1);
  num_eff_samples.transform([](double val) { return (std::isnan(val) ? double(0) : val); });
  vec kl_bound_for_components = num_eff_samples * factor;
  kl_bound_for_components = arma::min(kl_bound_for_components, max_kl_bound * vec(model.getNumComponents(), fill::ones));
  kl_bound_for_components = arma::max(kl_bound_for_components, 1e-40 * vec(model.getNumComponents(), fill::ones));
  return kl_bound_for_components;
}

/**
 * Updates the components p(s|o)
 * @param max_kl_bound - hard upper bound for each KL bound
 * @param factor - factor for computing the KL bound for each component based on its number of effective samples
 * @param tau - entropy coefficient
 * @param ridge_coefficient - coefficient used for regularization when fitting the quadratic surrogate
 */
vec VIPS::update_components(double max_kl_bound, double factor, double tau, double ridge_coefficient,
                            vec entropy_bounds, double max_active_samples, bool dont_learn_correlations) {
  vec kl_bound_for_components = adapt_KL_bound_for_comp_update(max_kl_bound, factor);
  uvec indices = linspace<uvec>(0, model.getNumComponents() - 1, model.getNumComponents());
  vec last_etas = model.getLastEtasForCompOptimization();

  vec kl_changes(model.getNumComponents(), fill::zeros);

  arma::cube target_inv_chols;
  arma::cube target_chols;
  arma::mat target_means;
  arma::vec target_log_weights;
  arma::vec target_weights;
  std::tie(target_inv_chols, target_chols, target_means, target_weights,
           target_log_weights) = model.getTargetsForKLBounds();

  #pragma omp parallel for
  for (int i = 0; i < indices.n_rows; i++) {
    uvec active_samples = find(
            importance_weights_normalized.row(indices.at(i)) > (0.001 / importance_weights_normalized.n_cols));

    if (active_samples.n_rows > max_active_samples) {
        active_samples = shuffle(active_samples);
        active_samples = active_samples.tail_rows(max_active_samples);
    }
    if (active_samples.n_rows < num_dimensions) {
      cout << "component " << indices.at(i) << "was not updated, because it does not have enough active samples" << endl;
      if (importance_weights_normalized.has_nan())
        cout << "WIS weights contain NaNs" << endl;
      continue;
    }


    vec regression_weights = importance_weights_normalized.row(indices.at(i)).t();
    regression_weights = regression_weights.rows(active_samples);
    regression_weights /= sum(regression_weights);
    vec reward = target_densities + (1 + tau) * log_responsibilities.row(indices.at(i)).t();
    More more_optimizer(num_dimensions);
    bool success = more_optimizer.update_surrogate_normalizeData(regression_weights,
                                                                 samples.cols(active_samples).t(),
                                                                 reward.rows(active_samples),
                                                                 model.getCovs().slice(indices.at(i)),
                                                                 model.getMeans().col(indices.at(i)),
                                                                 ridge_coefficient,
                                                                 false,
                                                                 false,
                                                                 dont_learn_correlations);
    if (!success) {
      cout << "Fitting surrogate failed " << endl;
      continue;
    }
    more_optimizer.set_target_dist(target_chols.slice(indices[i]),
                                   target_inv_chols.slice(indices[i]),
                                   target_means.col(indices[i]));

    more_optimizer.set_bounds(kl_bound_for_components.at(indices.at(i)), entropy_bounds.at(indices.at(i))); // Tau is not optimized
    double initial_eta = last_etas.at(indices.at(i)) < 1e7 ? last_etas.at(indices.at(i)) : 1;
    std::vector<double> initial{initial_eta , 0};
    int res = more_optimizer.run_lbfgs_nlopt(initial, true);
    if (res < 0) {
      cout << "Optimizer failed " << endl;
      continue;
    }
    last_etas.at(indices.at(i)) = more_optimizer.eta;
    kl_changes.at(indices[i]) = more_optimizer.KL;
    model.changeComponent(indices.at(i), more_optimizer.chol_Sigma_p, more_optimizer.mu_p);

  }
  model.setLastEtasForCompOptimization(last_etas);
  recompute_densities(true, false);
  return kl_changes;
}

/**
* Adds new components.
* @params new_weights_total - new weights of the GMM (including existing components)
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* of the new components
*/
void VIPS::add_components(arma::vec new_weights_total, arma::mat new_means, arma::cube new_covs) {
  model.add_components(new_means, new_covs);
  model.setWeights(new_weights_total);
  recompute_densities();
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
double VIPS::get_entropy_estimate_on_active_samples() {
  vec weighted_importance_weights = log_densities_on_model - log_densities_on_background_dist;
  weighted_importance_weights -= arma::max(weighted_importance_weights);
  weighted_importance_weights -= log(sum(exp(weighted_importance_weights)));
  weighted_importance_weights = arma::exp(weighted_importance_weights);
  return - arma::sum(weighted_importance_weights % log_densities_on_model);
}

/**
 * Returns a Monte-Carlo estimate of the entropy of the learned model.
 * This methods draws new samples from the learned model and evaluated their log-densities log(p(x))
 * The entropy of the learned model is then approximated as H(p) \approx -1/N \sum_x log(p(x))
 * @see get_entropy_estimate_on_active_samples() for a faster, but usually less accurate estimate.
 * @param N - the number of samples that should be drawn for computing the estimate
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
double VIPS::get_entropy_estimate_on_gmm_samples(int N) {
  mat my_samples = std::get<0>(model.sample_from_mixture(N, 1.0));
  vec my_log_densities = model.evaluate_GMM_densities(my_samples, true);
  return - 1.0/(double)N * arma::sum(my_log_densities);
}

/**
* Get various densities, importance weights, etc. for debug purposes
* @return a tuple, st.
* tuple[0] contains the samples
* tuple[1] contains the unnormalized target densities
* tuple[2] contains the log densities on each model p(s|o)
* tuple[3] contains the joint log densities p(s,o)
* tuple[4] contains the GMM densities p(s)
* tuple[5] contains the log responsibilities p(o|s)
* tuple[6] contains the densitis on the background distribution q(s)
* tuple[7] contains the importance weights
* tuple[8] contains the normalized importance weights
*/
std::tuple<mat, vec, mat, mat, vec, mat, mat, mat, mat> VIPS::get_debug_info() {
    mat all_samples = sampleDatabase.getSamples();
    vec all_target_densities = sampleDatabase.getTargetDensities();
    return make_tuple( all_samples, all_target_densities, log_densities_on_model_comps, log_joint_densities,
    log_densities_on_model, log_responsibilities, log_densities_on_background_dist,
    importance_weights, importance_weights_normalized);
}

// Getters
int VIPS::getNumSamples() {return num_samples;}