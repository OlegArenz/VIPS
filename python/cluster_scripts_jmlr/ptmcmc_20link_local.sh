#!/bin/bash

for i in 10 20 30;
do
    for j in `seq 1 1`;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.planarRobot_20 import *; sample(1000000, \"ptmcmc_20link_100k_${i}chain_trial${j}\", True);";
    done
done
