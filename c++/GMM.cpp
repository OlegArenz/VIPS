#define _USE_MATH_DEFINES

#include "GMM.h"
#include "Utils.h"
#include <random>
#include <ctime>

using namespace std; // ToDo: Test whether save to remove
using namespace arma;

/**
* A Gaussian Mixture Model.
* @param dim the number of dimensions
* @param max_components maximum number of components this GMM may comprise
*/
GMM::GMM(int dim, int max_components)
        : dim(dim), means(dim, 0), covs(dim, dim, 0), chols(dim, dim, 0), inv_chols(dim, dim, 0),
          weights(), log_weights(), entropies(), determinants(), num_components(0), max_components(max_components),
           rng(static_cast<long unsigned int>(time(0))){
  entropy_offset = 0.5 * dim * (log(2 * M_PI) + 1);
}

//---- Functions for modifying the GMM
/**
* Compute a covariance matrix for each given query point by interpolating the covariance matrices of the GMM components
* weighted by the their responsibility for the given query point.<br>
* This can be used, for example, for initializing new components.<br>
* @param query_points - D X N matrix containing the query points <br>
* @param scale_entropy - if true, scale the entropy of the Gaussian such that it corresponds to the average entropy \sum_o p(o) H(p(x|o))
* @param isotropic - if true, return an isotropic (identity if scale_entropy = False) covariance instead of interpolating.
* @returns a cube of size N x D X D containing the covariance matrices
*/
cube GMM::interpolate_covs_for_query_points(mat query_points, bool scale_entropy, bool isotropic) {
  int N = query_points.n_cols;
  mat responsibilities = arma::exp(std::get<5>(compute_log_marginals(query_points)));
  cube new_covs(dim, dim, N, fill::zeros);
  for (int i = 0; i < N; i++) {
    if (isotropic) {
        new_covs.slice(i).eye();
    } else {
        for (int j = 0; j < num_components; j++) {
          new_covs.slice(i) += responsibilities(j, i) * covs.slice(j);
        }
    }

    if (scale_entropy) {
        double target_entropy = dot(getWeights(), getEntropies());
        double rescaling_factor = std::max(1e-3,exp(1./(double)getNumDimensions() * (2*target_entropy - log(det(2*M_PI*exp(1)*new_covs.slice(i))))));
        new_covs.slice(i) = rescaling_factor * new_covs.slice(i);
    }
  }
  return new_covs;
}

/**
* Creates new components on the given positions.<br>
* The covariance matrices are initialized by interpolating the covariance matrices of the existing components
* weighted by their responsibilities for the new mean.<br>
* The weights are initialized to low values, such that the change of the mixture is negligible
* @param means - matrix of size N_dimensions x N_newComponents specifying
* @param scale_entropy - if true, scale the entropy of the Gaussian such that it corresponds to the average entropy \sum_o p(o) H(p(x|o))
* @param isotropic - if true, return an isotropic (identity if scale_entropy = False) covariance instead of interpolating.
* at which positions new components are to be added
*/
void GMM::add_components_at_locations(mat new_means, bool scale_entropy, bool isotropic) {
  cube new_covs = interpolate_covs_for_query_points(new_means, scale_entropy, isotropic);
  vec new_weights = join_cols(weights, 1e-30 * ones<vec>(new_means.n_cols));
  new_weights /= arma::sum(new_weights);

  add_components(new_means, new_covs);
  setWeights(new_weights);
}

/**
* Adds new components.
* The weights will be initialized close to zero.
 * @param new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
 * @param new_covs - cube of size N_dimensions x N_dimensions x N_newComponents specifying the covariance matrices
 * of the new components
*/
void GMM::add_components(mat new_means, cube new_covs) {
  int N = new_means.n_cols;

  means = join_horiz(means, new_means);
  covs = join_slices(covs, new_covs);
  vec new_weights = 1e-20 * vec(N, fill::ones);
  vec new_log_weights = log(1e-20) * vec(N, fill::ones);

  weights = join_cols(weights, new_weights);
  log_weights = join_cols(log_weights,new_log_weights);

  // recompute cholesky decompositions and entropies
  chols.insert_slices(num_components, N, false);
  inv_chols.insert_slices(num_components, N, false);
  entropies.insert_rows(num_components, N, false);
  determinants.insert_rows(num_components, N, false);
  for (int i = 0; i < new_covs.n_slices; i++) {
    int idx = num_components + i;
    chols.slice(idx) = chol(new_covs.slice(i), "lower");
    inv_chols.slice(idx) = inv(chols.slice(idx));
    entropies.at(idx) = sum(log(diagvec(chols.slice(idx)))) + entropy_offset;
    determinants.at(idx) = pow(as_scalar(prod(diagvec(chols.slice(idx)))), 2);
  }

  num_components = means.n_cols;

//  uvec protected_components = arma::linspace<uvec>(num_components - N, num_components - 1, N);
//  prune_to_max_components(protected_components);
}

