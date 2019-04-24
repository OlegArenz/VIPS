/*! \mainpage Variational Inference by Policy Search
 *
 * For API documentation, we recommend starting at VIPS or VIPS_PythonWrapper.<br>
 * For more details about the algorithm, a link to the paper as well as installation instructions we refer to the <a href="https://github.com/OlegArenz/VIPS">project page</a>
 */

#include "VIPS.h"
#include "Reps.h"
#include "More.h"
#include "Utils.h"

#include <omp.h>

using namespace std;
using namespace arma;

/**
 * Main class implementing the Learn-To-Sample algorithm
 * @param num_dimensions - dimensionality of the sampling problem
 * @param num_threads - number of threads to use
 * @min_kl_bound - the adaptive KL bound will not be set smaller than this threshold
 * @max_kl_bound - the adaptive KL bound will not be set higher than this threshold
 */
VIPS::VIPS(int num_dimensions, int num_threads, double min_kl_bound, double max_kl_bound)
        : model(num_dimensions), sampleDatabase(num_dimensions), num_dimensions(num_dimensions),
          min_kl_bound(min_kl_bound), max_kl_bound(max_kl_bound),
          num_threads(num_threads), num_samples(0), samples(num_dimensions, 0), target_densities(),
          backgroundDistribution(num_dimensions), active_samples() {
  omp_set_num_threads(num_threads);
  arma_rng::set_seed_random();
}

VIPS::~VIPS(void) {};

/**
 * For a given component, find the best interpolation between the current covariance matrix and a spherical one using a linear linesearch. <br>
 * The quality of the covariance matrix is estimated based on an importance weighted Monte Carlo estimate of the expected loglikelihood on the target distribution. <br>
 * The Monte Carlo estimate is computed based on a given set of samples, the corresponding target loglikelihoods and the loglikelihood of the sampling distribution. <br>
 * IMPORTANT: This method will change the component to the best interpolation. <br>
 * @param index - index specifying which component of the current model should be adapted <br>
 * @param my_samples - samples for the Monte Carlo estimate <br>
 * @param my_lnpdfs - vector containing the loglikelihood under the target distribution for each sample <br>
 * @param bg_lnpdfs - vector containing the loglikelihood of the distribution that was used for drawing the samples <br>
 * @param scaling_factor - the spherical covariance matrix is given by scaling_factor * eye() <br>
 */
void VIPS::getBestInterpolation(int index, mat my_samples, vec my_lnpdfs, vec bg_lnpdfs, double scaling_factor) {
    mat newest_cov = model.getCovs().slice(index);
    mat spherical(num_dimensions, num_dimensions, fill::eye);
    spherical = spherical * scaling_factor;
    mat best_chol = sqrt(spherical);
    double best_rew=-datum::inf;
    cout << "Finding best interpolation between spherical covariance and average covariance..." << endl;
    for (int i=0; i<21; i++) {
        double weight_spherical = 0.05 * i;
        mat interpolated = (1-weight_spherical) * spherical + weight_spherical * newest_cov;
        mat chol_interpolated = chol(interpolated, "lower");
        vec logdensities = gaussian_pdf(inv(chol_interpolated), my_samples.each_col() - model.getMeans().col(index), true);
        vec my_importance_weights = logdensities - bg_lnpdfs;
        vec my_importance_weights_normalized = my_importance_weights - arma::max(my_importance_weights);
        my_importance_weights_normalized -= log(sum(exp(my_importance_weights_normalized)));
        my_importance_weights_normalized = exp(my_importance_weights_normalized);
        if (dot(my_importance_weights_normalized,my_lnpdfs) > best_rew){
            best_rew = dot(my_importance_weights_normalized, my_lnpdfs);
            best_chol = chol_interpolated;
            cout << "best rew: " << best_rew << " with step size " << weight_spherical << endl;
        }
    }
    model.changeComponent(index, best_chol, model.getMeans().col(index));
}


