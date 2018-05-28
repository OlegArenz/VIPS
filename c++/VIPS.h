#ifndef VIPS_VIPS_H
#define VIPS_VIPS_H
#define ARMA_DONT_PRINT_ERRORS

#include <armadillo>

#include <random>
#include "VIPS_Model.h"
#include "SampleDatabase.h"

class VIPS {

protected:
    int num_threads;
    int num_dimensions;

    // active samples (subset of total samples)
    int num_samples;
    arma::mat samples;
    arma::vec target_densities;

    // log-densities of active samples on various distributions
    arma::mat log_densities_on_model_comps;
    arma::mat log_joint_densities;
    arma::vec log_densities_on_model;
    arma::mat log_responsibilities;
    arma::mat log_densities_on_background_dist;
    arma::rowvec offsets_for_model_joint_densities;
    arma::rowvec sum_of_joint_densities_with_offsets;

    // importance weights of active samples
    arma::mat importance_weights;
    arma::mat importance_weights_normalized;

public:
    VIPS(int num_dimensions, int num_threads);

    ~VIPS(void);

    VIPS_Model model;
    GMM backgroundDistribution;
    SampleDatabase sampleDatabase;

    void delete_low_weight_components(double min_weight);

    void add_samples_to_database(arma::mat new_samples, arma::vec new_target_densities, arma::uvec used_components);

    void recompute_densities(bool update_log_densities_on_model_comps=true, bool update_log_densities_on_background_dist=true);

    void activate_newest_samples(int N);

    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

    void promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples);

    std::tuple<double,vec,vec> update_weights(double epsilon, double tau, double entropy_bound);

    arma::vec adapt_KL_bound_for_comp_update(double max_kl_bound, double factor);

    arma::vec update_components(double max_kl_bound, double factor, double tau, double ridge_coefficient,
                            vec entropy_bounds, double max_active_samples, bool dont_learn_correlations);

    void add_components(arma::vec new_weights_total, arma::mat new_means, arma::cube new_covs);

    double get_entropy_estimate_on_active_samples();

    double get_entropy_estimate_on_gmm_samples(int num_samples=10000);

    std::tuple<arma::mat, arma::vec, arma::mat, arma::mat, arma::vec, arma::mat, arma::mat, arma::mat, arma::mat>
        get_debug_info();

    // Getters
    int getNumSamples();

};
#endif