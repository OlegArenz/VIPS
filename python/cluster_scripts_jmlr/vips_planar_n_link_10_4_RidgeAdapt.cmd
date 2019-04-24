#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_nlink10_4
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4l.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4l.out.%j
#
#SBATCH -n 30    # Anzahl der MPI-Prozesse
#SBATCH -c 1    # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge14/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge14/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge14/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge13/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge13/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge13/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge12/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge12/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge12/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge11/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge11/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge11/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge10/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge10/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge10/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge9/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge9/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge9/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge8/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge8/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge8/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge7/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge7/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge7/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge6/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge6/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_RIDGE/fast_adding/init_100/ridge6/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &


wait
