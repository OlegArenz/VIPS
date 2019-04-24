#!/bin/bash

for i in 10 20 30;
do
    for j in `seq 1 1`;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.planarRobot_10_3 import *; sample(1000000, \"ptmcmc_10link3_1Mio_${i}chain_trial${j}\", True);";
    done
done
