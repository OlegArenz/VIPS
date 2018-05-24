#ifndef VIPS_MODEL_H
#define VIPS_MODEL_H

#include "GMM.h"
#include <tuple>

class VIPS_Model : public GMM {
protected:
    arma::vec last_etas_for_comp_optimization;

    // target distributions for the KL-bounds
    arma::cube target_inv_chols;
    arma::cube target_chols;
    arma::mat target_means;
    arma::vec target_log_weights;
    arma::vec target_weights;

/**
* The VIPS-model stores various meta-information for each component, e.g. KL bounds,
* the target distributions for the KL constraint and some debug data like the history of achieved rewards.
* This function will enlarge the matrices/vector that store this meta-information in order to account for
* newly added components.
* @param N - the number of new components that have been added
*/
    void add_meta_info_for_components(int N);

public:
    VIPS_Model(int dim);


    arma::mat comp_etd_history;
    arma::mat comp_reward_history;
    arma::mat comp_weight_history;

/**
* Adds new components.
* The weights will be initialized close to zero
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* of the new components
*/
    void add_components (arma::mat new_means, arma::cube new_covs) override;

/**
* Adds new components. Second parameter is interpreted as inverse cholesky matrix.
* The weights will be initialized close to zero
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_InvChols - cube of size N_dimensions x N_dimensions x N_newComponents specifying the inverse cholesky matrices
* of the new components
*/
    void add_components_invChols(arma::mat new_means, arma::cube new_invChols) override;

/**
* Delete the components given by the indices and renormalize the weights afterwards.
* @params index specifying which component to delete
*/
    void delete_component(int index) override;

/**
 * Removes all components with weight below the given threshold that did not exceed that threshold during the last n_del iterations.
 * Weights are normalized afterwards.
 * @param min_weight - threshold for keeping components
 * @param n_del - number of most recent EM iterations to be considered
 */
void delete_low_weight_components(double min_weight, int n_del=300);

/**
* Adds the expected target densities to the reward history for each component.
* @param expected_target_densities - E_o[log(f(x)] for each component o.
* @param component_rewards - the reward that was used for updating the weights (includes entropy and log-responsibilities)
* @param component_weights - the current mixture weights for each component
*/
void update_histories(vec expected_target_densities, vec component_rewards, vec component_weights);

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
    std::tuple<arma::cube, arma::cube, arma::mat, arma::vec, arma::vec> getTargetsForKLBounds();

/**
* Sets - for some components - the current components p(s|o) and the current weight distribution p(o) as the target for the respective
* KL bounds.
* @param component_indices - indices of those components that are to be updated
* @param update_weight_targets - only update the weight targets if this is set to true
* @param update_comp_targets - only update the component targets if this ist set to true
*/
    void
    update_targets_for_KL_bounds(uvec component_indices, bool update_weight_targets, bool update_comp_targets);
/**
* Sets the current components p(s|o) and the current weight distribution p(o) as the target for the respective
* KL bounds.
* @param update_weight_targets - only update the weight targets if this is set to true
* @param update_comp_targets - only update the component targets if this ist set to true
*/
    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

// Getters and Setters
    arma::vec getLastEtasForCompOptimization();
    void setLastEtasForCompOptimization(vec new_lastEtas);
};
#endif