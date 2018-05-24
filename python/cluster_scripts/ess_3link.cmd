#!/bin/bash
#SBATCH -A project00490
#SBATCH -J ess3link
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/ess3l.err.%j
#SBATCH -o /home/j_arenz/jobs/ess3l.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 10:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_1_V2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_2_V2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_3_V2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_4_V2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_5_V2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python3 -c 'from sampler.ESS.planar_robot_3 import *; sample(1000000, "ess_3l_1mio_6_V2");' &



wait
