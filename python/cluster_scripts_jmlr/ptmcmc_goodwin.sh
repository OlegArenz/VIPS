#!/bin/bash

for i in 10 30 50;
do
    for j in `seq 1 1`;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.goodwin1_20 import *; sample(1000000, \"ptmcmc_goodwin_1M_${i}chain_trial${j}\");";
    done
done
