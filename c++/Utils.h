#include <armadillo>

using namespace arma;

mat sample_from_Gaussian(mat chol, vec mean, int n);

vec gaussian_pdf(mat chol_inv, mat sample_diff, bool return_log);

float compute_KL_from_invChols(mat invChol_p, mat Sigma_p, vec mu_p, mat invChol_q, vec mu_q);

arma::uvec sample_without_replacement(arma::vec log_probs, int n);

arma::uvec sample_without_replacement(arma::fvec log_probs, int n);

std::tuple<vec, vec, vec> softMax_2D(mat data);