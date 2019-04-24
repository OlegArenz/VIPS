#!/bin/bash
#SBATCH -A project00790
#SBATCH -J ess10link_4
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/ess_10l_4.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/ess_10l_4.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=400 python3 -c 'from experiments.ESS.planar_robot_10_4p import *; sample(10000000, "ess_10l_4_10mio_6");' &



wait
