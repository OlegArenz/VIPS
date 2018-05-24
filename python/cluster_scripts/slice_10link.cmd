#!/bin/bash
#SBATCH -A project00490
#SBATCH -J slice10link
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/slice10l.err.%j
#SBATCH -o /home/j_arenz/jobs/slice10l.out.%j
#
#SBATCH -n 24      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.01,"slice10l_1M_0.01");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.02,"slice10l_1M_0.02");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.05,"slice10l_1M_0.05");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.1,"slice10l_1M_0.1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.2,"slice10l_1M_0.2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=400 python -c 'from sampler.SliceSampling.planar_robot_10 import *; sample(1000000,0.5,"slice10l_1M_0.5");' &


wait
