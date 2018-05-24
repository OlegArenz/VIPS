#!/bin/bash
#SBATCH -A project00490
#SBATCH -J svgd3link_paper
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/svgd_3link_paperrun.err.%j
#SBATCH -o /home/j_arenz/jobs/svgd_3link_paperrun.out.%j
#
#SBATCH -n 18     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 3
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_6");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_9");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.planar_robot_3 import *; sample(2000, 10000, 1e-3, "svgd_3link_V2_10k_0.001_10");' &



wait
