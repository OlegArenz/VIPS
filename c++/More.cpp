//
// Created by arenz on 18.07.17.
//

#include "More.h"
#include <nlopt.hpp>
#include <exception>

double nlopt_objective(const std::vector<double> &x, std::vector<double> &grad, void* instance) {
   More * obj = (More *) instance;
   double dualVal;
   vec gradient;
   std::tie(dualVal, gradient) = obj->dual_function_gaussian((double) x[0], (double) x[1]);
   grad[0] = gradient[0];
   grad[1] = gradient[1];
   return dualVal;
}


More::More(int dim) {
  this->dim = dim;
  this->triu_indices = find(trimatu(ones<mat>(dim, dim)));

  // quadratic surrogate
  R = mat(dim, dim, fill::none);
  r = vec(dim, fill::none);

  // last distribution (for KL bound)
  chol_Sigma_q = mat(dim, dim, fill::none);
  mat chol_Q = mat(dim, dim, fill::none);
  vec mu_q = vec(dim, fill::none);
  mat Q = mat(dim, dim, fill::none);
  vec q = vec(dim, fill::none);

  // optimal distribution
  mat chol_Sigma_p = mat(dim, dim, fill::none);
  mat chol_P = mat(dim, dim, fill::none);
  mat Sigma_p = mat(dim, dim, fill::none);
  vec mu_p = vec(dim, fill::none);
  mat P = mat(dim, dim, fill::none);
  vec p = vec(dim, fill::none);
}

More::~More(void) {
}

int More::run_lbfgs_nlopt(std::vector<double> &initial, bool dont_learn_omega) {
    nlopt::opt nlopt = nlopt::opt(nlopt::LD_LBFGS, 2);
 //   nlopt::opt nlopt = nlopt::opt(nlopt::LD_MMA, 2);
    nlopt.set_min_objective(nlopt_objective, this);
    double lb_arr[] = {0,0};
    double ub_arr[] = {1e10,1e10};
    if (dont_learn_omega) {
        lb_arr[1] = initial[1];
        ub_arr[1] = initial[1];
    }
    std::vector<double> lb(lb_arr, lb_arr + sizeof(lb_arr) / sizeof(double));
    std::vector<double> ub(ub_arr, ub_arr + sizeof(ub_arr) / sizeof(double));
    nlopt.set_lower_bounds(lb);
    nlopt.set_upper_bounds(ub);
    nlopt.set_maxeval(1000);
    nlopt::result res;
    double dual;
    try {
        res = nlopt.optimize(initial, dual);
    } catch (std::exception& ex) {
      if (res!=0) {
          std::cout << ex.what() << " res: " << res << " " << initial[0] << " " << initial[1] << endl;
          std::cout << "last val: " << nlopt.last_optimum_value() << endl;
          vec eigval2;
          mat eigvec2;
          mat D = R;
          eig_sym(eigval2, eigvec2, D);
          cout << "eigvals: " << endl << eigval2.t() << endl;
          return -1;
      }
    }
    eta = initial[0];
    omega = initial[1];

    // run one more time, to make sure that all member functions are set correctly
    vec grad;
    std::tie(dual,grad) = dual_function_gaussian(eta, omega);

    if (chol_Sigma_p.has_nan()) {
        cout << "Error in More:" << endl;
        cout << eta << " " << omega << " " << epsilon << " " << beta << endl;
        cout << "chol_Sigma_q" << endl << chol_Sigma_q << endl;
        cout << "chol_Q" << endl << chol_Q<< endl;
        cout << "Q" << endl << Q<< endl;
        cout << "q" << endl << q<< endl;
        cout << "R" << endl << R<< endl;
        cout << "r" << endl << r<< endl;
        cout << "r0" << endl << r0<< endl;
        return -2;
    }
    return res;
}


/**
 * Fits a quadratic surrogate using weighted ridge regression and stores the result in the member variables
 * @param regression_weights
 * @param X
 * @param targets
 * @param ridge_factor
 * @param omit_linear_term
 */
