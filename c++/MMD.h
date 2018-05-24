#ifndef LTS_MMD_H
#define LTS_MMD_H

#define ARMA_DONT_PRINT_ERRORS
#include <armadillo>

class MMD {

private:
arma::mat groundtruth;
void estimate_kernel(arma::mat groundtruth, int max_points_for_median=1000);
arma::mat kernel;
double compute_MMD(arma::mat set1, arma::mat set2);
double compute_MMD_new(arma::mat set1, arma::mat set2);
arma::vec median_dist;

public:
MMD(double * samples_ptr, int samples_dim1, int samples_dim2);
~MMD(void);

double ustat1;
double m;
double alpha;

void estimate_median(int max_points_for_median);
void get_median(double ** median_out_ptr, int * median_out_dim1);

void estimate_kernel_on_gt(int max_points_for_median);

void set_kernel(double bandwidth);
void compute_MMD_gt(
// inputs
double * samples_ptr, int samples_dim1, int samples_dim2,
bool use_new,
// outputs
double * MMD);

double compute_MMD_known_ustat1(double ustat1, int m, arma::mat set1, arma::mat set2);

void compute_MMD(
// inputs
double * samples_ptr, int samples_dim1, int samples_dim2,
double * samples2_ptr, int samples2_dim1, int samples2_dim2,
bool use_new,
// outputs
double * MMD);
};

#endif