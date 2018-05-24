#!/bin/bash
#SBATCH -A project00490
#SBATCH -J svgd10link_paper2
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/svgd10l_paperrun2.err.%j
#SBATCH -o /home/j_arenz/jobs/svgd10l_paperrun2.out.%j
#
#SBATCH -n 10    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 4
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_6");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_9");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_10 import *; sample(2000, 10000, 2e-5, "svgd_10l_10k_0.00002_10");' &



wait