bool More::update_surrogate_normalizeData(vec regression_weights,
                      mat X,
                      vec targets,
                      mat cov,
                      vec mean,
                      double ridge_factor,
                      bool standardize,
                      bool omit_linear_term,
                      bool no_correlations
) {
  int num_data = X.n_rows;
  int num_linear_features = omit_linear_term ? 0 : dim;
  int num_features;
  if (no_correlations)
    num_features = 1 + num_linear_features + dim;
  else
    num_features =  1 + num_linear_features + static_cast<int>(std::round((dim + 1) * (0.5 * dim)));

  // Construct Design Matrix
  mat feature_matrix(num_data, num_features, fill::none);
  // constant features:
  feature_matrix.col(0) = ones<vec>(num_data);

  // linear features (zero centered)
  if (!omit_linear_term)
    feature_matrix.cols(1, num_linear_features) = X.each_row() - mean.t();

  // quadratic features
  for (int i=0; i<num_data; i++) {
    if (no_correlations) {
      rowvec quadratic_features = X.row(i) % X.row(i);
      feature_matrix.submat(i, num_linear_features+1, i, num_features-1) = quadratic_features;
    } else {
      mat quadratic_features = X.row(i).t() * X.row(i);
      feature_matrix.submat(i, num_linear_features+1, i, num_features-1) = quadratic_features(this->triu_indices).t();
    }
  }

  // standardize
  rowvec stddevs;
  if (standardize) {
    stddevs = stddev(feature_matrix);
    stddevs(0) = 1; // constant offset should not be scaled
    feature_matrix = feature_matrix.each_row() / stddevs;
  }

  // perform least squares regression
  mat features_weighted = feature_matrix.each_col() % regression_weights;
  mat regularizer(num_features, num_features,fill::eye);
  regularizer(0,0) = 0;
  regularizer *= ridge_factor;

  vec least_squares;
  bool invertible = solve(least_squares, features_weighted.t() * feature_matrix + regularizer,(features_weighted.t() * targets));

  if (!invertible) {
    return false;
  }

  // denormalize
  if (standardize) {
    least_squares = least_squares / stddevs.t();
  }

  // set R and r to the learned coefficients
  r0 = least_squares(0);

  if (!omit_linear_term)
    r = least_squares.rows(1,num_linear_features);
  else
    r.zeros();

  if (no_correlations) {
    R = diagmat(least_squares.rows(1+num_linear_features, num_features-1));
  } else {
    R.zeros();
    R(this->triu_indices) = least_squares.rows(1+num_linear_features, num_features-1);
    R = 0.5*(R + R.t());
  }

/*    vec eigenvals = vec(this->dim, fill::none);
  mat eigenvectors = mat(this->dim, this->dim, fill::none);
  eig_sym( eigenvals, eigenvectors, R);


  if (any(eigenvals > -1e-6)) {
    was_not_pnd = true;
    // make R pnd
    eigenvals = clamp(eigenvals, -1e100, -1e-6);
    mat D = diagmat(eigenvals);
    R = eigenvectors * D * eigenvectors.t();

    // refit r and constant
    mat features_weighted_lin = features_weighted.cols(0, num_linear_features);
    mat feature_matrix_lin = feature_matrix.cols(0, num_linear_features);
    vec y_current(num_data, fill::none);
    mat tmp = X * R;

    for (int i=0; i<num_data; i++)
      y_current(i) = as_scalar(tmp.row(i) * X.row(i).t());
    vec targets_lin = targets - y_current;
    mat regularizer_lin(1+num_linear_features, 1+num_linear_features,fill::eye);
    regularizer_lin *= ridge_factor;
    least_squares = solve(features_weighted_lin.t() * feature_matrix_lin + regularizer_lin,(features_weighted_lin.t() * targets));
    r0 = least_squares(0);
    if (!omit_linear_term)
      r = least_squares.rows(1, num_linear_features);
  };
*/
  R = - 2 * R;

  if (R.has_nan() || R.has_inf() || r.has_nan() || r.has_inf())
    return false;
  return true;
}

