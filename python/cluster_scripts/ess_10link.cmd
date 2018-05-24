#!/bin/bash
#SBATCH -A project00490
#SBATCH -J ess10link
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/ess10l.err.%j
#SBATCH -o /home/j_arenz/jobs/ess10l.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 10:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_5");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_10 import *; sample(1000000, "ess_10l_1mio_6");' &



wait