/**
* Adds new components. Second parameter is interpreted as inverse cholesky matrix.
* The weights will be initialized close to zero
 * @param new_means - matrix of size N_dimensions x N_newComponents specifying the means of the new components
 * @param new_InvChols - cube of size N_dimensions x N_dimensions x N_newComponents specifying the inverse cholesky matrices
 * of the new components
*/
void GMM::add_components_invChols(mat new_means, cube new_invChols) {
  int N = new_means.n_cols;

  means = join_horiz(means, new_means);
  inv_chols = join_slices(inv_chols, new_invChols);
  vec new_weights = 1e-20 * vec(N, fill::ones);
  vec new_log_weights = log(1e-20) * vec(N, fill::ones);

  weights = join_cols(weights, new_weights);
  log_weights = join_cols(log_weights,new_log_weights);

  chols.insert_slices(num_components, N, false);
  covs.insert_slices(num_components, N, false);
  entropies.insert_rows(num_components, N, false);
  determinants.insert_rows(num_components, N, false);
  for (int i = 0; i < new_invChols.n_slices; i++) {
    int idx = num_components + i;
    covs.slice(idx) = inv(new_invChols.slice(i).t() * new_invChols.slice(i));
    chols.slice(idx) = chol(covs.slice(idx), "lower");
    entropies.at(idx) = sum(log(diagvec(chols.slice(idx)))) + entropy_offset;
    determinants.at(idx) = pow(as_scalar(prod(diagvec(chols.slice(idx)))), 2);
  }

  num_components = means.n_cols;

  uvec protected_components = arma::linspace<uvec>(num_components - N, num_components - 1, N);
  prune_to_max_components(protected_components);
}

/**
* Delete a single componentent and renormalize the weights afterwards.
* @param index specifying which component to delete
*/
void GMM::delete_component(int index) {
  means.shed_col(index);
  covs.shed_slice(index);
  chols.shed_slice(index);
  inv_chols.shed_slice(index);
  weights.shed_row(index);
  log_weights.shed_row(index);
  entropies.shed_row(index);
  determinants.shed_row(index);

  // renormalize weights
  weights /= sum(weights);
  log_weights -= max(log_weights);
  log_weights -= log(sum(exp(log_weights)));
  num_components = chols.n_slices;
}

/**
* Delete the components given by the indices and renormalize the weights afterwards.
* @param indices specifying which component to delete
*/
void GMM::delete_components(uvec indices) {
  indices = sort(indices, "descend");

  for (int i = 0; i < indices.n_rows; i++)
    delete_component(indices.at(i));

}

/**
 * If the GMM currently contains more than max_components,
 * removes the N=(num_components - max_components) components with lowest weight.
 * However, does not delete components with an index that is contained in protected_components.
 * @param protected_components - indices of such components that should not be deleted.
 */
void GMM::prune_to_max_components(uvec protected_components) {
  if (num_components > max_components) {
    uvec indices = linspace<uvec>(0, num_components - 1, num_components);
    uvec deletable_indices = indices;
    protected_components = sort(protected_components, "descend");
    for (int i=0; i<protected_components.n_rows; i++)
        deletable_indices.shed_row(protected_components.at(i));

    if (deletable_indices.n_rows <= num_components - max_components)
      delete_components(deletable_indices);
    else {
      deletable_indices = sort_index(weights.rows(deletable_indices), "ascend");
      delete_components(indices.rows(deletable_indices.head_rows(num_components - max_components)));
    }
  }
}


/**
 * Change the Mean and Covariance of the specified component
 * @param index - an index specifying which component to modify
 * @param newChol - new cholesky decomposition of the covariance matrix
 * @param newMean - new mean
 */
