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
    VIPS_PythonWrapper(int num_dimensions, int num_threads);
    ~VIPS_PythonWrapper(void);

/**
* Adds new components.
* @params new_weights - new weights of the GMM (including existing components)
* @params new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
* @params new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
* of the new components
*/
    void add_components(
            double * new_weights_in, int new_weights_in_dim1,
            double * new_means_in, int new_means_in_dim1, int new_means_in_dim2,
            double * new_covs_in,  int new_covs_in_dim1, int new_covs_in_dim2, int new_covs_in_dim3);
    
/**
* Selects promising locations among the current samples and create new components at these positions.
* The covariance matrices and weights are given by the weighted sums of the covariance matrices and weights of the
* current model, where the weights are given by the responsibilities of the model components for the new location.
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

    void delete_low_weight_components(double min_weight);

    void draw_samples(
            // inputs:
            double N, double temperature,
            // outputs:
            double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
            int **indices_out, int *indices_out_dim1);

/**
* Sample from the current GMM approximation, but use the specified the given component coefficient
* @param N - the numb er of samples to been drawn
* @param weights - the weights (coefficients) to be used
* @returns samples - N Samples drwan from the mixture with the given weights
* @returns indices - for each sample, the index of the component that was used for drawing it
*/
    void draw_samples_weights(
        // inputs:
        double N,
        double * new_weights_in, int new_weights_in_dim1,
        // outputs:
        double **samples_out_ptr, int *samples_out_dim1, int *samples_out_dim2,
        int **indices_out, int *indices_out_dim1
    );

    void add_samples(
            // inputs:
            double * samples_ptr, int samples_dim1, int samples_dim2,
            int * indices_ptr, int indices_dim1,
            double * target_densiies_ptr, int td_dim1);

    void activate_newest_samples(int N);


    /**
    * Sets the current components p(s|o) and the current weight distribution p(o) as the target for the respective
    * KL bounds.
    */
    void update_targets_for_KL_bounds(bool update_weight_targets, bool update_comp_targets);

/**
 * update the component weights p(o)
 * @param epsilon - KL bound
 * @param tau - entropy coefficient
 * @param max_entropy_decrease - lower bound on entropy
 */
void update_weights(double epsilon, double tau, double max_entropy_decrease);

/**
 * Lower bounds all weights and renormalizes by scaling those weights that have not been modified.
 * Currently, we do not check whether weights that got rescaled drop below their lower bound.
 * @param lb_weights_in - vector containing the lower bound for all weights.
 * The sum of lb_weights_in needs to be <= 1
 */
void apply_lower_bound_on_weights(double * lb_weights_in, int lb_weights_in_dim1);

/**
 * Updates the components p(s|o)
 * @param max_kl_bound - hard upper bound for each KL bound
 * @param factor - factor for computing the KL bound for each component based on its number of effective samples
 * @param tau - entropy coefficient
 * @param ridge_coefficient - coefficient used for regularization when fitting the quadratic surrogate
 * @param max_entropy_decrease - maximum allowed decrease in entropy for each component
 */
void update_components(double max_kl_bound, double factor, double tau, double ridge_coefficient,
 double max_entropy_decrease, double max_active_samples, bool dont_learn_correlations);

/**
 * Recomputes the densities of various distributions as well as the importance weights.
 * This is usually necessary, after the samples or the model has changed.
 * @param only_weights_changed - if this flag is set to true, assume that only the model weights have changed
 * and avoid recomputing the component densities p(s|o).
 */
void recompute_densities(bool only_weights_changed);

// Methods for Inspection
/**
* Returns the learned GMM.
* @return weights - weights for each component
* @return means - means for each component
* @return covs - covariance matrices for each component
*/
void get_model(
        //outputs
        double ** weights_out_ptr, int * weights_out_dim1,
        double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
        double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3);

/**
* Returns the entropies of the learned model
* @return entropies_out_ptr - vector containing the entropy of each component of the learned GMM
*/
void get_model_entropies(
        //outputs
        double ** entropies_out_ptr, int * entropies_out_dim1);

/**
* Returns the background distribution used for computing importance weights.
* @return weights - weights for each component
* @return means - means for each component
* @return covs - covariance matrices for each component
*/
    void get_background(
    //outputs
    double ** weights_out_ptr, int * weights_out_dim1,
    double ** means_out_ptr, int * means_out_dim1, int * means_out_dim2,
    double ** covs_out_ptr, int * covs_out_dim1, int * covs_out_dim2, int * covs_out_dim3);

