#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vips_10l
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vips_10l.err.%j
#SBATCH -o /home/j_arenz/jobs/vips_10l.out.%j
#
#SBATCH -n 24      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/1", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/2", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/3", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/4", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/5", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/6", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/7", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/8", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/9", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/10", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/11", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "explorative40", "VIPS_10Link_rng2/explorative/12", 10);'  &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/1", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/2", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/3", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/4", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/5", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/6", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/7", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/8", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/9", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/10", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/11", 10);'  &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.planar_n_link import *; run_on_cluster(10, "greedy", "VIPS_10Link_rng2/greedy/12", 10);'  &

wait