/**
 * Selects promising locations among the current samples and create new components at these positions.
 * The covariance matrices are given by the weighted sums of the covariance matrices current model
 * (and afterwards rescaled by cov_scaling_factor), where the weights are given by the responsibilities
 * of the model components for the new location.
 * Locations are promising if the residual given by
 * residual = log(p_intractable(x)) - log(p_model(x) + exp(max_exploration_bonus))
 * is high.
 *
 * @param N - the number of samples to be promoted
 * @param max_exploration_bonus - maximum bonus for samples that have low density on the current model
 * @param tau - can be used to assign higher weight to the bonus for samples that have low density on the current model
 * @param only_check_active_samples - if set to true, the residual is computed on the active samples only,
 * otherwise, the resiudal is computed for all samples in the sample database.
 * @param max_samples - maximum number of samples to be considered
 * @param scale_entropy - if true, scale the entropy of the newly created component such that it corresponds to the average entropy \sum_o p(o) H(p(x|o))
 * @param isotropic - if true, initialize new components as isotropic (identity-matrix if scale_entropy = False) instead of interpolating.
 */
void VIPS::promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples, bool scale_entropy, bool isotropic) {
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
    my_target_densities = sampleDatabase.getTargetDensities();

    if (my_samples.n_cols > max_samples) {
        uvec shuffled = shuffle(linspace<uvec>(0, my_samples.n_cols - 1, my_samples.n_cols));
        my_samples = my_samples.cols(shuffled.head_rows(max_samples));
        my_target_densities = my_target_densities.rows(shuffled.head_rows(max_samples));
    }
    available_indices = linspace<uvec>(0, my_samples.n_cols - 1, my_samples.n_cols);
    my_log_densities_on_model = model.evaluate_GMM_densities_low_mem(my_samples);
    my_log_densities_on_model -= arma::max(my_log_densities_on_model);
  }

  residual = arma::min(my_target_densities - (1+tau) * my_log_densities_on_model,my_target_densities + max_exploration_bonus);

  uvec chosen_indices(N, fill::none);
  int num_added_components;
  for (num_added_components = 0; num_added_components < N; num_added_components++) {
    int best_index = residual.index_max();
    chosen_indices.at(num_added_components) = best_index;
    int this_index = as_scalar(available_indices.at(best_index));
    model.add_components_at_locations(my_samples.col(this_index), scale_entropy, isotropic);

    // ignore all samples that are covered by the newly added component
    if (num_added_components < N-1) {
        vec this_densities = model.compute_component_densities(model.getNumComponents() - 1, my_samples, true);
        this_densities -= arma::max(this_densities);
        residual = arma::min(residual - this_densities,residual + max_exploration_bonus);
      //  uvec covered_samples = find(this_densities > as_scalar(arma::max(this_densities) - 50));
      //  residual.rows(covered_samples).fill(-datum::inf);
    }
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
* Adds new samples to the database.<br>
* Note that the samples will not be used for learning, until they have been activated
* The samples are assumed to have been drawn from the current model and the indices of the relevant components
* are to be provided for computing background distributions when necessary.<br>
* @see activate_newest_samples
* @param new_samples - a matrix of size N_dimensions X N_samples
* @param new_target_densities - a vector of size N_samples containing the unnormalized densities on the target distribution
* @param used_components - a vector of size N_samples containing the indices of the components the corresponding samples have been drawn from
*/
void VIPS::add_samples_to_database(arma::mat new_samples, arma::vec new_target_densities, arma::uvec used_components){
 /* cube usedInvChols(num_dimensions, num_dimensions, used_components.n_rows, fill::none);
  cube usedCovs(num_dimensions, num_dimensions, used_components.n_rows, fill::none);
  for (int i = 0; i < used_components.n_rows; i++) {
    usedInvChols.slice(i) = model.getInvChols().slice(used_components.at(i));
    usedCovs.slice(i) = model.getCovs().slice(used_components.at(i));
  } */
  uvec counts = hist(used_components, linspace<uvec>(0,model.getNumComponents()-1,model.getNumComponents()));
  model.update_num_sample_history(counts);
  sampleDatabase.add_samples(new_samples, new_target_densities, model, used_components);
}

/**
* Computes the importance weights q(x|o) / q_bg(x) for each component q(x|o) and the background-mixture q_bg(x) for
* the active set of samples.
* This method updates the class members importance_weights, log_importance_weights and importance_weights_normalized.
*/
void VIPS::update_importance_weights() {
    std::tie(log_joint_densities, log_densities_on_model_comps) = model.compute_joint_densities(samples, true);
    log_densities_on_background_dist = backgroundDistribution.evaluate_GMM_densities_low_mem(samples);
    mat log_importance_weights =
          log(1.0 / num_samples) +
          (log_densities_on_model_comps - repmat(log_densities_on_background_dist.t(), model.getNumComponents(), 1));


    importance_weights = arma::exp(log_importance_weights);
    importance_weights_normalized = log_importance_weights.each_col() - arma::max(log_importance_weights, 1);
    importance_weights_normalized = importance_weights_normalized.each_col() - log(sum(exp(importance_weights_normalized), 1));
    importance_weights_normalized = exp(importance_weights_normalized);
}


/**
 * Recomputes the densities of various distributions as well as the importance weights.<br>
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
      log_densities_on_background_dist = backgroundDistribution.evaluate_GMM_densities_low_mem(samples);
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
 * This function is used for building a mixture model for importance sampling.<br>
 * For each component p(x|o) in the current approximation, iteratively sample num_comps components p(x|i) from the sample database
 * (these have been used for drawing samples before) according to p \propto p(mu_i|o) - n_usages
 * Adds all samples from each chosen component and stops if num_samples are selected <br>
 * The member active_samples is updated to contain the chosen samples <br>
 * @param num_comps - maximum number of components that should be selected for each component in the approximation
 * @param num_samples - stop after num_samples ahve been activated
 * @param temperature - temperature for scaling the probability for sampling components
 * @returns a vector containing the number of effective samples for each component
 */
arma::vec VIPS::select_active_samples(int num_comps, int num_samples, double temperature) {
 // fmat KLs;
//  int offset;
//  std::tie(KLs, offset) = sampleDatabase.compute_KLs_between_GMM_and_DB_components(model, reverse_KL, 500);

  int offset=0;
  fmat densitiesOnBgMeans = arma::conv_to<fmat>::from(std::get<1>(model.compute_joint_densities(sampleDatabase.getMeans(), true)));
  vec num_sampling_usages = sampleDatabase.getNumSamplingUsages();
  num_sampling_usages = num_sampling_usages.tail_rows(num_sampling_usages.n_rows - offset);
  active_samples = uvec();
  uvec used_components = uvec();
  for (int i=0; i < densitiesOnBgMeans.n_rows; i++) {
    uvec newly_selected = sample_without_replacement(temperature* (densitiesOnBgMeans.row(i).t() - 1. * num_sampling_usages), num_comps);
    uvec this_active;
    uvec this_used_components;
    std::tie(this_active, this_used_components) = (sampleDatabase.select_top_N_samples(newly_selected+offset, num_samples));
    active_samples = join_vert(active_samples, this_active);
    used_components = join_vert(used_components, this_used_components);

  //  cout << "used components for modelcomp " << i << ": " << this_used_components.t() << endl;
  //  cout << "mean: " << sampleDatabase.getMeans(used_components) << endl;
  }
 //    cout << "used components: " << used_components.t() << endl;
 //   cout << "KLs: " << KLs << endl;
 //   cout << "num_sampling_usages: " << num_sampling_usages.t() << endl;
  //cout << "active samples: " << sort(active_samples.t()) << endl;
  std::tie(samples, target_densities, backgroundDistribution, active_samples) = sampleDatabase.activate_samples(active_samples);
  sampleDatabase.update_component_usages(unique(used_components));
  this->num_samples = samples.n_cols;

  if (this->num_samples == 0) {
    target_densities = vec();
    log_joint_densities = vec();
    log_densities_on_model_comps = mat(model.getNumComponents(),0);
    offsets_for_model_joint_densities = rowvec(model.getNumComponents(), fill::zeros);
    sum_of_joint_densities_with_offsets =  rowvec();
    log_densities_on_model = vec();
    log_responsibilities = mat(model.getNumComponents(),0);
    return vec(model.getNumComponents(), fill::zeros);
  }
  //recompute_densities();
  update_importance_weights();
  //mat responsibilities = exp(log_responsibilities);
  vec num_eff_samples = arma::square(arma::sum(importance_weights, 1)) / arma::sum(arma::square(importance_weights), 1);
 /* if (num_eff_samples.has_nan()) {
    cout << arma::square(arma::sum(importance_weights, 1)) << " " << arma::sum(arma::square(importance_weights), 1) << endl;
  }*/
  return num_eff_samples;
}


/**
 * Selects the N most recent samples and activates them (i.e. uses them for the upcoming learning iteration).<br>
 * Makes sure, that all relevant data (e.g. densities, importance weights, etc.) gets updated
 * @param N - the maximum number of recent samples to be activated, actually number of activated samples
 * might be less, iff the sample database does not contain sufficient samples.
 * @param keep_old - if set to true, the samples that are currently active will remain active
 */
  void VIPS::activate_newest_samples(int N, bool keep_old) {
  if (keep_old) {
    uvec newest_samples;
    int num_total_samples = sampleDatabase.getNumSamples();
    if (N >= num_total_samples)
        newest_samples = linspace<uvec>(0, num_total_samples-1, num_total_samples);
    else
        newest_samples = linspace<uvec>(num_total_samples-N, num_total_samples-1, N);

    mat log_densities_of_newest_samples = std::get<1>(model.compute_joint_densities(sampleDatabase.getSamples(newest_samples),true));
    mat log_densities_of_active_samples = join_horiz(log_densities_on_model_comps, log_densities_of_newest_samples);
    active_samples = join_vert(active_samples, newest_samples);
    uvec unique_samples = find_unique(active_samples);
    log_densities_on_model_comps = log_densities_of_active_samples.cols(unique_samples);
    active_samples = active_samples.rows(unique_samples);
    std::tie(samples, target_densities, backgroundDistribution, active_samples) = sampleDatabase.activate_samples(active_samples);

    num_samples = samples.n_cols;
    recompute_densities(false, true);
  }
  else {
    std::tie(samples, target_densities, backgroundDistribution, active_samples) = sampleDatabase.select_newest_samples(N);
    num_samples = samples.n_cols;
    recompute_densities();
  }
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
 * update the component weights p(o).
 * @param epsilon is the KL bound
 * @param tau is the entropy coefficient
 * @param entropy bound - has no effect if be_greedy is true.
 * @param be_greedy - if true, don't perform KL-bound optimization but use the greedy optimal weights
 * @return a tuple, s.t.
 * tuple[0] contains the KL D(p_new(o)||p_old(o))
 * tuple[1] contains the rewards for each component that was used during the optimization
 * tuple[2] contains a sample-estimate of the expected, unnormalized log-densities of the desired distribution
 */
  std::tuple<double,vec,vec> VIPS::update_weights(double epsilon, double tau, double entropy_bound, bool be_greedy) {
  mat reward = importance_weights_normalized %
               (repmat(target_densities.t(), model.getNumComponents(), 1) + (1 + tau) * log_responsibilities);
  // compute reward
  vec reward_per_option = sum(reward, 1) + (1+tau) * model.getEntropies();

  vec kl_bounds = model.getKLBounds();
  for (int i=0; i<model.getNumComponents(); i++) {
    if (reward_per_option.at(i) < model.getApproxRewardBeforeCompUpdate().at(i))
        kl_bounds.at(i) = std::max(min_kl_bound, 0.8 * as_scalar(kl_bounds.at(i)));
    else
        kl_bounds.at(i) = std::min(max_kl_bound, 1.1 * as_scalar(kl_bounds.at(i)));
  }

  model.setKLBounds(kl_bounds);

  vec optimal_weights_greedy = reward_per_option - arma::max(reward_per_option);
  optimal_weights_greedy = optimal_weights_greedy  - log(sum(exp(optimal_weights_greedy)));

  double kl;
  if (be_greedy) {
    model.setWeights(exp(optimal_weights_greedy), optimal_weights_greedy);
    kl = 1e3; //ToDo return actual KL
  } else {
  // run optimization
  Reps reps_optimizer(optimal_weights_greedy.n_cols);
  reps_optimizer.set_bounds(epsilon, entropy_bound+1); //Todo: remove +1 if entropy bound actually corresponds to a bound
  reps_optimizer.set_target_dist(std::get<3>(model.getTargetsForKLBounds()));
  reps_optimizer.set_reward(optimal_weights_greedy );
  std::vector<double> initial{1, entropy_bound}; // Todo: warm-start
  int res = reps_optimizer.optimize(initial, true);

  // update model
  model.setWeights(reps_optimizer.p, reps_optimizer.log_p);

  kl = reps_optimizer.KL;
  }
  recompute_densities(false, false);

  mat weighted_target_densities = importance_weights_normalized % repmat(target_densities.t(), model.getNumComponents(), 1);
  vec expected_target_densities = sum(weighted_target_densities,1);
  model.update_histories(expected_target_densities, reward_per_option, model.getWeights());
  return std::make_tuple(kl, reward_per_option, expected_target_densities);
}

/**
 * Adapts the KL bound based on the number of effective samples.<br>
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
 * Updates the components p(s|o).
 * @param max_kl_bound - hard upper bound for each KL bound
 * @param factor - factor for computing the KL bound for each component based on its number of effective samples
 * @param tau - entropy coefficient
 * @param ridge_coefficient - coefficient used for regularization when fitting the quadratic surrogate
 * @param entropy_bounds - lower bound on entropy
 * @param max_active_samples - size of the subset of samples that should be used for each component update
 * @param dont_learn_correlations - iff true, fit a quadratic surrogate where R is diagonal (experimental)
 * @param dont_recompute_densities - do not recompute the densities after the component update
 * @param adapt_ridge_multipliers - if true, the ridge_coefficient will be adapted for each component
 */
vec VIPS::update_components(double tau, double ridge_coefficient,
                            vec entropy_bounds, double max_active_samples, bool dont_learn_correlations, bool dont_recompute_densities, bool adapt_ridge_multipliers) {
  uvec indices = linspace<uvec>(0, model.getNumComponents() - 1, model.getNumComponents());
  vec last_etas = model.getLastEtasForCompOptimization();
  vec ridge_multipliers = model.getRidgeMultipliers();
  vec kl_bounds = model.getKLBounds();
  vec kl_changes(model.getNumComponents(), fill::zeros);
  arma::cube target_inv_chols;
  arma::cube target_chols;
  arma::mat target_means;
  arma::vec target_log_weights;
  arma::vec target_weights;
  std::tie(target_inv_chols, target_chols, target_means, target_weights,
           target_log_weights) = model.getTargetsForKLBounds();

  mat reward = importance_weights_normalized %
               (repmat(target_densities.t(), model.getNumComponents(), 1) + log_responsibilities);
  vec new_expected_rewards = sum(reward, 1) + model.getEntropies();
  model.setApproxRewardBeforeCompUpdate(new_expected_rewards);

  #pragma omp parallel for
  for (int i = 0; i < indices.n_rows; i++) {

    vec tmp = importance_weights_normalized.row(indices.at(i)).t();
    vec relevant_samples = sort(tmp, "descend");
    vec cumSum = cumsum(relevant_samples);
    int first_irrelevant = as_scalar(find(cumSum > 0.999, 1, "first"));
    uvec my_active_samples =  find(
            importance_weights_normalized.row(indices.at(i)) >= relevant_samples.at(first_irrelevant));

    mat my_samples = samples.cols(my_active_samples);

    vec regression_weights = importance_weights_normalized.row(indices.at(i)).t();
    regression_weights = regression_weights.rows(my_active_samples);
    regression_weights /= sum(regression_weights);

    if (my_active_samples.n_rows < num_dimensions) {
      cout << "component " << indices.at(i) << "was not updated, because it has only " << my_active_samples.n_rows << " active samples"<< endl;
      if (importance_weights_normalized.has_nan())
        cout << "WIS weights contain NaNs" << endl;
      continue;
    }

    vec reward = target_densities + (1 + tau) * log_responsibilities.row(indices.at(i)).t();
    More more_optimizer(num_dimensions);
    bool success = more_optimizer.update_surrogate_CenterOnTrueMean(regression_weights,
                                                                 my_samples.t(),
                                                                 reward.rows(my_active_samples),
                                                                 model.getMeans().col(indices.at(i)),
                                                                 ridge_multipliers.at(indices.at(i)) * ridge_coefficient,
                                                                 true,
                                                                 false,
                                                                 dont_learn_correlations);
    if (!success) {
      cout << "Fitting surrogate failed " << endl;
      ridge_multipliers.at(indices.at(i)) = std::min(1e8,10 * ridge_multipliers.at(indices.at(i)));
      continue;
    }
    more_optimizer.set_target_dist(target_chols.slice(indices[i]),
                                   target_inv_chols.slice(indices[i]),
                                   target_means.col(indices[i]));

    more_optimizer.set_bounds(kl_bounds.at(indices.at(i)), entropy_bounds.at(indices.at(i))); // Tau is not optimized
    double initial_eta = last_etas.at(indices.at(i)); // < 1e7 ? last_etas.at(indices.at(i)) : 1;
    std::vector<double> initial{initial_eta , 0};
    int res = more_optimizer.run_lbfgs_nlopt(initial, true);
    if (res < 0) {
      if (initial_eta > 1e7) {
          // Maybe initial eta is so high that it causes numerical problem, so we also try with small initial value
          initial_eta =1;
          std::vector<double> initial{1 , 0};
          res = more_optimizer.run_lbfgs_nlopt(initial, true);
      }
      if (res < 0) {
          cout << "Optimizer failed " << endl;
          last_etas.at(indices.at(i)) *= 10;
          continue;
      }
    }
    ridge_multipliers.at(indices.at(i)) = std::max(1.,0.5 * ridge_multipliers.at(indices.at(i)));
    last_etas.at(indices.at(i)) = more_optimizer.eta;
    kl_changes.at(indices[i]) = more_optimizer.KL;
    model.changeComponent(indices.at(i), more_optimizer.chol_Sigma_p, more_optimizer.mu_p);
 }
  model.setLastEtasForCompOptimization(last_etas);
  if (adapt_ridge_multipliers)
    model.setRidgeMultipliers(ridge_multipliers);
  if (!dont_recompute_densities)
    recompute_densities(true, false);

  return kl_changes;
}

/**
* Adds new components.
* @param new_weights_total - new weights of the GMM (including existing components)
* @param new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @param new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* @param dont_recompute_densities - if true, do not update the marginals, responsibilities, etc after adding a new component
* of the new components
*/
void VIPS::add_components(arma::vec new_weights_total, arma::mat new_means, arma::cube new_covs, bool dont_recompute_densities) {
  model.add_components(new_means, new_covs);
  model.setWeights(new_weights_total);
  if (!dont_recompute_densities)
    recompute_densities();
}

/**
 * Returns a (weighted importance sampling) Monte-Carlo estimate of the entropy of the learned model.
 * The entropy is computed based on the active samples.
 * As this entropy is computed based on precomputed values [importance weights and log(p(x))] th evaluation is very
 * fast.
 * However, if the number of active samples is still low or the samples are not "fresh" (low importance weights),
 * the estimate can be quite bad.
 * see get_entropy_estimate_on_gmm_samples() for a slower, but usually more accurate estimate.
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 * @see get_entropy_estimate_on_gmm_samples()
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
 * This methods draws new samples from the learned model and evaluated their log-densities log(p(x)).
 * The entropy of the learned model is then approximated as H(p) \approx -1/N \sum_x log(p(x)).
 * see get_entropy_estimate_on_active_samples() for a faster, but usually less accurate estimate.
 * @param N - the number of samples that should be drawn for computing the estimate
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 * @see get_entropy_estimate_on_active_samples()
 */
double VIPS::get_entropy_estimate_on_gmm_samples(int N) {
  mat my_samples = std::get<0>(model.sample_from_mixture(N, 1.0));
  vec my_log_densities = model.evaluate_GMM_densities(my_samples, true);
  return - 1.0/(double)N * arma::sum(my_log_densities);
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
uvec VIPS::getActiveSamples() {return active_samples;}
