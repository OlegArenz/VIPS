#ifndef VIPS_VIPS_PYTHONWRAPPER_H
#define VIPS_VIPS_PYTHONWRAPPER_H

#include "VIPS.h"
#include <tuple>
#include <armadillo>

class VIPS_PythonWrapper {

protected:
    VIPS learner, learner_backup;
    int num_dimensions;

    arma::vec last_KLs_components;
    double last_KL_weights;

    arma::vec last_expected_rew;
    arma::vec last_expected_target_densities;
public:
    VIPS_PythonWrapper(int num_dimensions, int num_threads, double min_kl_bound, double max_kl_bound);
    ~VIPS_PythonWrapper(void);

    void add_components(
            double * new_weights_in, int new_weights_in_dim1,
            double * new_means_in, int new_means_in_dim1, int new_means_in_dim2,
            double * new_covs_in,  int new_covs_in_dim1, int new_covs_in_dim2, int new_covs_in_dim3);
    
    void promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples, bool scale_entropy=true, bool isotropic=false);

    void delete_low_weight_components(double min_weight, int n_del=300);

    void draw_samples(
            // inputs:
            double N, double temperature,
            // outputs:
            double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
            int **indices_out, int *indices_out_dim1);

    void draw_samples_weights(
        // inputs:
        double N,
        double * new_weights_in, int new_weights_in_dim1,
        // outputs:
        double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
        int **indices_out, int *indices_out_dim1
    );

void add_samples_mean_cov(
        // inputs:
        double *samples_ptr, int samples_dim1, int samples_dim2,
        double *target_densities_ptr, int td_dim1,
        double *mean_in, int mean_in_dim1,
        double *cov_in, int cov_in_dim1, int cov_in_dim2);

    void add_samples(
            // inputs:
            double * samples_ptr, int samples_dim1, int samples_dim2,
            int * indices_ptr, int indices_dim1,
            double * target_densities_ptr, int td_dim1
    );


    void activate_newest_samples(int N, bool keep_old);

    void select_active_samples(int num_comps, int num_samples, double temperature,
                            double ** num_eff_out_ptr, int * num_eff_out_dim1);

    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

    void update_weights(double epsilon, double tau, double max_entropy_decrease, bool be_greedy);

    void apply_lower_bound_on_weights(double * lb_weights_in, int lb_weights_in_dim1);

    void update_components(double tau, double ridge_coefficient,
                double max_entropy_decrease, double max_active_samples, bool dont_learn_correlations, bool dont_recompute_densities, bool adapt_ridge_multipliers);

    void recompute_densities(bool only_weights_changed);

    void get_model(
        //outputs
        double ** weights_out_ptr, int * weights_out_dim1,
        double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
        double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3);

    void get_model_entropies(
        //outputs
        double ** entropies_out_ptr, int * entropies_out_dim1);

    void get_background(
    //outputs
        double ** weights_out_ptr, int * weights_out_dim1,
        double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
        double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3);

    void get_last_KLs(
        //outputs
        double * KL_weights_out,
        double ** kls_comp_out, int * kls_comp_out_dim1);

    void get_weights(
        double ** weights_out_ptr, int * weights_out_dim1,
        double ** log_weights_out_ptr, int * log_weights_out_dim1
    );

    void get_num_samples(int * num_samples, int * num_samples_total);

    void get_expected_rewards(
        double ** expected_rewards_out, int * expected_rewards_out_dim1,
        double ** expected_target_densities_out, int * expected_target_densities_out_dim1,
        double ** comp_etd_history_out_ptr, int * comp_etd_history_out_dim1, int * comp_etd_history_out_dim2,
        double ** comp_reward_history_out_ptr, int * comp_reward_history_out_dim1, int * comp_reward_history_out_dim2
    );

    void get_best_interpolation(int index,
                                double * samples_ptr, int samples_dim1, int samples_dim2,
                                double *target_densities_ptr, int td_dim1,
                                double *target_densities2_ptr, int td2_dim1,
                                double scaling_factor
    );

    void get_log_densities_on_mixture(
            double * samples_ptr, int samples_dim1, int samples_dim2,
            double ** sample_densities_out, int * sample_densities_out_dim1
    );

    void get_entropy_estimate_on_active_samples(double * entropy);

    void get_entropy_estimate_on_gmm_samples(
            // output
            double * entropy,
            // input
            int num_samples=10000);

    void get_num_components(int * num_components_out);

    void get_debug_info(
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
    );

    void compute_KLs_between_GMM_and_DB_components(bool reverse_KL,
        float ** KL_mat_out_ptr, int * KL_mat_out_dim1, int * KL_mat_out_dim2);

    void backup_learner();

    void restore_learner();
};
#endif