void GMM::changeComponent(int index, mat newChol, vec newMean) {
  means.col(index) = newMean;
  chols.slice(index) = newChol;
  inv_chols.slice(index) = inv(newChol);
  covs.slice(index) = newChol * newChol.t();
  entropies.at(index) = sum(log(diagvec(chols.slice(index)))) + entropy_offset;
  determinants.at(index) = pow(as_scalar(prod(diagvec(chols.slice(index)))), 2);
}

//---- Inference / Sampling.
/**
* Evaluates the given query samples on the given component.
* @returns a vector of size num_samples containing p(s|o_idx)
*/
vec GMM::compute_component_densities(int idx, mat samples, bool return_log) {
  return gaussian_pdf(inv_chols.slice(idx), samples.each_col() - means.col(idx), return_log);
}

/**
* evaluates all components on the given samples.
* @returns a tuple of two matrices with size num_components X num_samples<br>
* tuple[0] contains the joint densities p(s,o)<br>
* tuple[1] contains the marginal densities p(s|o)
*/
std::tuple<mat, mat> GMM::compute_joint_densities(mat samples, bool return_log) {
  mat marginals(num_components, samples.n_cols, fill::none);
#pragma omp parallel for
  for (int i = 0; i < num_components; i++) {
    marginals.row(i) = gaussian_pdf(inv_chols.slice(i), samples.each_col() - means.col(i), return_log).t();
  }
  if (return_log)
    return std::make_tuple(log_weights + marginals.each_col(), marginals);
  else
    return std::make_tuple(weights % marginals.each_col(), marginals);
}

/**
* Evaluates the GMM on the given samples.
* @returns a vector of size num_samples containing p(s)
*/
vec GMM::evaluate_GMM_densities(mat samples, bool return_log) {
  mat joint_densities = std::get<0>(compute_joint_densities(samples, return_log));
  if (return_log)
    return std::get<0>(softMax_2D(joint_densities));
  else
    return exp(std::get<0>(softMax_2D(joint_densities)));
}

/**
 * Evaluates the GMM on the given samples in a memory efficient way.
 * This function is recommended for very large number of samples or components
 * @param samples - a matrix of size N_dim x N_samples of samples to be evaluated
 * @param uniform_weights - evaluate the GMM densities assuming that p(o) is uniform
 * @return the log GMM densities log(p(s))
 */
vec GMM::evaluate_GMM_densities_low_mem(mat samples, bool uniform_weights) {
  omp_set_dynamic(0);
  int max_threads = omp_get_max_threads();
  mat mixture_densities_per_thread(max_threads, samples.n_cols, fill::zeros);
  mat old_max_per_thread(max_threads, samples.n_cols, fill::none);
  mat max_per_thread(max_threads, samples.n_cols, fill::none);
  max_per_thread.fill(-datum::inf);
  mat joint_densities_per_thread(max_threads, samples.n_cols, fill::none);

  // We split the components among the threads, and let each thread compute
  // sum_o[exp[log(p(s|o)) - max_o(log(p(s|o)))]].
  // The summation and maximization are performed in place for memory efficiency,
  // hence we need to correct for the fact that the previous summation might have
  // subtracted a different max_o(..) in log-space by multiplying with the old max_o(..) in exp-space, i.e.
  // new_sum = exp(old_max - new_max) * old_sum + exp(log(p(s|o) - new_max)
  omp_set_nested(1);
#pragma omp parallel for
  for (int i = 0; i < num_components; i++) {
    int tid = omp_get_thread_num();
    if (uniform_weights)
        joint_densities_per_thread.row(tid) =
            log_weights.at(1./num_components) + gaussian_pdf(inv_chols.slice(i), samples.each_col() - means.col(i), true).t();
    else
        joint_densities_per_thread.row(tid) =
            log_weights.at(i) + gaussian_pdf(inv_chols.slice(i), samples.each_col() - means.col(i), true).t();
    old_max_per_thread.row(tid) = max_per_thread.row(tid);
    max_per_thread.row(tid) = arma::max(joint_densities_per_thread.row(tid), max_per_thread.row(tid));
    mixture_densities_per_thread.row(tid) =
            exp(old_max_per_thread.row(tid) - max_per_thread.row(tid)) % mixture_densities_per_thread.row(tid)
            + exp(joint_densities_per_thread.row(tid) - max_per_thread.row(tid));
  }

  // We still need to merge the summation of the different threads.
  // Again, we need to correct for the fact that different maxima have been subtracted
  rowvec max_among_all_threads = arma::max(max_per_thread, 0);
  max_per_thread = max_per_thread.each_row() - max_among_all_threads;
  rowvec mixture_densities_summed = sum(exp(max_per_thread) % mixture_densities_per_thread, 0);

  vec log_mixture_densities = (log(mixture_densities_summed) + max_among_all_threads).t();
  return log_mixture_densities;
}

