#include "SampleDatabase.h"

/**
 * A SampleDatabase keeps track of samples and the Gaussian distributions that generated them.
 * This information is used to create a concise GMM background distribution that can be used
 * for computing importance weights.
*/
SampleDatabase::SampleDatabase(int num_dimensions, int num_lates_comp_to_check)
        : num_dimensions(num_dimensions), num_latest_comp_to_check(num_lates_comp_to_check), num_samples(0),
          samples(num_dimensions, 0), target_densities(), map_samples_to_backgroundComp(),
          means(num_dimensions, 0), inv_chols(num_dimensions, num_dimensions, 0),
          covs(num_dimensions, num_dimensions, 0), num_components(0), num_sampling_usages() {
}

/**
 * Check whether a component with similar mean and covariance (inverse cholesky is checked) exists
 * Only considers the num_latest_comp_to_check most recently added components for performance reasons
 * Returns:
 * -1, iff no similar component exists
 * the index to a similar component, otherwise
 */
int SampleDatabase::get_similar_component(vec mean, mat inv_chol, double tol) {
  int firstCompToCheck = std::max(0, num_components - NUM_LAST_COMP_TO_CHECK);
  for (int j = firstCompToCheck; j < num_components; j++) {
    if (approx_equal(means.col(j), mean, "abs_diff", tol)
        && approx_equal(inv_chols.slice(j), inv_chol, "abs_diff", tol))
      return j;
  }
  return -1;
}

/**
 * Add a new component and allocate additional memory if necessary.
 * The weights do not need to be specified, but are computed dynamically based on the number of usages
 * @params mean - mean of the new component
 * @param new_invChol - This should be inv(chol(new_Cov)), not checked!
 * @param new_Cov - the covariance matrix of the new component
 */
void SampleDatabase::add_component(arma::mat new_mean, arma::mat new_invChol, arma::mat new_Cov) {
  int N = new_mean.n_cols;

  if (num_components == means.n_cols) {
    num_sampling_usages.insert_rows(num_sampling_usages.n_rows, 1000, true);
    means.insert_cols(means.n_cols, 1000, false);
    inv_chols.insert_slices(inv_chols.n_slices, 1000, false);
    covs.insert_slices(covs.n_slices, 1000, false);
  }

  means.col(num_components) = new_mean;
  inv_chols.slice(num_components) = new_invChol;
  covs.slice(num_components) = new_Cov;

  num_components++;
}

/**
 * Adds new_samples and the corresponding log_densities.
 * Each sample has to be drawn from a Gaussian distribution in order to compute a background GMM.
 * The respective Gaussian for each sample is provided by specifying a GMM and a vector that contains for each sample,
 * the index of the respective component of that gmm.<br>
 * Side effects:<br>
 * For each sample this call will check whether the component already exists in the background GMM.<br>
 * If if does exist, the number of usages is increased.<br>
 * If it does not exist a new component will be added to the background GMM<br>
 * @param new_samples - matrix of size Dim x N, each column containing a sample<br>
 * @param new_target_densities - vector of size N containing the respective evaluations of the target distribution<br>
 * @param gmm - a Gaussian mixture model that includes for each sample, the Gaussian distribution that was used for obtaining it<br>
 * @param map_samples_to_GMM_comp - vector of size N such that map_samples_to_GMM_comp[i] indexes the component of gmm that was used for obtaining the i-th sample.<br>
 */
void SampleDatabase::add_samples(arma::mat new_samples, arma::mat new_target_densities, GMM gmm, arma::uvec map_samples_to_GMM_comp) {
  samples = join_horiz(samples, new_samples);
  target_densities = join_vert(target_densities, new_target_densities);
  map_samples_to_backgroundComp.insert_rows(num_samples, new_samples.n_cols, true);
  for (int i = 0; i < map_samples_to_GMM_comp.n_rows; i++) {
    vec this_mean = gmm.getMeans().col(map_samples_to_GMM_comp.at(i));
    mat this_inv_chol = gmm.getInvChols().slice(map_samples_to_GMM_comp.at(i));
    int bg_idx = get_similar_component(this_mean, this_inv_chol);
    if (bg_idx >= 0) {
      // The component already exists in this background GMM, so we assign that one to the current sample
      map_samples_to_backgroundComp[num_samples] = bg_idx;
    } else {
      // Add a new component, set its number of usages to 1 and assign it to the current sample
      mat this_cov =  gmm.getCovs().slice(map_samples_to_GMM_comp.at(i));
      add_component(this_mean, this_inv_chol, this_cov);
      map_samples_to_backgroundComp[num_samples] = num_components - 1;
    }
    num_samples++;
  }
}

