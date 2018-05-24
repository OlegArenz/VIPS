#include "VIPS_Model.h"
#include <stdexcept>

using namespace std; // ToDo: Make all std calls explicit and remove
using namespace arma;

VIPS_Model::VIPS_Model(int dim)
        : GMM(dim), last_etas_for_comp_optimization(), target_inv_chols(dim, dim, 0),
          target_chols(dim, dim, 0), target_means(dim, 0), target_weights(), target_log_weights(),
          comp_reward_history(), comp_etd_history(), comp_weight_history() {}


arma::vec VIPS_Model::getLastEtasForCompOptimization() { return last_etas_for_comp_optimization; }

/**
* store the Lagrangian parameters that have been learned during the last model update for warm-starting.
* @param new_lastEtas - Lagrangian parameters for the KL constraints for the component update
*/
void VIPS_Model::setLastEtasForCompOptimization(vec new_lastEtas) {
  if (new_lastEtas.n_rows == num_components) {
    last_etas_for_comp_optimization = new_lastEtas;
  } else {
    throw std::invalid_argument("VIPS_Model::setLastEtasForCompOptimization: Vector has wrong size");
  }
}

/**
* The VIPS-model stores various meta-information for each component, e.g. KL bounds,
* the target distributions for the KL constraint and some debug data like the history of achieved rewards.
* This function will enlarge the matrices/vector that store this meta-information in order to account for
* newly added components.
* @param N - the number of new components that have been added
*/
void VIPS_Model::add_meta_info_for_components(int N) {
  // update last learned etas for warm-starting
  last_etas_for_comp_optimization = join_cols(last_etas_for_comp_optimization, vec(N, fill::ones));

  // update targets for KL bounds
  int old_num_components = target_inv_chols.n_slices;

  target_inv_chols.insert_slices(old_num_components, N, false);
  target_chols.insert_slices(old_num_components, N, false);
  target_means.insert_cols(old_num_components, N, false);
  target_weights.insert_rows(old_num_components, N, false);
  target_log_weights.insert_rows(old_num_components, N, false);
  uvec indices_of_new_comps = arma::linspace<uvec>(num_components - N, num_components - 1, N);
  update_targets_for_KL_bounds(indices_of_new_comps, true, true);

  // update reward history
  comp_reward_history.insert_rows(old_num_components, N, false);
  comp_reward_history.tail_rows(N).fill(-datum::inf);
  comp_etd_history.insert_rows(old_num_components, N, false);
  comp_etd_history.tail_rows(N).fill(-datum::inf);
  comp_weight_history.insert_rows(old_num_components, N, false);
  comp_weight_history.tail_rows(N).fill(datum::inf);
}

/**
* Adds the expected target densities to the reward history for each component.
* @param expected_target_densities - E_o[log(f(x)] for each component o.
* @param component_rewards - the reward that was used for updating the weights (includes entropy and log-responsibilities)
* @param component_weights - the current mixture weights for each component
*/
void VIPS_Model::update_histories(vec expected_target_densities, vec component_rewards, vec component_weights) {
    comp_etd_history = join_horiz(comp_etd_history, expected_target_densities);
    comp_reward_history = join_horiz(comp_reward_history, component_rewards);
    comp_weight_history = join_horiz(comp_weight_history, weights);
}

/**
* Adds new components.
* The weights will be initialized close to zero
 * @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
 * @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
 * of the new components
*/
void VIPS_Model::add_components(arma::mat new_means, arma::cube new_covs) {
  GMM::add_components(new_means, new_covs);
  add_meta_info_for_components(new_means.n_cols);
}

/**
* Adds new components. Second parameter is interpreted as inverse cholesky matrix.
* The weights will be initialized close to zero
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_InvChols - cube of size N_dimensions x N_dimensions x N_newComponents specifying the inverse cholesky matrices
* of the new components
*/
void VIPS_Model::add_components_invChols(arma::mat new_means, arma::cube new_invChols) {
  GMM::add_components_invChols(new_means, new_invChols);
  add_meta_info_for_components(new_means.n_cols);
}

/**
* Delete the components given by the indices and renormalize the weights afterwards.
* @params index specifying which component to delete
*/
void VIPS_Model::delete_component(int index) {
  GMM::delete_component(index);
  last_etas_for_comp_optimization.shed_row(index);
  target_inv_chols.shed_slice(index);
  target_chols.shed_slice(index);
  target_means.shed_col(index);
  target_log_weights.shed_row(index);
  target_weights.shed_row(index);
  comp_weight_history.shed_row(index);
  comp_reward_history.shed_row(index);
  comp_etd_history.shed_row(index);
}


/**
 * Removes all components with weight below the given threshold that did not exceed that threshold during the last n_del iterations.
 * Weights are normalized afterwards.
 * @param min_weight - threshold for keeping components
 */
void VIPS_Model::delete_low_weight_components(double min_weight, int n_del) {
  int n_hist = comp_weight_history.n_cols;
  if (n_hist < n_del)
    return;

  vec best_weights = arma::max(comp_weight_history.tail_cols(n_del), 1);
  uvec stagnating_indices = find(best_weights <= min_weight);
  delete_components(stagnating_indices);
}


/**
 * Sets - for some components - the current components p(s|o) and the current weight distribution p(o) as the target for the respective
 * KL bounds.
 * @param component_indices - indices of those components that are to be updated
 * @param update_weight_targets - only update the weight targets if this is set to true
 * @param update_comp_targets - only update the component targets if this ist set to true
 */
void
VIPS_Model::update_targets_for_KL_bounds(uvec component_indices, bool update_weight_targets, bool update_comp_targets) {
  for (int i = 0; i < component_indices.n_rows; i++) {
    int idx = component_indices.at(i);
    if (update_comp_targets) {
      target_inv_chols.slice(idx) = inv_chols.slice(idx);
      target_chols.slice(idx) = chols.slice(idx);
      target_means.col(idx) = means.col(idx);
    }
    if (update_weight_targets) {
      target_weights.row(idx) = weights.row(idx);
      target_log_weights.row(idx) = log_weights.row(idx);
    }
  }
}

/**
 * Sets the current components p(s|o) and the current weight distribution p(o) as the target for the respective
 * KL bounds.
 * @param update_weight_targets - only update the weight targets if this is set to true
 * @param update_comp_targets - only update the component targets if this ist set to true
 */
void VIPS_Model::update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets) {
  if (update_comp_targets) {
    target_inv_chols = inv_chols;
    target_chols = chols;
    target_means = means;
  }
  if (update_weight_targets) {
    target_log_weights = log_weights;
    target_weights = weights;
  }
}

/**
 * Return the component distributions and the weight distributions that we currently want to stay close to.
 *
 * @returns the following tuple:
 * tuple[0] - cube of size N_dimensions x N_dimensions x N_components containing inverse cholesky matrices
 * tuple[1] - cube of size N_dimensions x N_dimensions x N_components containing cholesky matrices
 * tuple[2] - matrix of size N_dimensions x N_components containing the means
 * tuple[3] - vector of size N_components containing the log_weights log(q(o))
 * tuple[4] - vector of size N_components containing the weights q(o)
 */
std::tuple<arma::cube, arma::cube, arma::mat, arma::vec, arma::vec> VIPS_Model::getTargetsForKLBounds() {
  return std::make_tuple(target_inv_chols, target_chols, target_means, target_log_weights, target_weights);
}


