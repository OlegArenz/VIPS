#ifndef LTS_GMM_H
#define LTS_GMM_H

#define ARMA_DONT_PRINT_ERRORS

#include <armadillo>
#include <omp.h>
#include <tuple>


using namespace arma;

class GMM {

protected:
    double entropy_offset;

// Data related to the GMM
    int dim;
    int num_components;
    mat means;
    cube covs;
    cube chols;
    cube inv_chols;
    vec weights;
    vec log_weights;
    vec entropies;
    vec determinants;

// RNG (only used for sampling mixture components)
    std::default_random_engine rng;

    std::tuple<vec, vec, vec> softMax_2D(mat data);

public:
    int max_components;

    GMM(int dim, int max_components=100000);

    arma::cube interpolate_covs_for_query_points(mat query_points);

    virtual void add_components_at_locations(mat means);

    virtual void add_components(mat means, cube covs);

    virtual void add_components_invChols(mat new_means, cube new_invChols);

    void delete_components(uvec indices);

    virtual void delete_component(int index);

    void prune_to_max_components(uvec protected_components);

    void changeComponent(int index, mat newChol, vec newMean);

//--- Inference
    vec compute_component_densities(int idx, mat samples, bool return_log);

    std::tuple<mat, mat> compute_joint_densities(mat samples, bool return_log);

    vec evaluate_GMM_densities(mat samples, bool return_log);

    vec evaluate_GMM_densities_low_mem(mat samples);

    std::tuple<mat, mat, rowvec, rowvec, vec, mat> compute_log_marginals(mat samples);

    std::tuple<mat, rowvec, rowvec, vec, mat> compute_log_marginals_from_comp_densities(mat log_component_marginals);

    mat sample_from_component(int index, int n);

    std::tuple<mat, uvec> sample_from_mixture_weights(double N, vec new_weigths);

    std::tuple<mat, uvec> sample_from_mixture(int n, double temperature = 1.0);


//--- Setters and Getters
    void setWeights(vec new_weights);

    void setWeights(vec new_weights, vec new_log_weights);

    mat getMeans();

    mat getMeans(uvec indices);

    cube getCovs();

    cube getChols();

    cube getInvChols();

    vec getWeights();

    vec getLogWeights();

    vec getEntropies();

    vec getDeterminants();

    int getNumComponents();

    int getNumDimensions();
};

#endif