/**
 * Adds new_samples and the corresponding log_densities.
 * The parameters means and inv_chols describe the components that generated each sample,
 * such that the number of components should correspond to the number of columns in new_samples.
 * Side effects:
 * For each sample this call will check whether the component already exists in this background GMM.
 * If if does exist, the number of usages is increased.
 * If it does not exist a new component will be added to the background GMM
 * @param new_samples - matrix of size Dim x N, each column containing a sample<br>
 * @param new_target_densities - vector of size N containing the respective evaluations of the target distribution<br>
 * @param means - matrix of size Dim x N, each column containing the mean of the component used for drawing the respective sample <br>
 * @param inv_chols - tensor of size N x Dim x Dim, each slice containing inv(chol(new_covs.slice(i)) (not checked) <br>
 * @param new_covs - tensor of size N x Dim x Dim, each slice containing the covariance matrix used for drawing the respective sample
 */
void SampleDatabase::add_samples(arma::mat new_samples, arma::mat new_target_densities, arma::mat means,
                                 arma::cube inv_chols, arma::cube new_covs) {
  samples = join_horiz(samples, new_samples);
  target_densities = join_vert(target_densities, new_target_densities);
  map_samples_to_backgroundComp.insert_rows(num_samples, means.n_cols, true);
  for (int i = 0; i < means.n_cols; i++) {
    int bg_idx = get_similar_component(means.col(i), inv_chols.slice(i));
    if (bg_idx >= 0) {
      // The component already exists in this background GMM, so we assign that one to the current sample
      map_samples_to_backgroundComp[num_samples] = bg_idx;
    } else {
      // Add a new component, set its number of usages to 1 and assign it to the current sample
      add_component(means.col(i), inv_chols.slice(i), new_covs.slice(i));
      map_samples_to_backgroundComp[num_samples] = num_components - 1;
    }
    num_samples++;
  }
}

/**
 * Informs the sampling database that samples from the given sampling distributions have been activated for learning.
 * @param component_indices a vector containing the indices of sampling components that have been used
 */
void SampleDatabase::update_component_usages(uvec component_indices) {
    //cout << num_sampling_usages.t();
    num_sampling_usages *= double(0.8);
    //cout << " " << num_sampling_usages.t() << endl;

    num_sampling_usages.rows(component_indices) = 1 + num_sampling_usages.rows(component_indices);
}

/**
 * Takes a list of sampling component indices and iteratively adds all samples from the top X components,
 * such that the total number of samples matches num_samples.
 * @param component_indices a vector containing indices of sampling components, such that preferred components are closer to the head.
 * @param N number of samples this function should return
 * @returns a tuple such that <br>
 * tuple[0] contains a vector of the indices of the chosen samples<br>
 * tuple[1] contains a vector of the indices of the used components<br>
*/
std::tuple<arma::uvec, arma::uvec> SampleDatabase::select_top_N_samples(uvec component_indices, int N) {
  uvec active_samples;
  vec selected_target_densities;
  int already_added = 0;
  int i;
  for (i=0; i < component_indices.n_rows; i++) {
    uvec candidates = shuffle(find(map_samples_to_backgroundComp == component_indices.at(i)));
    if (candidates.n_rows+already_added > N)
        candidates = candidates.head_rows(N-already_added);
    if (i==0)
      active_samples = candidates;
    else
      active_samples = join_vert(active_samples, candidates);
    already_added = active_samples.n_rows;
    if (already_added >= N)
        break;
  }
  active_samples = unique(active_samples);

  return std::make_tuple(active_samples, component_indices.head_rows(i));
}

/**
 * Returns the samples with given indices along with their target_densities and a concise GMM from which the samples
 * could have been drawn from.
 */
std::tuple<arma::mat, arma::vec, GMM, arma::uvec> SampleDatabase::activate_samples(uvec active_samples) {
  active_samples = unique(active_samples);
  GMM background_distribution = get_bg_dist(active_samples);
  return std::make_tuple(samples.cols(active_samples), target_densities.rows(active_samples), background_distribution, active_samples);
}

/**
 * Returns the N most recent samples along with their target_densities and a concise GMM from which the samples
 * could have been drawn from.
 */
std::tuple<arma::mat, arma::vec, GMM, arma::uvec> SampleDatabase::select_newest_samples(int N) {
  uvec active_samples;
  if (N >= num_samples)
    active_samples = linspace<uvec>(0, num_samples-1, num_samples);
  else
    active_samples = linspace<uvec>(num_samples-N, num_samples-1, N);

  GMM background_distribution = get_bg_dist(active_samples);
  return std::make_tuple(samples.cols(active_samples), target_densities.rows(active_samples), background_distribution, active_samples);
}


