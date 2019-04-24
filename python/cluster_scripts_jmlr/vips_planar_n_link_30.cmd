#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_nlink_30
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link_30.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link_30.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/1/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/2/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/3/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/4/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/5/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_1/6/", num_initial_components=1, outer_iters=1000, rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/1/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/2/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/3/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/4/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/5/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(30, "fast_adding", "VIPS_30link/fast_adding/init_10/6/", num_initial_components=10, outer_iters=1000, rate_of_dumps=10);'  &

wait