/**
 * Get the KLs of the last update iteration
 * @return KL_weights_out, the KL D(p_new(o)||p_old(new)) after the last weight update
 * @return KL_comps_out, a vector containing the KLs D(p_new(x|o)||p_old(x|o)) for each component o.
 */
void get_last_KLs(
        //outputs
        double * KL_weights_out,
        double ** kls_comp_out, int * kls_comp_out_dim1);

/**
 * Get the GMM weights
 * @return weights_out_ptr, the weights p(o)
 * @return log_weights_out_ptr, the log-weights log(p(o))
 */
void get_weights(
    double ** weights_out_ptr, int * weights_out_dim1,
    double ** log_weights_out_ptr, int * log_weights_out_dim1
);

/**
* Gets the number of samples.
* @return num_samples - the number of samples that are currently activated for learning
* @return num_samples_total - the number of samples that have ever been added to the database.
*/
void get_num_samples(int * num_samples, int * num_samples_total);

/**
* Returns the expected rewards, expected target densities and the history of expected target densities
* @return expected_rewards_out a vector containing for each component the expect reward that was used
* during the last weight optimization
* @return expected_target_densities_out a vector containing the WIS estimates of E[f(x)]
* @return the development of the expected_target densities for each component starting from its creation
*/
    void get_expected_rewards(
        double ** expected_rewards_out, int * expected_rewards_out_dim1,
        double ** expected_target_densities_out, int * expected_target_densities_out_dim1,
        double ** comp_etd_history_out_ptr, int * comp_etd_history_out_dim1, int * comp_etd_history_out_dim2,
        double ** comp_reward_history_out_ptr, int * comp_reward_history_out_dim1, int * comp_reward_history_out_dim2
);

/**
 * Evaluates the samples on the learned GMM and returns log(p(samples))
 * @param samples_ptr - The samples to be evaluated
 * @return sample_densities - the log densities on the GMM
 */
    void get_log_densities_on_mixture(
            double * samples_ptr, int samples_dim1, int samples_dim2,
            double ** sample_densities_out, int * sample_densities_out_dim1
    );

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
    void get_entropy_estimate_on_active_samples(double * entropy);

/**
 * Returns a Monte-Carlo estimate of the entropy of the learned model.
 * This methods draws new samples from the learned model and evaluated their log-densities log(p(x))
 * The entropy of the learned model is then approximated as H(p) \approx -1/num_samples \sum_x log(p(x))
 * @see get_entropy_estimate_on_active_samples() for a faster, but usually less accurate estimate.
 * @param num_samples - the number of samples that should be drawn for computing the estimate
 * @return a Monte-Carlo estimate of the entropy of the learned Gaussian Mixture Model
 */
    void get_entropy_estimate_on_gmm_samples(
            // output
            double * entropy,
            // input
            int num_samples=10000);

/**
 * Returns the number of components of the GMM approximation.
 * @return the number of components
 */
    void get_num_components(int * num_components_out);

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
    void get_debug_info(
    double ** samples_out_ptr, int * samples_out_dim1, int * samples_out_dim2,
    double ** target_densities_out_ptr, int * target_densities_out_dim1,
    double ** log_densities_on_model_comps_out_ptr, int * log_densities_on_model_comps_out_dim1, int * log_densities_on_model_comps_out_dim2,
    double ** log_joint_densities_out_ptr, int * log_joint_densities_out_dim1, int * log_joint_densities_out_dim2,
    double ** log_densities_on_model_out_ptr, int * log_densities_on_model_out_dim1,
    double ** log_responsibilities_out_ptr, int * log_responsibilities_out_dim1, int * log_responsibilities_out_dim2,
    double ** log_densities_on_background_out_ptr, int * log_densities_on_background_out_dim1,
    double ** importance_weights_out_ptr, int * importance_weights_out_dim1, int * importance_weights_out_dim2,
    double ** importance_weights_normalized_out_ptr, int * importance_weights_normalized_out_dim1, int * importance_weights_normalized_out_dim2
    );

    /** creates a backup of the the current state of the learner (overwriting previous backup).
    * @see restore_backup()
    */
    void backup_learner();

    /** restores the state of the learner from a backup.
    * @see backup_learner()
    */
    void restore_learner();

};
#endif