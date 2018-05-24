#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vipsMT8test_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vipsMTtest_gm.err.%j
#SBATCH -o /home/j_arenz/jobs/vipsMTtest_gm.out.%j
#
#SBATCH -n 3      # Anzahl der MPI-Prozesse
#SBATCH -c 8     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=3000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -n1 -c8 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_MTtest8_gmm/explorative40_2/1/", 10, num_dimensions=20, num_threads=8);'  &
srun -n1 -c8 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_MTtest8_gmm/explorative40_2/2/", 10, num_dimensions=20, num_threads=8);'  &
srun -n1 -c8 --time=2-00:00:00 --mem-per-cpu=3000 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("explorative40", "VIPS_MTtest8_gmm/explorative40_2/3/", 10, num_dimensions=20, num_threads=8);'  &

wait
