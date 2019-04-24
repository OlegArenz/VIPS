#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd10link_4
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/svgd_10link4.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/svgd_10link4.out.%j
#
#SBATCH -n 12    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 4
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-5, "svgd_10l4_13k_0.00001_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-5, "svgd_10l4_13k_0.00001_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-5, "svgd_10l4_13k_0.00001_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 2e-5, "svgd_10l4_13k_0.00002_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 2e-5, "svgd_10l4_13k_0.00002_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 2e-5, "svgd_10l4_13k_0.00002_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 5e-5, "svgd_10l4_13k_0.00005_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 5e-5, "svgd_10l4_13k_0.00005_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 5e-5, "svgd_10l4_13k_0.00005_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-4, "svgd_10l4_13k_0.0001_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-4, "svgd_10l4_13k_0.0001_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_10_4p import *; sample(2000, 13000, 1e-4, "svgd_10l4_13k_0.0001_3");' &



wait
