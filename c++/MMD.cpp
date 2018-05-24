#include "MMD.h"
#define _USE_MATH_DEFINES
#include <cmath>
#include <omp.h>

using namespace std;
using namespace arma;

MMD::MMD(double * samples_ptr, int samples_dim1, int samples_dim2)
{
    groundtruth = mat(samples_ptr, samples_dim2, samples_dim1, false, true);
    estimate_median(1000);
    m = groundtruth.n_cols;
 //   estimate_kernel(groundtruth);
}

MMD::~MMD(void) {
}

void MMD::estimate_median(int max_points_for_median) {
    if (max_points_for_median > groundtruth.n_cols)
        max_points_for_median = groundtruth.n_cols;

    int num_distances = round(0.5 * (max_points_for_median-1) * (max_points_for_median));
    mat distances(groundtruth.n_rows, num_distances, fill::none);
    int index=0;
    for (int i=0; i<max_points_for_median; i++)
        for (int j=i+1; j<max_points_for_median; j++)
            distances.col(index++) = square(groundtruth.col(i) - groundtruth.col(j));
    median_dist = median(distances, 1);
}

void MMD::get_median(double ** median_out_ptr, int * median_out_dim1) {
    *median_out_dim1 = median_dist.n_rows;
    *median_out_ptr = (double *) malloc(sizeof(double) * (*median_out_dim1));
    memcpy(*median_out_ptr, median_dist.memptr(), sizeof(double) * (*median_out_dim1));
}

void MMD::estimate_kernel_on_gt(int max_points_for_median) {
    int middle = round(groundtruth.n_cols/2);
    mat set1 = groundtruth.cols(linspace<uvec>(0, middle-1, middle)).t();
    mat set2 = groundtruth.cols(linspace<uvec>(middle, groundtruth.n_cols-1, groundtruth.n_cols - middle)).t();
    alpha = 1;
    for (int i=0; i<20; i++) {
        alpha+=0.1;
        kernel = inv(alpha * diagmat(median_dist));
        cout << alpha << " " << compute_MMD(set1, set2) << endl;
    }
}

void MMD::estimate_kernel(mat groundtruth, int max_points_for_median) {
    if (max_points_for_median > groundtruth.n_cols)
        max_points_for_median = groundtruth.n_cols;

    int num_distances = round(0.5 * (max_points_for_median-1) * (max_points_for_median));
    mat distances(groundtruth.n_rows, num_distances, fill::none);
    int index=0;
    for (int i=0; i<max_points_for_median; i++)
        for (int j=i+1; j<max_points_for_median; j++)
            distances.col(index++) = abs(groundtruth.col(i) - groundtruth.col(j));
    median_dist = median(distances, 1);

    int middle = round(groundtruth.n_cols/2);
/*
    mat set1 = groundtruth.cols(linspace<uvec>(0, middle-1, middle)).t();
    mat set2 = groundtruth.cols(linspace<uvec>(middle, groundtruth.n_cols-1, groundtruth.n_cols - middle)).t();
    alpha = 1e-1;
    for (int i=0; i<10; i++) {
        alpha*=2;
        kernel = inv(alpha * diagmat(median_dist));
        cout << alpha << " " << compute_MMD(set1, set2) << endl;
    } */
}

void MMD::compute_MMD(
// inputs
double * samples_ptr, int samples_dim1, int samples_dim2,
double * samples2_ptr, int samples2_dim1, int samples2_dim2,
bool use_new,
// outputs
double * MMD) {
    mat set1 = mat(samples_ptr, samples_dim2, samples_dim1, false, true).t();
    mat set2 = mat(samples2_ptr, samples2_dim2, samples2_dim1, false, true).t();
    if (use_new)
        (*MMD) = compute_MMD_new(set1, set2);
    else
        (*MMD) = compute_MMD(set1, set2);
}

