#!/bin/bash

for i in `seq 7 10`;
do
    for j in `seq 1 5`;
    do
        echo "Running with $i chain (Trial $j)"
        mpirun -n $i python -c "from experiments.PTMCMC.planarRobot_3 import *; sample(1000000, True, \"ptmcmc_3link_1Mio_${i}chain_trial${j}\");";
    done
done
