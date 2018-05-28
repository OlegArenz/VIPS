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

    void add_meta_info_for_components(int N);

public:
    VIPS_Model(int dim);


    arma::mat comp_etd_history;
    arma::mat comp_reward_history;
    arma::mat comp_weight_history;

    void add_components (arma::mat new_means, arma::cube new_covs) override;

    void add_components_invChols(arma::mat new_means, arma::cube new_invChols) override;

    void delete_component(int index) override;

    void delete_low_weight_components(double min_weight, int n_del=300);

    void update_histories(vec expected_target_densities, vec component_rewards, vec component_weights);

    std::tuple<arma::cube, arma::cube, arma::mat, arma::vec, arma::vec> getTargetsForKLBounds();

    void
    update_targets_for_KL_bounds(uvec component_indices, bool update_weight_targets, bool update_comp_targets);

    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

// Getters and Setters
    arma::vec getLastEtasForCompOptimization();
    void setLastEtasForCompOptimization(vec new_lastEtas);
};
#endif