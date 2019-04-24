#ifndef VIPS_MODEL_H
#define VIPS_MODEL_H

#include "GMM.h"
#include <tuple>

class VIPS_Model : public GMM {
protected:
    double initial_kl_bound;

    arma::vec last_etas_for_comp_optimization;
    arma::vec ridge_multiplier;
    arma::vec kl_bounds;

    // target distributions for the KL-bounds
    arma::cube target_inv_chols;
    arma::cube target_chols;
    arma::mat target_means;
    arma::vec target_log_weights;
    arma::vec target_weights;

    void add_meta_info_for_components(int N);

public:
    VIPS_Model(int dim, double initial_kl_bound=0.5);

    arma::vec expected_rewards;
    arma::mat comp_etd_history;
    arma::mat comp_reward_history;
    arma::mat comp_weight_history;
    arma::umat comp_num_samples_history;

    void add_components (arma::mat new_means, arma::cube new_covs) override;

    void add_components_invChols(arma::mat new_means, arma::cube new_invChols) override;

    void delete_component(int index) override;

    uvec delete_low_weight_components(double min_weight, int n_del=300);

    void update_histories(vec expected_target_densities, vec component_rewards, vec component_weights);

    void update_num_sample_history(uvec new_samples);

    std::tuple<arma::cube, arma::cube, arma::mat, arma::vec, arma::vec> getTargetsForKLBounds();

    void
    update_targets_for_KL_bounds(uvec component_indices, bool update_weight_targets, bool update_comp_targets);

    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

// Getters and Setters
    arma::vec getLastEtasForCompOptimization();
    void setLastEtasForCompOptimization(vec new_lastEtas);
    arma::vec getRidgeMultipliers();
    void setRidgeMultipliers(vec new_ridgeMultipliers);
    arma::vec getApproxRewardBeforeCompUpdate();
    void setApproxRewardBeforeCompUpdate(vec new_expected_rewards);
    arma::vec getKLBounds();
    void setKLBounds(vec new_KLBounds);
};
#endif