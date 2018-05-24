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

/**
 * Removes all components with weight below the given threshold, and renormalized the weights afterwards
 * @param min_weight - threshold for keeping components
 */
    void delete_low_weight_components(double min_weight);

/**
* Adds new samples to the database.
* Note that the samples will not be used for learning, until they have been activated (@see activate_newest_samples)
* The samples are assumed to have been drawn from the current model and the indices of the relevant components
* are to be provided for computing background distributions when necessary.
* @param new_samples - a matrix of size N_dimensions X N_samples
* @param new_target_densities - a vector of size N_samples containing the unnormalized densities on the target distribution
* @param used_components - a vector of size N_samples containing the indices of the components the corresponding samples have been drawn from
*/
    void add_samples_to_database(arma::mat new_samples, arma::vec new_target_densities, arma::uvec used_components);

/**
 * Recomputes the densities of various distributions as well as the importance weights.
 * Manual invocation is in general not necessary, as the densities are automatic updated,
 * e.g. after weight changes, component changes, adding components, etc.
 * @param update_log_densities_on_model_comps - if this flag is set to false, assume that the density-evaluations for each
 * GMM component is up-to-date, e.g. because only the GMM weights have changed
 * @param update_log_densities_on_model_background_dist - if this flag is set to false, assume that the density evaluations for
 * the background distribution are up-to-date, e.g. because it was not changed at all
 */
void recompute_densities(bool update_log_densities_on_model_comps=true, bool update_log_densities_on_background_dist=true);

/**
 * Selects the N most recent samples and activates them (i.e. uses them for the upcoming learning iteration).
 * Makes sure, that all relevant data (e.g. densities, importance weights, etc.) gets updated
 * @param N - the maximum number of recent samples to be activated, actual number of activated samples
 * might be less, iff the sample database does not contain sufficient samples.
 */
    void activate_newest_samples(int N);

/**
 * Sets the current components p(x|o) and the current weight distribution p(o) as the target for the respective
 * KL bounds.
 * @param update_weight_targets - only update the weight targets if this is set to true
 * @param update_comp_targets - only update the component targets if this ist set to true
 */
    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

/**
 * Selects promising locations among the current samples and create new components at these positions.
 * The covariance matrices are given by the weighted sums of the covariance matrices of the current model,
 * and the weights are initialized with low weight.
 * Locations are promising if the residual given by
 * residual = log(p_intractable(x)) - log(p_model(x) + exp(max_exploration_bonus))
 * is high.
 *
 * @param N - the number of samples to be promoted
 * @param max_exploration_bonus - maximum bonus for samples that have low density on the current model
 * @param only_check_active_samples - if set to true, the residual is computed on the active samples only,
 * otherwise, the resiudal is computed for all samples in the sample database.
 * @param max_samples - maximum number of samples to be considered
 */
void promote_samples_to_components(int N, double max_exploration_bonus, double tau, bool only_check_active_samples, int max_samples);


/**
 * update the component weights p(o)
 * @param epsilon is the KL bound
 * @param tau is the entropy coefficient
 * @param entropy_bound is the lower bound on the entropy
 * @return a tuple, s.t.
 * tuple[0] contains the KL D(p_new(o)||p_old(o))
 * tuple[1] contains the rewards for each component that was used during the optimization
 * tuple[2] contains a sample-estimate of the expected, unnormalized log-densities of the desired distribution
 */
    std::tuple<double,vec,vec> update_weights(double epsilon, double tau, double entropy_bound);

    /**
* Adapts the KL bound based on the number of effective samples.
* The KL bound for each component is set to min(max_kl_bound, factor * num_eff_samples(o))
* @param max_kl_bound - hard upper bound for KL
* @param factor - factor for computing the KL bound based on the number of effective samples
*/
    arma::vec adapt_KL_bound_for_comp_update(double max_kl_bound, double factor);

/**
 * Updates the components p(s|o)
 * @param max_kl_bound - hard upper bound for each KL bound
 * @param factor - factor for computing the KL bound for each component based on its number of effective samples
 * @param tau - entropy coefficient
 * @param ridge_coefficient - coefficient used for regularization when fitting the quadratic surrogate
 * @param entropy_bounds a vector containing the lower bounds on the entropy for each component
 * @returns a vector of size num_components containing the KL changes
 */
    arma::vec update_components(double max_kl_bound, double factor, double tau, double ridge_coefficient,
                            vec entropy_bounds, double max_active_samples, bool dont_learn_correlations);

/**
* Adds new components.
* @params new_weights_total - new weights of the GMM (including existing components)
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* of the new components
*/
    void add_components(arma::vec new_weights_total, arma::mat new_means, arma::cube new_covs);

/**
 * Returns a (weighted importance sampling) Monte-Carlo estimate of the entropy of the learned model.
 * The entropy is computed based on the active samples.
 * As this entropy is computed based on precomputed values [importance weights and log(p(x))] th evaluation is very
 * fast.
 * However, if the number of active samples is still low or the samples are not "fresh" (low importance weights),
 * the estimate can be quite bad.
 * @see get_entropy_estimate_on_gmm_samples() for a slower, but usually more accurate estimate.
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
    double get_entropy_estimate_on_active_samples();

/**
 * Returns a Monte-Carlo estimate of the entropy of the learned model.
 * This methods draws new samples from the learned model and evaluated their log-densities log(p(x))
 * The entropy of the learned model is then approximated as H(p) \approx -1/num_samples \sum_x log(p(x))
 * @see get_entropy_estimate_on_active_samples() for a faster, but usually less accurate estimate.
 * @param num_samples - the number of samples that should be drawn for computing the estimate
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
    double get_entropy_estimate_on_gmm_samples(int num_samples=10000);

/**
* Get various densities, importance weights, etc. for debug purposes
* @return a tuple, st.
* tuple[0] contains the samples
* tuple[1] contains the unnormalized target densities
* tuple[2] contains the log densities on each model p(s|o)
* tuple[3] contains the joint log densities p(s,o)
* tuple[4] contains the GMM densities p(s)
* tuple[5] contains the log responsibilities p(o|s)
* tuple[6] contains the densitis on the background distribution q(s)
* tuple[7] contains the importance weights
* tuple[8] contains the normalized importance weights
*/
    std::tuple<arma::mat, arma::vec, arma::mat, arma::mat, arma::vec, arma::mat, arma::mat, arma::mat, arma::mat>
        get_debug_info();

    // Getters
    int getNumSamples();

};
#endif