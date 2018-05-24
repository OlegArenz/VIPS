#ifndef LTS_SAMPLEDATABASE_H
#define LTS_SAMPLEDATABASE_H

// These defines are used for hyperparameters we do not change
#define NUM_LAST_COMP_TO_CHECK 200

#include <armadillo>
#include <tuple>

#include "GMM.h"

/**
 * A SampleDatabase keeps track of samples and the Gaussian distributions that generated them.
 * This information is used to create a concise GMM background distribution that can be used
 * for computing importance weights.
*/
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
    arma::mat means;
    arma::cube inv_chols;

    /**
    * Add a new component and allocate additional memory if necessary.
    * The weights do not need to be specified, but are computed dynamically based on the number of usages
    */
    void add_component(arma::mat new_mean, arma::mat new_invChol);

    /**
    * Check whether a component with similar mean and covariance (inverse cholesky is checked) exists
    * Only considers the NUM_LAST_COMP_TO_CHECK most recently added components for performance reasons
    * Returns:
    * -1, iff no similar component exists
    * the index to a similar component, otherwise
    */
    int get_similar_component(arma::vec mean, arma::mat inv_chol, double tol = 1e-10);

public:
/**
 * A SampleDatabase keeps track of samples and the Gaussian distributions that generated them.
 * This information is used to create a concise GMM background distribution that can be used
 * for computing importance weights.
*/
    SampleDatabase(int num_dimensions, int num_lates_comp_to_check=200);

    /**
     * Adds new_samples and the corresponding log_densities.
     * The parameters means and inv_chols describe the components that generated each sample,
     * such that the number of components should correspond to the number of columns in new_samples.
     * Side effects:
     * For each sample this call will check whether the component already exists in this background GMM.
     * If if does exist, the number of usages is increased.
     * If it does not exist a new component will be added to the background GMM
     */
    void add_samples(arma::mat new_samples, arma::mat new_target_densities, arma::mat means, arma::cube inv_chols);

    /**
     * Returns the N most recent samples along with their target_densities and a concise GMM from which the samples
     * could have been drawn from.
     */
    std::tuple<arma::mat, arma::vec, GMM> select_newest_samples(int N);

    /**
    * Create a GMM background distribution for a given subset of samples
    * @param active_samples - vector specifying the sample indices for the subset
    */
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

};


#endif
