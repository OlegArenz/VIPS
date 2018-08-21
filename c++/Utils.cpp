#include "Utils.h"
#define _USE_MATH_DEFINES

/**
* Helper function for evaluating samples on a given Gaussian
* @param chol_inv inverse of cholesky matrix <br>
* @param sample_diff - a matrix, such that each column corresponds to (mean - x_i), where x_i is a location for which the pdf should be evaluated <br>
* @param return_log - if true, return log(p(x))
*/
vec gaussian_pdf(mat chol_inv, mat sample_diff, bool return_log) {
  double offset = -0.5 * chol_inv.n_cols * log(2 * M_PI);
  double logDet_by2 = arma::sum(log(chol_inv.diag()));
  vec logpdf(sample_diff.n_cols, fill::none);
  mat z = chol_inv.t() * sample_diff;
  for (int i = 0; i < sample_diff.n_cols; i++) {
    logpdf.at(i) = offset - 0.5 * as_scalar(z.col(i).t() * z.col(i)) + logDet_by2;
  }
  if (return_log)
    return logpdf;
  else
    return exp(logpdf);
}