/**
 * For each component in a given Gaussian Mixture Model
 * compute the KL w.r.t. each component that is stored in the database.<br>
 * If the parameter reverse_KL is set to true,
 * computes instead the KL for each database component w.r.t. each GMM component.<br>
 * @param gmm - a Gaussian Mixture
 * @param reverse_KL - if set to bool compute the KL between database_componets w.r.t. GMM components
 * @param max_sampling_component - only consider the max_sampling_component newest components of the database
 * @returns a tuple, such that
 *   tuple[0] contains a matrix of size components_in_gmm x components_in_database
 * containing the relative entropies.
 *   tuple[1] contains the index of the first sampling component for which a KL was computed (an offset caused by max_sampling_components)
 */
std::tuple<arma::fmat, int> SampleDatabase::compute_KLs_between_GMM_and_DB_components(GMM gmm, bool reverse_KL, int max_sampling_components) {
  cube gmm_invChols = gmm.getInvChols();
  cube gmm_covs = gmm.getCovs();
  mat gmm_means = gmm.getMeans();
  int num_sampling_comps = std::min(num_components, max_sampling_components);
  fmat KLs(gmm.getNumComponents(), num_sampling_comps, fill::none);

  if (reverse_KL) {
    #pragma omp parallel for
    for (int i=0; i < KLs.n_rows; i++)
      for (int j=0; j < KLs.n_cols; j++)
              if (sum(find(map_samples_to_backgroundComp == num_components-num_sampling_comps+j)) <= 10)
                KLs.at(i,j) = 1e6;
              else
                KLs.at(i,j) = compute_KL_from_invChols(
                                    inv_chols.slice(num_components-num_sampling_comps+j),
                                    covs.slice(num_components-num_sampling_comps+j),
                                    means.col(num_components-num_sampling_comps+j),
                                    gmm_invChols.slice(i), gmm_means.col(i));
  } else {
    #pragma omp parallel for
    for (int i=0; i < KLs.n_rows; i++)
      for (int j=0; j < KLs.n_cols; j++)
        if (sum(find(map_samples_to_backgroundComp == num_components-num_sampling_comps+j)) <= 10)
            KLs.at(i,j) = 1e6;
        else
            KLs.at(i,j) = compute_KL_from_invChols(gmm_invChols.slice(i), gmm_covs.slice(i), gmm_means.col(i),
                                                inv_chols.slice(num_components-num_sampling_comps+j),
                                                means.col(num_components-num_sampling_comps+j));
  }
  return std::make_tuple(KLs, num_components - num_sampling_comps);
}

/**
* Create a GMM background distribution for a given subset of samples
* @param active_samples - vector specifying the sample indices for the subset
*/
GMM SampleDatabase::get_bg_dist(uvec active_samples) {
  GMM background_dist(num_dimensions);
  uvec num_usages_for_bg_dist(num_components, fill::zeros);
  for (int i=0; i<active_samples.n_rows; i++) {
    int idx = map_samples_to_backgroundComp.at(active_samples.at(i));
    num_usages_for_bg_dist.at(idx) = num_usages_for_bg_dist.at(idx) + 1;
  }
  uvec used_bg_components = find(num_usages_for_bg_dist>0);
  cube newInvChols(num_dimensions, num_dimensions, used_bg_components.n_rows, fill::none);
  for (int i=0; i<used_bg_components.n_rows; i++) {
    newInvChols.slice(i) = inv_chols.slice(used_bg_components.at(i));
  }
  background_dist.add_components_invChols(means.cols(used_bg_components), newInvChols);
  vec newWeights = conv_to<vec>::from(num_usages_for_bg_dist.rows(used_bg_components))/active_samples.n_rows;
  background_dist.setWeights(newWeights);

  return background_dist;
}

// Getters
int SampleDatabase::getNumSamples() {return num_samples;}

arma::mat SampleDatabase::getSamples() {return samples;}

arma::mat SampleDatabase::getSamples(arma::uvec indices) {return samples.cols(indices); }

arma::vec SampleDatabase::getTargetDensities() {return target_densities;}

int SampleDatabase::getNumComponents() {return num_components;}

arma::mat SampleDatabase::getMeans() {return means.head_cols(num_components);}

arma::mat SampleDatabase::getMeans(arma::uvec indices) {return means.cols(indices);}

arma::cube SampleDatabase::getInvChols() {return inv_chols.head_slices(num_components);}

arma::vec SampleDatabase::getNumSamplingUsages() {return num_sampling_usages.head_rows(num_components);}
