#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vipsM_gmm40
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vipsERM_gmm40.err.%j
#SBATCH -o /home/j_arenz/jobs/vipsERM_gmm40.out.%j
#
#SBATCH -n 12      # Anzahl der MPI-Prozesse
#SBATCH -c 4     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=3000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/1/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/2/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/3/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/4/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/5/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/6/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/7/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/8/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/9/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/10/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/11/", 10, num_dimensions=40, num_threads=4);'  &
srun -n1 -c4 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM40_MT/explorative40_2/12/", 10, num_dimensions=40, num_threads=4);'  &


wait