/**
 * This function mainly computes the log_responsibilities [log(p(comp|sample))]
 * and the the log densities [log(GMM(samples))]. However, intermediate computations are returned as well,
 * as they are required for efficient computation.<br>
 * For example, when recomputing the log_responsibilites in a numerical stable way after adding more samples, tuple[1]
 * and tuple[2] can be exploited to avoid unnecessary computations.
 *
 * @param log_component_marginals, a matrix N_Components x N_Samples containing the log of component marginals log(p(s|o))
 * @return a tuple, such that<br>
 * tuple[0]: a matrix N_Components x N_Samples containing the log of joint densities log(p(s,o))<br>
 * tuple[1]: a row-vector containing column-wise, negated maxima of tuple[0]<br>
 * tuple[2]: a row-vector containing the column-wise summations, sum(exp(log(tuple[0]+tuple[1]))<br>
 * tuple[3]: a vector containing the GMM log densities for each sample (log(tuple[2]) - tuple[1], i.e. log(p(s))<br>
 * tuple[4]: a matrix containing the log responsibilities (row-wise subtraction of tuple[3] from tuple[1], i.e. p(o|s))
 */
std::tuple<mat, rowvec, rowvec, vec, mat> GMM::compute_log_marginals_from_comp_densities(mat log_component_marginals) {
  mat log_joint_densities = log_weights + log_component_marginals.each_col();
  rowvec columnwise_offsets = -max(log_joint_densities, 0);
  rowvec summation_with_offsets = sum(exp(log_joint_densities.each_row() + columnwise_offsets), 0);
  vec log_sample_densities = (log(summation_with_offsets) - columnwise_offsets).t();
  mat log_responsibilities = log_joint_densities.each_row() - log_sample_densities.t();
  return make_tuple(log_joint_densities, columnwise_offsets, summation_with_offsets,
                    log_sample_densities, log_responsibilities);
}

/**
 * This function mainly computes the log_responsibilities [log(p(comp|sample))]
 * and the the log densities [log(GMM(samples))]. However, intermediate computations are returned as well,
 * as they are required for efficient computation.<br>
 * For example, when recomputing the log_responsibilites in a numerical stable way after adding more samples, tuple[2]
 * and tuple[3] can be exploited to avoid unnecessary computations.
 *
 * @param samples, a matrix N_Dim x N_Samples containing the samples to be evaluated
 * @return a tuple, such that<br>
 * tuple[0]: a matrix N_Components x N_Samples containing the log of joint densities log(p(s,o))<br>
 * tuple[1]: a matrix N_Components x N_Samples containing the log of component marginals log(p(s|o))<br>
 * tuple[2]: a row-vector containing column-wise, negated maxima of tuple[1]<br>
 * tuple[3]: a row-vector containing the column-wise summations, sum(exp(log(tuple[1]+tuple[2]))<br>
 * tuple[4]: a vector containing the GMM log densities for each sample (log(tuple[3]) - tuple[2], i.e. log(p(s))<br>
 * tuple[5]: a matrix containing the log responsibilities (row-wise subtraction of tuple[4] from tuple[2], i.e. p(o|s))
 */
std::tuple<mat, mat, rowvec, rowvec, vec, mat> GMM::compute_log_marginals(mat samples) {
  mat log_joint_densities, log_component_marginals;
  std::tie(log_joint_densities, log_component_marginals) = compute_joint_densities(samples, true);
  rowvec columnwise_offsets = -max(log_joint_densities, 0);
  rowvec summation_with_offsets = sum(exp(log_joint_densities.each_row() + columnwise_offsets), 0);
  vec log_sample_densities = (log(summation_with_offsets) - columnwise_offsets).t();
  mat log_responsibilities = log_joint_densities.each_row() - log_sample_densities.t();

  return make_tuple(log_joint_densities, log_component_marginals, columnwise_offsets, summation_with_offsets,
                    log_sample_densities, log_responsibilities);
}

/**
* Draw n samples from the specified component
*/
mat GMM::sample_from_component(int index, int n) {
  mat samples_out = trimatl(chols.slice(index)) * randn(dim, n);
  samples_out = samples_out.each_col() + means.col(index);
  return samples_out;
}

