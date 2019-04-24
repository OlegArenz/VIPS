#include "Utils.h"
#include <random>
#include <ctime>
#define _USE_MATH_DEFINES


/**
* Draw n samples from the specified Gaussian
*/
mat sample_from_Gaussian(mat chol, vec mean, int n) {
  //std::default_random_engine rng(static_cast<long unsigned int>(time(0)));
  mat samples_out = chol * randn(mean.n_rows, n);
  samples_out = samples_out.each_col() + mean;
  return samples_out;
}

/**
* Helper function for evaluating samples on Gaussian
*/
vec gaussian_pdf(mat chol_inv, mat sample_diff, bool return_log) {
  double offset = -0.5 * chol_inv.n_cols * log(2 * M_PI);
  vec logpdf(sample_diff.n_cols, fill::none);
  double logDet_by2 = arma::sum(log(chol_inv.diag()));
  mat z = trimatl(chol_inv) * sample_diff;
/*  if (chol_inv.at(0,1) > 1e-6) {
    cout << chol_inv << endl;
  }*/
  for (int i = 0; i < sample_diff.n_cols; i++) {
    logpdf.at(i) = offset - 0.5 * as_scalar(z.col(i).t() * z.col(i)) + logDet_by2;
  }
//  logpdf = offset + logDet_by2 - 0.5 * arma::sum(arma::square(trimatl(chol_inv) * sample_diff),0).t(); <-- seems slower

  if (return_log)
    return logpdf;
  else
    return exp(logpdf);
}

/**
 * Compute the KL(p||q) between two Gaussians based on the means
 * and the cholesky decompositions of the precision matrices.
 * @param invChol_p - a triangular matrix such that inv(Sigma_p) = invChol_p.t() * invChol_p
 * @param Sigma_p - the covariance matrix corresponding to invChol_p
 * @param mu_p - mean of the first Gaussian
 * @param invChol_q - a triangular matrix such that inv(Sigma_q) = invChol_q.t() * invChol_q
 * @param mu_q - mean of the second Gaussian
 * @return the Kullback-Leibler divergence between p and q
 */
float compute_KL_from_invChols(mat invChol_p, mat Sigma_p, vec mu_p, mat invChol_q, vec mu_q) {
  int dim = mu_p.n_rows;

  // compute log(det(2*pi*Sigma_q))
  double detTerm_q = as_scalar(-2 * sum(log(diagvec(invChol_q))) + dim * log(2 * M_PI));

  // compute log(det(2*pi*Sigma_p))
  double detTerm_p = as_scalar(-2 * sum(log(diagvec(invChol_p))) + dim * log(2 * M_PI));

  arma::mat Q = invChol_q.t() * invChol_q;

  float KL = 0.5 * as_scalar((mu_q - mu_p).t() * Q * (mu_q - mu_p)
                       + detTerm_q
                       - detTerm_p
                       + trace(Q * Sigma_p)
                       - dim);
  if (std::isinf(KL))
    return (float) 1e20;

  return KL;
}


/**
 * Draw n samples without replacement
 * @param log_probs log of the probabilities
 * @param n number of samples to be drawn
 * @return a vector containing the drawn indices
 */
arma::uvec sample_without_replacement(arma::vec log_probs, int n) {
  if (n==0 || log_probs.n_rows==0)
    return uvec();

  uvec samples(std::min(n, (int) (log_probs.n_rows)));
  vec remaining_log_probs = log_probs;
  uvec remaining_indices = linspace<uvec>(0, log_probs.n_rows-1, log_probs.n_rows);

  thread_local static std::default_random_engine rng(static_cast<long unsigned int>(time(0)));
  thread_local static std::uniform_real_distribution<double> dis(0.0, 1.0);

  for (int i=0; i<n; i++) {
    remaining_log_probs -= arma::max(remaining_log_probs);
    remaining_log_probs -= log(sum(exp(remaining_log_probs)));
    vec cumSum = cumsum(exp(remaining_log_probs));


    double rand = dis(rng);
    uvec test = find(rand<=cumSum, 1, "first");
    while(test.n_rows != 1) {
        rand = dis(rng);
        test = find(rand<=cumSum, 1, "first");
        cout << "strangeness in sample_without_replacement(), trying again" << endl;
    }

    int chosen_sample = as_scalar(test);
    samples.at(i) = remaining_indices.at(chosen_sample);
    remaining_log_probs.shed_row(chosen_sample);
    remaining_indices.shed_row(chosen_sample);

    if (remaining_indices.n_rows == 0)
    break;
  }
  return samples;
}

/**
 * Draw n samples without replacement
 * @param log_probs log of the probabilities
 * @param n number of samples to be drawn
 * @return a vector containing the drawn indices
 */
arma::uvec sample_without_replacement(arma::fvec log_probs, int n) {
  if (n==0 || log_probs.n_rows==0)
    return uvec();

  uvec samples(std::min(n, (int) (log_probs.n_rows)));
  fvec remaining_log_probs = log_probs;
  uvec remaining_indices = linspace<uvec>(0, log_probs.n_rows-1, log_probs.n_rows);

  thread_local static std::default_random_engine rng(static_cast<long unsigned int>(time(0)));
  thread_local static std::uniform_real_distribution<float> dis(0.0, 1.0);
  for (int i=0; i<n; i++) {
    remaining_log_probs -= arma::max(remaining_log_probs);
    remaining_log_probs -= log(sum(exp(remaining_log_probs)));
    fvec remaining_probs = exp(remaining_log_probs);
    remaining_probs /= sum(remaining_probs);
    fvec cumSum = cumsum(remaining_probs);

    float rand = dis(rng);
    uvec test = find(rand<=cumSum, 1, "first");

    while(test.n_rows != 1) {
        rand = dis(rng);
        test = find(rand<=cumSum, 1, "first");
        cout << "strangeness in sample_without_replacement(), trying again" << endl;
    }
    int chosen_sample = as_scalar(test);
    samples.at(i) = remaining_indices.at(chosen_sample);
    remaining_log_probs.shed_row(chosen_sample);
    remaining_indices.shed_row(chosen_sample);
    if (remaining_indices.n_rows == 0)
        break;
  }
  return samples;
}

/**
* computes log(sum(exp(data))) columnwise
* @returns a tuple containing<br>
* tuple[0]: a vector containing the column-wise softmaxs, max(data) + log(sum(exp(data-max(data)))<br>
* tuple[1]: a vector containing column-wise offsets, i.e. -max(data)<br>
* tuple[2]: a vector containing the column-wise summations, sum(exp(data-max(data)))
*/
std::tuple<vec, vec, vec> softMax_2D(mat data) {
  rowvec columnwise_offsets = -max(data, 0);
  vec summation_with_offsets = sum(exp(data.each_row() + columnwise_offsets), 0).t();
  vec softMax2D = log(summation_with_offsets) - columnwise_offsets.t();
  return std::make_tuple(softMax2D, columnwise_offsets.t(), summation_with_offsets);
}
