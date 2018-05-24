#include "SampleDatabase.h"

/**
 * A SampleDatabase keeps track of samples and the Gaussian distributions that generated them.
 * This information is used to create a concise GMM background distribution that can be used
 * for computing importance weights.
*/
SampleDatabase::SampleDatabase(int num_dimensions, int num_lates_comp_to_check)
        : num_dimensions(num_dimensions), num_latest_comp_to_check(num_lates_comp_to_check), num_samples(0),
          samples(num_dimensions, 0), target_densities(), map_samples_to_backgroundComp(),
          means(num_dimensions, 0), inv_chols(num_dimensions, num_dimensions, 0), num_components(0) {
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
 */
void SampleDatabase::add_component(arma::mat new_mean, arma::mat new_invChol) {
  int N = new_mean.n_cols;

  if (num_components == means.n_cols) {
    means.insert_cols(means.n_cols, 1000, false);
    inv_chols.insert_slices(inv_chols.n_slices, 1000, false);
  }

  means.col(num_components) = new_mean;
  inv_chols.slice(num_components) = new_invChol;

  num_components++;
}

/**
 * Adds new_samples and the corresponding log_densities.
 * The parameters means and inv_chols describe the components that generated each sample,
 * such that the number of components should correspond to the number of columns in new_samples.
 * Side effects:
 * For each sample this call will check whether the component already exists in this background GMM.
 * If if does exist, the number of usages is increased.
 * If it does not exist a new component will be added to the background GMM
 */
void SampleDatabase::add_samples(arma::mat new_samples, arma::mat new_target_densities, arma::mat means,
                                 arma::cube inv_chols) {
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
      add_component(means.col(i), inv_chols.slice(i));
      map_samples_to_backgroundComp[num_samples] = num_components - 1;
    }
    num_samples++;
  }
}


/**
 * Returns the N most recent samples along with their target_densities and a concise GMM from which the samples
 * could have been drawn from.
 */
std::tuple<arma::mat, arma::vec, GMM> SampleDatabase::select_newest_samples(int N) {
  mat selected_samples;
  vec selected_target_densities;
  uvec active_samples;
  if (N >= num_samples)
    active_samples = linspace<uvec>(0, num_samples-1, num_samples);
  else
    active_samples = linspace<uvec>(num_samples-N, num_samples-1, N);

  GMM background_distribution = get_bg_dist(active_samples);
  return std::make_tuple(samples.cols(active_samples), target_densities.rows(active_samples), background_distribution);
};

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

arma::mat SampleDatabase::getMeans() {return means;}

arma::mat SampleDatabase::getMeans(arma::uvec indices) {return means.cols(indices);}

arma::cube SampleDatabase::getInvChols() {return inv_chols;}

