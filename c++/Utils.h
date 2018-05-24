#include <armadillo>

using namespace arma;

/**
* Helper function for evaluating samples on Gaussian
*/
vec gaussian_pdf(mat chol_inv, mat sample_diff, bool return_log);