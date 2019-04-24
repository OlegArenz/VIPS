#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd20
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/svgd_20l.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/svgd_20l.out.%j
#
#SBATCH -n 12    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### preliminary
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-5, "svgd_20l_10k_0.00005_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-5, "svgd_20l_10k_0.00005_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-5, "svgd_20l_10k_0.00005_3");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-4, "svgd_20l_10k_0.0001_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-4, "svgd_20l_10k_0.0001_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-4, "svgd_20l_10k_0.0001_3");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-4, "svgd_20l_10k_0.0005_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-4, "svgd_20l_10k_0.0005_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 5e-4, "svgd_20l_10k_0.0005_3");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-3, "svgd_20l_10k_0.001_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-3, "svgd_20l_10k_0.001_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.planar_robot_20 import *; sample(2000, 10000, 1e-3, "svgd_20l_10k_0.001_3");' &

wait
