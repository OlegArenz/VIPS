%module MMD
%{
#define SWIG_FILE_WITH_INIT
#include "MMD.h"
%}

%include numpy.i

%init %{
import_array();
%}

%apply (double* INPLACE_ARRAY2, int DIM1, int DIM2) {
    (double * samples_ptr, int samples_dim1, int samples_dim2),
    (double * samples2_ptr, int samples2_dim1, int samples2_dim2)
    }

%apply (double** ARGOUTVIEWM_ARRAY1, int* DIM1) {
(double ** median_out_ptr, int * median_out_dim1)
}

%apply double *OUTPUT {
    double * MMD
     }
%include "MMD.h"



