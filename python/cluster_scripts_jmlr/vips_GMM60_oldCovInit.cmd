#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_gmm60_Cov
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#
#SBATCH -n 5      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.out.1 -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.err.1 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("default", "VIPS_GMM60_cov/iso_scaledEnt/init_1/1/", num_dimensions=60, num_initial=1, num_outer=500, rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.out.2 -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.err.2 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("default", "VIPS_GMM60_cov/iso_scaledEnt/init_1/2/", num_dimensions=60, num_initial=1, num_outer=500, rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.out.3 -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.err.3 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("default", "VIPS_GMM60_cov/iso_scaledEnt/init_1/3/", num_dimensions=60, num_initial=1, num_outer=500, rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.out.2 -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.err.4 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("default", "VIPS_GMM60_cov/iso_scaledEnt/init_1/4/", num_dimensions=60, num_initial=1, num_outer=500, rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.out.3 -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm60_12MS.err.5 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("default", "VIPS_GMM60_cov/iso_scaledEnt/init_1/5/", num_dimensions=60, num_initial=1, num_outer=500, rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &

wait