/**
 * Fits a quadratic surrogate using weighted ridge regression and stores the result in the member variables
 * @param regression_weights
 * @param X
 * @param targets
 * @param ridge_factor
 * @param omit_linear_term
 * @param no_correlations
 */
bool More::update_surrogate(vec regression_weights,
                      mat X,
                      vec targets,
                      double ridge_factor,
                      bool omit_linear_term,
                      bool no_correlations
) {
  bool was_not_pnd = false;
  int num_data = X.n_rows;
  int num_linear_features = omit_linear_term ? 0 : dim;
  int num_features;
  if (no_correlations)
    num_features = 1 + num_linear_features + dim;
  else
    num_features =  1 + num_linear_features + static_cast<int>(std::round((dim + 1) * (0.5 * dim)));

  // Construct Design Matrix
  mat feature_matrix(num_data, num_features, fill::none);
  // constant features:
  feature_matrix.col(0) = ones<vec>(num_data);

  // linear features
  if (!omit_linear_term)
    feature_matrix.cols(1, num_linear_features) = X;

  // quadratic features
  for (int i=0; i<num_data; i++) {
    if (no_correlations) {
      rowvec quadratic_features = X.row(i) % X.row(i);
      feature_matrix.submat(i, num_linear_features+1, i, num_features-1) = quadratic_features;
    } else {
      mat quadratic_features = X.row(i).t() * X.row(i);
      feature_matrix.submat(i, num_linear_features+1, i, num_features-1) = quadratic_features(this->triu_indices).t();
    }
  }

  // perform least squares regression
  mat features_weighted = feature_matrix.each_col() % regression_weights;
  mat regularizer(num_features, num_features,fill::eye);
//  regularizer(0,0) = 0;
  regularizer *= ridge_factor;
  vec least_squares = solve(features_weighted.t() * feature_matrix + regularizer,(features_weighted.t() * targets));

  // set R and r to the learned coefficients
  r0 = least_squares(0);

  if (!omit_linear_term)
    r = least_squares.rows(1,num_linear_features);
  else
    r.zeros();

  if (no_correlations) {
    R = diagmat(least_squares.rows(1+num_linear_features, num_features-1));
  } else {
    R.zeros();
    R(this->triu_indices) = least_squares.rows(1+num_linear_features, num_features-1);
    R = 0.5*(R + R.t());
  }

  // bring the reward function into the form r = - 1/2 x^T R x + x^T r
  R = - 2 * R;
  return was_not_pnd;
}


/**
 * Sets the target dist.
 * This version takes covariance matrix and mean
 * @param chol_Sigma_q
 * @param chol_Q
 * @param mu_q
 */
void More::set_target_dist(mat Sigma_q, vec mu_q) {
  this->chol_Sigma_q = chol(Sigma_q);
  this->chol_Q = inv(this->chol_Sigma_q);
  this->mu_q = mu_q;
  this->Q = chol_Q * chol_Q.t();
  this->q = Q * mu_q;
}

/**
 * Sets the target dist.
 * This version takes both, the cholesky decomposition of the the covariance matrix and it's inverse.
 * @param chol_Sigma_q
 * @param chol_Q
 * @param mu_q
 */
void More::set_target_dist(mat chol_Sigma_q, mat chol_Q, vec mu_q) {
  this->chol_Q = chol_Q;
  this->chol_Sigma_q = chol_Sigma_q;
  this->mu_q = mu_q;
  this->Q = chol_Q * chol_Q.t();
  this->q = Q * mu_q;

  /* mat Sigma_q = chol_Sigma_q.t() * chol_Sigma_q;
   cout << "norm on construction: " << norm(inv(trimatu(chol_Sigma_q)) - chol_Q) << endl;
   cout << "norm on construction: " << norm(chol_Sigma_q - inv(inv(chol_Sigma_q))) << endl;
   cout << "norm on construction: " << norm(chol_Sigma_q - inv(chol_Q)) << endl;
   cout << "norm on construction: " << norm(inv(chol_Sigma_q) - chol_Q) << endl;
   cout << "norm on construction: " << norm(inv(Sigma_q) - Q) << endl;
   cout << "norm on construction2: " << norm(inv(Q) - Sigma_q) << endl;*/

}

