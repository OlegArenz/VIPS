#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_nlink10_4
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4l.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4l.out.%j
#
#SBATCH -n 10    # Anzahl der MPI-Prozesse
#SBATCH -c 1    # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "default", "VIPS_10link4/default/init_100/1/", num_initial_components=100, outer_iters=5000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "default", "VIPS_10link4/default/init_100/2/", num_initial_components=100, outer_iters=5000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "default", "VIPS_10link4/default/init_100/3/", num_initial_components=100, outer_iters=5000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "default", "VIPS_10link4/default/init_100/4/", num_initial_components=100, outer_iters=5000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "default", "VIPS_10link4/default/init_100/1/", num_initial_components=100, outer_iters=5000, rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4/fast_adding/init_100/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4/fast_adding/init_100/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4/fast_adding/init_100/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4/fast_adding/init_100/4/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4/fast_adding/init_100/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &



wait
