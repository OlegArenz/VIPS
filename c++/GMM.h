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

/**
* Construts a multivariate Gaussian Mixture Model
* Components and weights have to be added afterwards
* @param dim - dimension of the random values
* @param max_components - maximum number of allowed components
*/
    GMM(int dim, int max_components=100000);

//--- Functions for modifying the GMM
/**
* Compute a covariance matrix for each given query point by interpolating the covariance matrices of the GMM components
* weighted by the their responsibility for the given query point.
* This can be used, for example, for initializing new components.
* @params query_points - D X N matrix containing the query points
* @returns a cube of size N x D X D containing the covariance matrices
*/
    arma::cube interpolate_covs_for_query_points(mat query_points);

/**
* Creates new components on the given positions.
* The covariance matrices are initialized by interpolating the covariance matrices of the existing components
* weighted by their responsibilities for the new mean.
* The weights are initialized to low values, such that the change of the mixture is negligible
* @params means - matrix of size N_dimensions x N_newComponents specifying
* at which positions new components are to be added
*/
    virtual void add_components_at_locations(mat means);

/**
* Adds new components.
* The weights will be initialized close to zero
 * @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
 * @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
 * of the new components
*/
    virtual void add_components(mat means, cube covs);

/**
* Adds new components. Second parameter is interpreted as inverse cholesky matrix.
* The weights will be initialized close to zero
 * @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
 * @params new_InvChols - cube of size N_dimensions x N_dimensions x N_newComponents specifying the inverse cholesky matrices
 * of the new components
*/
    virtual void add_components_invChols(mat new_means, cube new_invChols);


/**
* Delete the components given by the indices and renormalize the weights afterwards.
* @params indices specifying which component to delete
*/
    void delete_components(uvec indices);

/**
* Delete a single componentent and renormalize the weights afterwards.
* @params index specifying which component to delete
*/
    virtual void delete_component(int index);

/**
 * If the GMM currently contains more than max_components,
 * removes the N=(num_components - max_components) components with lowest weight.
 * However, does not delete components with an index that is contained in protected_components.
 * @param protected_components - indices of such components that should not be deleted.
 */
    void prune_to_max_components(uvec protected_components);

/**
 * Change the Mean and Covariance of the specified component
 * @param index - an index specifying which component to modify
 * @param newChol - new cholesky decomposition of the covariance matrix
 * @param newMean - new mean
 */
    void changeComponent(int index, mat newChol, vec newMean);

//--- Inference
/**
* evaluates the given query samples on the given component
* Returns a vector of size num_samples containing p(s|o_idx)
*/
    vec compute_component_densities(int idx, mat samples, bool return_log);

/**
* evaluates all components on the given samples.
* Returns a tuple of two matrices with size num_components X num_samples
* tuple[0] contains the joint densities p(s,o)
* tuple[1] contains the marginal densities p(s|o)
*/
    std::tuple<mat, mat> compute_joint_densities(mat samples, bool return_log);

/**
* evaluates the GMM on the given samples
* Returns a vector of size num_samples containing p(s)
*/
    vec evaluate_GMM_densities(mat samples, bool return_log);

/**
* evaluates the GMM on the given samples in a memory efficient way.
* This function is recommended for very large number of samples or components
* @param samples - a matrix of size N_dim x N_samples of samples to be evaluated
* @return the log GMM densities log(p(s))
*/
    vec evaluate_GMM_densities_low_mem(mat samples);

/**
 * This function mainly computes the log_responsibilities [log(p(comp|sample))]
 * and the the log densities [log(GMM(samples))]. However, intermediate computations are returned as well,
 * as they are required for efficient computation.
 * For example, when recomputing the log_responsibilites in a numerical stable way after adding more samples, tuple[2]
 * and tuple[3] can be exploited to avoid unnecessary computations.
 *
 * @param samples, a matrix N_Dim x N_Samples containing the samples to be evaluated
 * @return a tuple, such that
 * tuple[0]: a matrix N_Components x N_Samples containing the log of joint densities log(p(s,o))
 * tuple[1]: a matrix N_Components x N_Samples containing the log of component marginals log(p(s|o))
 * tuple[2]: a row-vector containing column-wise, negated maxima of tuple[1]
 * tuple[3]: a row-vector containing the column-wise summations, sum(exp(log(tuple[1]+tuple[2]))
 * tuple[4]: a vector containing the GMM log densities for each sample (log(tuple[3]) - tuple[2], i.e. log(p(s))
 * tuple[5]: a matrix containing the log responsibilities (row-wise subtraction of tuple[4] from tuple[2], i.e. p(o|s))
 */
    std::tuple<mat, mat, rowvec, rowvec, vec, mat> compute_log_marginals(mat samples);

/**
* This function mainly computes the log_responsibilities [log(p(comp|sample))]
* and the the log densities [log(GMM(samples))]. However, intermediate computations are returned as well,
* as they are required for efficient computation.
* For example, when recomputing the log_responsibilites in a numerical stable way after adding more samples, tuple[1]
* and tuple[2] can be exploited to avoid unnecessary computations.
*
* @param log_component_marginals, a matrix N_Components x N_Samples containing the log of component marginals log(p(s|o))
* @return a tuple, such that
* tuple[0]: a matrix N_Components x N_Samples containing the log of joint densities log(p(s,o))
* tuple[1]: a row-vector containing column-wise, negated maxima of tuple[0]
* tuple[2]: a row-vector containing the column-wise summations, sum(exp(log(tuple[0]+tuple[1]))
* tuple[3]: a vector containing the GMM log densities for each sample (log(tuple[2]) - tuple[1], i.e. log(p(s))
* tuple[4]: a matrix containing the log responsibilities (row-wise subtraction of tuple[3] from tuple[1], i.e. p(o|s))
*/
    std::tuple<mat, rowvec, rowvec, vec, mat> compute_log_marginals_from_comp_densities(mat log_component_marginals);


/**
* Draw n samples from the specified component
*/
    mat sample_from_component(int index, int n);

/**
* Sample from the current GMM, but use the specified the given component coefficient
* @param N - the numb er of samples to been drawn
* @param weights - the weights (coefficients) to be used
* @returns samples - N Samples drwan from the mixture with the given weights
* @returns indices - for each sample, the index of the component that was used for drawing it
*/
std::tuple<mat, uvec> sample_from_mixture_weights(
    // inputs:
    double N,
    vec new_weigths
);

/**
* return samples and the corresponding indices of the components.
* temperature can be used to scale the weights
*/
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