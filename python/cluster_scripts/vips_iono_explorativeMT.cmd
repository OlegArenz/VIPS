#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vipsM_iono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vips_iono_mt.err.%j
#SBATCH -o /home/j_arenz/jobs/vips_iono_mt.out.%j
#
#SBATCH -n 6     # Anzahl der MPI-Prozesse
#SBATCH -c 12     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/1", num_threads=12);'  &
srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/2", num_threads=12);'  &
srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/3", num_threads=12);'  &
srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/4", num_threads=12);'  &
srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/5", num_threads=12);'  &
srun -N1 -n1 -c12 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.ionosphere import *; run_on_cluster("explorative20", "VIPS_iono_MT/explorative/6", num_threads=12);'  &




wait
