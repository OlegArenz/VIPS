#!/bin/bash

for i in 10;
do
    for j in `seq 1 5`;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.goodwin1_12_2 import *; sample(300000, \"ptmcmc_goodwin_300k_${i}chain_trial${j}\");";
    done
done
