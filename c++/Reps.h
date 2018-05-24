#ifndef LTS_REPS_H
#define LTS_REPS_H

#define ARMA_DONT_PRINT_ERRORS
#include <armadillo>
#include <tuple>

using namespace std;
using namespace arma;

class Reps {
private:
    double dim;


public:
    double eta;
    double omega;
    vec p;
    vec log_p;
    double KL;
    double entropy;

    vec r;
    vec log_q;
    double epsilon;
    double beta;

    // ----- METHODS ----- //
    // Constructor
    Reps(int dim);

    // Destructor
    ~Reps(void);

    // Update Lagrangian multipliers and optimal distribution by optimizing the dual function
    int optimize(std::vector<double> &initial, bool dont_learn_omega);

    // objective function
    std::tuple<double, double, vec, double> sample_based_reps_dual(double eta);
    std::tuple<double, vec, vec, double, double> sample_based_reps_dual_with_entropy_bound(double eta, double omega);

    // set reward
    void set_reward(vec r);

    // set target distribution
    void set_target_dist(vec log_q);

    // set bounds
    void set_bounds(double epsilon, double beta=-datum::inf);

    // debug
    std::tuple<double, double> test_obj_finite_difference(double eta, double epsilon, double fd) ;
};



#endif //LTS_REPS_H
