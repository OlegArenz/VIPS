#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_pla10_4MT
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4MT.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4MT.out.%j
#
#SBATCH -n 5    # Anzahl der MPI-Prozesse
#SBATCH -c 12     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -n5 -c12 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "explorative1000", "VIPS_planar_10_link_4_MT/explorative1000/init_100/1/", num_initial_components=100, outer_iters=2000, rate_of_dumps=10, num_threads=70);'  &


wait
