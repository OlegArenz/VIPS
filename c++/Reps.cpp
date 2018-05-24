#include "Reps.h"
#include <nlopt.hpp>

// nlopt wrapper for objective function
double sample_based_reps_nlopt(const std::vector<double> &x, std::vector<double> &grad, void* instance) {
   Reps * obj = (Reps *) instance;
   double dualVal;
   double gradient;
   vec log_p;
   double KL;
   std::tie(dualVal, gradient, log_p, KL) = obj->sample_based_reps_dual((double) x[0]);
   grad[0] = gradient;
   return dualVal;
}

double sample_based_reps_with_entropy_bound_nlopt(const std::vector<double> &x, std::vector<double> &grad, void* instance) {
   Reps * obj = (Reps *) instance;
   double dualVal;
   vec gradient;
   std::tie(dualVal, gradient, std::ignore, std::ignore, std::ignore) = obj->sample_based_reps_dual_with_entropy_bound((double) x[0], (double) x[1]);
   grad[0] = gradient.at(0);
   grad[1] = gradient.at(1);
   return dualVal;
}

Reps::Reps(int dim) {
  this->dim = dim;
}


Reps::~Reps(void) {
}

// set reward
void Reps::set_reward(vec r) {
  this->r = r - max(r);
  this->r -= log(sum(exp(this->r)));
}

// set target distribution
void Reps::set_target_dist(vec log_q) {
  // normalize target distribution on samples
  this->log_q = log_q - max(log_q);
  this->log_q -= log(sum(exp(this->log_q)));
};

// set bounds
void Reps::set_bounds(double epsilon, double beta) {
   this->epsilon = epsilon;
   this->beta = beta;
};

/**
 * Evaluates the sample-based REPS dual function and computes the gradient for the given Lagrangian multiplier
 * @param eta
 * @return
 */
std::tuple<double, double, vec, double> Reps::sample_based_reps_dual(double eta) {
  // interpolate distribution and normalize
  log_p = 1/(1+eta) * (eta * log_q + r);
  double max_log_p = max(log_p);
  double Z_p = max_log_p + log(sum(exp(log_p - max_log_p)));
  log_p -= Z_p;
  p = exp(log_p);

  // compute dual and gradient
  double dualValue = (1+eta) * Z_p + eta * epsilon;
  KL = as_scalar(p.t() * (log_p - log_q));
  double gradient = epsilon - KL;

  //cout << "eta: " << eta << "dual: " << dualValue << "KL: " << KL << endl;
 // cout << "p: " << p.t() << endl;
  return make_tuple(dualValue, gradient, log_p, KL);
};

/**
 * Evaluates the sample-based REPS dual function and computes the gradient for the given Lagrangian multiplier
 * @param eta
 * @return
 */
std::tuple<double, vec, vec, double, double> Reps::sample_based_reps_dual_with_entropy_bound(double eta, double omega) {
  // interpolate distribution and normalize
  log_p = 1/(1+eta+omega) * (eta * log_q + r);
  double max_log_p = max(log_p);
  double Z_p = max_log_p + log(sum(exp(log_p - max_log_p)));
  log_p -= Z_p;
  p = exp(log_p);

  // compute dual and gradient
  double dualValue = (1+eta+omega) * Z_p + eta * epsilon - omega * beta;
  KL = as_scalar(p.t() * (log_p - log_q));
  entropy = as_scalar(-p.t() * log_p);
  vec gradient = { epsilon-KL, entropy-beta};

  return make_tuple(dualValue, gradient, log_p, KL, entropy);
};


int Reps::optimize(std::vector<double> &initial, bool dont_learn_omega) {
    nlopt::result res;
    if (beta == -datum::inf) {
        nlopt::opt nlopt = nlopt::opt(nlopt::LD_LBFGS, 1);
        nlopt.set_min_objective(sample_based_reps_nlopt, this);
        double lb_arr[] = {0};
        double ub_arr[] = {1e100};
        std::vector<double> lb(lb_arr, lb_arr + sizeof(lb_arr) / sizeof(double));
        std::vector<double> ub(ub_arr, ub_arr + sizeof(ub_arr) / sizeof(double));
        nlopt.set_lower_bounds(lb);
        nlopt.set_upper_bounds(ub);
        double dual;

        try {
            res = nlopt.optimize(initial, dual);
            //cout << "res of optimization: " << res << endl;
        } catch (std::exception& ex) {
            std::cout << ex.what() << " res: " << res << endl;
        }
        eta = initial[0];

        // run one more time, to make sure that all member functions are set correctly
        sample_based_reps_dual(eta);
    } else {
            nlopt::opt nlopt = nlopt::opt(nlopt::LD_LBFGS, 2);
            nlopt.set_min_objective(sample_based_reps_with_entropy_bound_nlopt, this);
            double lb_arr[2] = {0,0};
            double ub_arr[2] = {1e10, 1e10};
            if (dont_learn_omega) {
                lb_arr[1] = initial[1];
                ub_arr[1] = initial[1];
            }

            std::vector<double> lb(lb_arr, lb_arr + sizeof(lb_arr) / sizeof(double));
            std::vector<double> ub(ub_arr, ub_arr + sizeof(ub_arr) / sizeof(double));
            nlopt.set_lower_bounds(lb);
            nlopt.set_upper_bounds(ub);
            double dual;

            try {
                res = nlopt.optimize(initial, dual);
            } catch (std::exception& ex) {
             std::cout << ex.what() << " res: " << res << endl;
            }
            eta = initial[0];
            omega = initial[1];

            // run one more time, to make sure that all member functions are set correctly
            sample_based_reps_dual_with_entropy_bound(eta, omega);
    }
    return res;
}

std::tuple<double, double> Reps::test_obj_finite_difference(double eta, double epsilon, double fd) {
  double dual;
  vec gradient;
  vec ign1;
  double ign2;
  std::tie(dual, gradient, ign1, ign2) = sample_based_reps_dual(eta);

  double dual1;
  vec gradient1;
  std::tie(dual1, gradient1, ign1, ign2) = sample_based_reps_dual(eta+fd);

  return make_tuple(gradient[0], (dual1-dual) / fd);
}