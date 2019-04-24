#!/bin/bash

for i in 5 10 15 20 25 30;
do
    for j in 1;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.target_GMM import *; sample(1000000, \"ptmcmc_GMM_1Mio_${i}chain_trial${j}\", True);";
    done
done
