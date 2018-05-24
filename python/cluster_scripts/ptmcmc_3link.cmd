#!/bin/bash
#SBATCH -A project00490
#SBATCH -J pt3link
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/pt3l.err.%j
#SBATCH -o /home/j_arenz/jobs/pt3l.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 10:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


srun -N1 -n2 -c1 --time=1-00:00:00 --mem-per-cpu=400 mpirun -n 2 python -c 'from sampler.PTMCMCSampler.planarRobot_3 import *; sample(1000000, "ptmcmc_3link_1Mio_2chain_trial1", True);' &
srun -N1 -n2 -c1 --time=1-00:00:00 --mem-per-cpu=400 mpirun -n 2 python -c 'from sampler.PTMCMCSampler.planarRobot_3 import *; sample(1000000, "ptmcmc_3link_1Mio_2chain_trial2", True);' &
srun -N1 -n2 -c1 --time=1-00:00:00 --mem-per-cpu=400 mpirun -n 2 python -c 'from sampler.PTMCMCSampler.planarRobot_3 import *; sample(1000000, "ptmcmc_3link_1Mio_2chain_trial3", True);' &



wait
