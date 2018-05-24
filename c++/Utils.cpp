#include "Utils.h"
#define _USE_MATH_DEFINES

/**
* Helper function for evaluating samples on Gaussian
*/
vec gaussian_pdf(mat chol_inv, mat sample_diff, bool return_log) {
  double offset = -0.5 * chol_inv.n_cols * log(2 * M_PI);
  vec logpdf(sample_diff.n_cols, fill::none);
  double logDet_by2 = arma::sum(log(chol_inv.diag()));
  mat z = chol_inv.t() * sample_diff;
  for (int i = 0; i < sample_diff.n_cols; i++) {
    logpdf.at(i) = offset - 0.5 * as_scalar(z.col(i).t() * z.col(i)) + logDet_by2;
  }
  if (return_log)
    return logpdf;
  else
    return exp(logpdf);
}