/**
* Return samples and the corresponding indices of the components.
* temperature can be used to scale the weights
*/
std::tuple<mat, uvec> GMM::sample_from_mixture(int n, double temperature) {
  vec my_weights = weights;
  if (temperature != 1.0) {
    my_weights = exp(temperature * log_weights);
    my_weights /= sum(my_weights);
  }
  std::discrete_distribution<int> component_dist(my_weights.memptr(), my_weights.memptr() + weights.n_rows);

  // We start by sampling which n components are to be used
  uvec counts(weights.n_rows, fill::zeros);
  uvec sampled_components(n, fill::none);
  for (int i = 0; i < n; i++) {
    sampled_components.at(i) = component_dist(rng);
    counts.at(sampled_components.at(i)) += 1;
  }

  // Now draw the right amount of samples for each chosen component
  uvec different_components = unique(sampled_components);
  mat new_samples(dim, n, fill::none);
  Col<int> used_components(n, fill::none);
  int added_samples = 0;
  for (int i = 0; i < different_components.n_rows; i++) {
    int this_comp = different_components.at(i);
    int n_current = counts.at(this_comp);
    used_components.rows(added_samples, added_samples + n_current - 1).fill(this_comp);
    new_samples.cols(added_samples, added_samples + n_current - 1) = sample_from_component(this_comp, n_current);
    added_samples += n_current;
  }

  // We do not want the samples to be grouped based on the responsible component
  uvec permutation = shuffle(linspace<uvec>(0, n - 1, n));
  new_samples = new_samples.cols(permutation);
  used_components = used_components.rows(permutation);

  return std::make_tuple(new_samples, conv_to<uvec>::from(used_components));
}


/**
* Sample from the current GMM, but use the specified the given component coefficient.
* @param N - the numb er of samples to been drawn
* @param weights - the weights (coefficients) to be used
* @returns samples - N Samples drwan from the mixture with the given weights
* @returns indices - for each sample, the index of the component that was used for drawing it
*/
std::tuple<mat, uvec> GMM::sample_from_mixture_weights(
    double N,
    vec new_weights
) {
  std::discrete_distribution<int> component_dist(new_weights.memptr(),new_weights.memptr() + new_weights.n_rows);

  // We start by sampling which n components are to be used
  uvec counts(new_weights.n_rows, fill::zeros);
  uvec sampled_components(N, fill::none);
  for (int i = 0; i < N; i++) {
    sampled_components.at(i) = component_dist(rng);
    counts.at(sampled_components.at(i)) += 1;
  }

  // Now draw the right amount of samples for each chosen component
  uvec different_components = unique(sampled_components);
  mat new_samples(dim, N, fill::none);
  Col<int> used_components(N, fill::none);
  int added_samples = 0;
  for (int i = 0; i < different_components.n_rows; i++) {
    int this_comp = different_components.at(i);
    int n_current = counts.at(this_comp);
    used_components.rows(added_samples, added_samples + n_current - 1).fill(this_comp);
    new_samples.cols(added_samples, added_samples + n_current - 1) = sample_from_component(this_comp, n_current);
    added_samples += n_current;
  }

  // We do not want the samples to be grouped based on the responsible component
  uvec permutation = shuffle(linspace<uvec>(0, N - 1, N));
  new_samples = new_samples.cols(permutation);
  used_components = used_components.rows(permutation);

  return std::make_tuple(new_samples, conv_to<uvec>::from(used_components));
}


//---- Setters and Getters
void GMM::setWeights(vec new_weights) {
  weights = new_weights;
  log_weights = log(new_weights);
}

void GMM::setWeights(vec new_weights, vec new_log_weights) {
  weights = new_weights;
  log_weights = new_log_weights;
}

mat GMM::getMeans() { return means; }

mat GMM::getMeans(uvec indices) { return means.cols(indices); }

cube GMM::getCovs() { return covs; }

cube GMM::getChols() { return chols; }

cube GMM::getInvChols() { return inv_chols; }

vec GMM::getWeights() { return weights; }

vec GMM::getLogWeights() { return log_weights; }

vec GMM::getEntropies() { return entropies; }

vec GMM::getDeterminants() { return determinants; }

int GMM::getNumComponents() { return num_components; }

int GMM::getNumDimensions() { return dim; }