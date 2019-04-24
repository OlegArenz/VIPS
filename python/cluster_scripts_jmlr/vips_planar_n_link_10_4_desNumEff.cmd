#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_nlink10_4neff
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4neff.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4neff.out.%j
#
#SBATCH -n 15    # Anzahl der MPI-Prozesse
#SBATCH -c 1    # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/10/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/10/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/10/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/20/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/20/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/20/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=20);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/30/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/30/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/30/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=30);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/40/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=40);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/40/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=40);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/40/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=40);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/50/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/50/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_NEFF/fast_adding/init_100/50/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, des_num_eff=50);'  &

wait
