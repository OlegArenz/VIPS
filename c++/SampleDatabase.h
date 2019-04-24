#ifndef LTS_SAMPLEDATABASE_H
#define LTS_SAMPLEDATABASE_H

// These defines are used for hyperparameters we do not change
#define NUM_LAST_COMP_TO_CHECK 200

#include <armadillo>
#include <tuple>

#include "GMM.h"
#include "Utils.h"

class SampleDatabase {

protected:
    int num_dimensions;
    int num_latest_comp_to_check;

    // All samples that have been drawn
    int num_samples;
    arma::mat samples;
    arma::vec target_densities;
    // store for each sample the component that generated it
    arma::uvec map_samples_to_backgroundComp;

    // Store all Gaussians that produced samples
    int num_components;
    arma::vec num_sampling_usages;
    arma::mat means;
    arma::cube inv_chols;
    arma::cube covs;

    void add_component(arma::mat new_mean, arma::mat new_invChol, arma::mat new_Cov);

    int get_similar_component(arma::vec mean, arma::mat inv_chol, double tol = 1e-10);

public:

    SampleDatabase(int num_dimensions, int num_lates_comp_to_check=200);

    void add_samples(arma::mat new_samples, arma::mat new_target_densities, GMM gmm, arma::uvec map_samples_to_GMM_comp);

    void add_samples(arma::mat new_samples, arma::mat new_target_densities, arma::mat means, arma::cube inv_chols, arma::cube covs);

    std::tuple<arma::mat, arma::vec, GMM, arma::uvec> activate_samples(uvec active_samples);

    std::tuple<arma::mat, arma::vec, GMM, arma::uvec> select_newest_samples(int N);

    void update_component_usages(uvec component_indices);

    std::tuple<arma::uvec, arma::uvec> select_top_N_samples(uvec component_indices, int N);

    std::tuple<arma::fmat, int> compute_KLs_between_GMM_and_DB_components(GMM gmm, bool reverse_KL, int max_sampling_components=5000);

    GMM get_bg_dist(uvec active_samples);

    // Getters
    int getNumSamples();

    int getNumComponents();

    arma::mat getSamples();
    arma::mat getSamples(arma::uvec indices);

    arma::vec getTargetDensities();

    arma::mat getMeans();

    arma::mat getMeans(arma::uvec indices);

    arma::cube getInvChols();

    arma::cube getCovs();

    arma::vec getNumSamplingUsages();
};


#endif
