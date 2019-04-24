#ifndef LTS_MORE_H
#define LTS_MORE_H

#define ARMA_DONT_PRINT_ERRORS
#include <armadillo>
#include <tuple>

using namespace std;
using namespace arma;

class More {
private:
    double dim;
    uvec triu_indices;

public:
    // ----- MEMBER VARIABLES ----- //
    // quadratic surrogate:
    mat R;
    vec r;
    double r0;

    // last distribution (for KL bound)
    mat chol_Sigma_q;
    mat chol_Q;
    vec mu_q;
    mat Q;
    vec q;

    // bounds
    double KL;
    double entropy;
    double epsilon;
    double beta;
    double eta;
    double omega;

    // optimal distribution
    mat chol_Sigma_p;
    mat chol_P;
    mat Sigma_p;
    vec mu_p;
    mat P;
    vec p;

    // ----- METHODS ----- //
    // Constructor
    More(int dim);

    // Destructor
    ~More(void);

    // Update Lagrangian multipliers and optimal distribution by optimizing the dual function
    int run_lbfgs(float initial_eta, float initial_omega);
    int run_lbfgs_nlopt(std::vector<double> &initial, bool dont_learn_omega);

    // objective function
    std::tuple<double, vec> dual_function_gaussian(double eta, double omega);

    // weighted ridge regression
    bool update_surrogate(vec regression_weights,
                      mat X,
                      vec targets,
                      double ridge_factor,
                      bool standardize=true,
                      bool omit_linear_term=false,
                      bool no_correlations=false
    );

    bool update_surrogate_CenterOnTrueMean(vec regression_weights,
                      mat X,
                      vec targets,
                      vec mean,
                      double ridge_factor,
                      bool standardize,
                      bool omit_linear_term,
                      bool no_correlations
    );

    // set target distribution
    void set_target_dist(mat Sigma_q, vec mu_q);
    void set_target_dist(mat chol_Sigma_q, mat chol_Q, vec mu_q);

    // set bounds
    void set_bounds(double epsilon, double beta);

    // compute expected reward
    double get_expected_reward();

    // debug functions
    std::tuple<vec, vec> test_obj_finite_difference(double eta, double omega, double eps);
};



#endif
