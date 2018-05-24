#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vipsER_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vipsE_gmm.err.%j
#SBATCH -o /home/j_arenz/jobs/vipsE_gmm.out.%j
#
#SBATCH -n 12      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/1/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/2/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/3/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/4/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/5/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/6/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/7/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/8/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/9/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/10/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/11/", 10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_GMM_rng2/explorative40_2/12/", 10);'  &


wait