void MMD::set_kernel(double bandwidth) {
    alpha = bandwidth;
    kernel = inv(alpha * diagmat(median_dist));

    ustat1 = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<m; j++) {
            vec diff =  groundtruth.col(i) - groundtruth.col(j);
            ustat1 += as_scalar(exp(- diff.t() * kernel * diff));
        }
}

void MMD::compute_MMD_gt(
// inputs
double * samples_ptr, int samples_dim1, int samples_dim2,
bool use_new,
// outputs
double * MMD) {
    mat set1 = mat(samples_ptr, samples_dim2, samples_dim1, false, true).t();
    if (use_new)
        (*MMD) = compute_MMD_known_ustat1(ustat1, m, groundtruth.t(), set1);
    else
        (*MMD) = compute_MMD(set1, groundtruth.t());
}

double MMD::compute_MMD_known_ustat1(double ustat1, int m, mat set1, mat set2) {
    //cout << kernel << endl;
    int n=set2.n_rows;

    double ustat2 = 0;
    for (int i=0; i<n; i++)
        for (int j=0; j<n; j++) {
            rowvec diff =  set2.row(i) - set2.row(j);
            ustat2 += as_scalar(exp(- diff * kernel * diff.t()));
        }

    double sample_average = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<n; j++) {
            rowvec diff =  set1.row(i) - set2.row(j);
            sample_average += as_scalar(exp(- diff * kernel * diff.t()));        }

    double MMD = 1./(m*m) * ustat1 + 1./(n*n) * ustat2 - 2./(m*n) * sample_average;
    //cout << "intermediate: "<< ustat1 << " " << ustat2 << " " << sample_average << endl;
    return MMD;
}


double MMD::compute_MMD_new(mat set1, mat set2) {
    //cout << kernel << endl;
    int m=set1.n_rows;
    int n=set2.n_rows;
    double ustat1 = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<m; j++) {
            rowvec diff =  set1.row(i) - set1.row(j);
            ustat1 += as_scalar(exp(- diff * kernel * diff.t()));
        }

    double ustat2 = 0;
    for (int i=0; i<n; i++)
        for (int j=0; j<n; j++) {
            rowvec diff =  set2.row(i) - set2.row(j);
            ustat2 += as_scalar(exp(- diff * kernel * diff.t()));
        }

    double sample_average = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<n; j++) {
            rowvec diff =  set1.row(i) - set2.row(j);
            sample_average += as_scalar(exp(- diff * kernel * diff.t()));        }

    double MMD = 1./(m*m) * ustat1 + 1./(n*n) * ustat2 - 2./(m*n) * sample_average;
    //cout << "intermediate: "<< ustat1 << " " << ustat2 << " " << sample_average << endl;
    return MMD;
}


double MMD::compute_MMD(mat set1, mat set2) {
    //cout << kernel << endl;
    int m=set1.n_rows;
    int n=set2.n_rows;
    double ustat1 = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<m; j++) {
            if (i==j)
                continue;
            rowvec diff =  set1.row(i) - set1.row(j);
            ustat1 += as_scalar(exp(- diff * kernel * diff.t()));
        }

    double ustat2 = 0;
    for (int i=0; i<n; i++)
        for (int j=0; j<n; j++) {
            if (i==j)
                continue;
            rowvec diff =  set2.row(i) - set2.row(j);
            ustat2 += as_scalar(exp(- diff * kernel * diff.t()));
        }

    double sample_average = 0;
    for (int i=0; i<m; i++)
        for (int j=0; j<n; j++) {
            rowvec diff =  set1.row(i) - set2.row(j);
            sample_average += as_scalar(exp(- diff * kernel * diff.t()));        }

    double MMD = 1./(m*(m-1)) * ustat1 + 1./(n*(n-1)) * ustat2 - 2./(m*n) * sample_average;
    //cout << "intermediate: "<< ustat1 << " " << ustat2 << " " << sample_average << endl;
    return MMD;
}



