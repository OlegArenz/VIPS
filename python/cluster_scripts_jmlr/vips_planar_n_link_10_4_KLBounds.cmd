#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_nlink10_4kl
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4kl.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_n_link10_4kl.out.%j
#
#SBATCH -n 27    # Anzahl der MPI-Prozesse
#SBATCH -c 1    # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL13/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL13/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL13/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-3);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL53/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL53/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL53/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-3);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL12/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL12/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL12/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-2);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL52/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL52/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL52/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-2);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL11/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL11/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL11/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL51/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL51/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL51/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL10/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL10/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL10/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=1e-0);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL50/1/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL50/2/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.planar_n_link_4points import *; run_on_cluster(10, "fast_adding", "VIPS_10link4_KL/fast_adding/init_100/KL50/3/", num_initial_components=100, outer_iters=1000, rate_of_dumps=10, fixedKL=5e-0);'  &


wait