/**
 * Evaluates the dual function and computes the gradient for the given Lagrangian multipliers
 * @param eta
 * @param omega
 * @return
 */
std::tuple<double, vec> More::dual_function_gaussian(double eta, double omega) {
  // Somewhat mysterically, nlopt sometimes ignores the bounds and calls this functions with negative values - creating havoc
  if (eta < 0)
     eta = 0;
  if (omega < 0)
     omega = 0;

  // interpolated distribution
  P = eta * Q + R;
  p = eta * q + r;
  mat chol_P(Q.n_rows, Q.n_cols, fill::none);
  bool pd = chol(chol_P, P, "lower");
  if (!pd) {
  //  cout << "not pd" << endl;
    chol_Sigma_p = chol_Sigma_q;
    chol_P = chol_Q;
    P = Q;
    Sigma_p = inv_sympd(Q);
    mu_p = mu_q;
    p = q;
    KL = 0;
    vec gradient = {-10, 0};
    return make_tuple(1e8-eta*10, gradient);
  }
  chol_Sigma_p = inv(chol_P);
  Sigma_p = chol_Sigma_p.t() * chol_Sigma_p;
  mu_p = Sigma_p * p;

  // Covariance is rescaled after computation of the mean
  P = P / (eta + omega + 1);
  Sigma_p = (eta + omega + 1) * Sigma_p;
  chol_Sigma_p *= sqrt(eta + omega + 1);
  chol_P /= sqrt(eta + omega + 1);

  // compute log(det(2*pi*Sigma_q))
  double detTerm_q = as_scalar( 2 * sum(log(diagvec(chol_Sigma_q))) + dim * log(2 * M_PI) );

  // compute log(det(2*pi*Sigma_p))
  double detTerm_p = as_scalar(-2 * sum(log(diagvec(chol_P))) + dim * log(2 * M_PI) );

  double dualValue = eta * epsilon - beta * omega
                     + 0.5 * as_scalar(mu_p.t() * p
                                       - eta * mu_q.t() * q
                                       - eta * detTerm_q
                                       + (eta + omega + 1) * detTerm_p);

  KL = 0.5 * as_scalar((mu_q - mu_p).t() * Q * (mu_q - mu_p)
                       + detTerm_q
                       - detTerm_p
                       + trace(Q * Sigma_p)
                       - dim);

  entropy = 0.5 * (dim + detTerm_p);
  vec gradient(2, fill::none);
  gradient.at(0) = epsilon - KL;
  gradient.at(1) = entropy - beta;
  return make_tuple(dualValue, gradient);
};

double More::get_expected_reward() {
    return as_scalar(-0.5 * mu_p.t() * R * mu_p + mu_p.t() * r + r0 + trace(R*Sigma_p));
}

std::tuple<vec, vec> More::test_obj_finite_difference(double eta, double omega, double eps) {
  double dual;
  vec gradient;
  std::tie(dual, gradient) = dual_function_gaussian(eta, omega);

  double dual1;
  vec gradient1;
  std::tie(dual1, gradient1) = dual_function_gaussian(eta+eps, omega);

  double dual2;
  vec gradient2;
  std::tie(dual2, gradient2) = dual_function_gaussian(eta, omega+eps);

  vec finite_difference(2, fill::none);
  finite_difference.at(0) = (dual1-dual) / eps;
  finite_difference.at(1) = (dual2-dual) / eps;

  return make_tuple(gradient, finite_difference);
}

void More::set_bounds(double epsilon, double beta) {
  this->epsilon = epsilon;
  this->beta = beta;
}



