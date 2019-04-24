#!/bin/bash
#SBATCH -A project00730
#SBATCH -J hmc_gc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/hmc_gc3.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/hmc_gc3.out.%j
#
#SBATCH -n 30     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=2048   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_1/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_2/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_3/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_4/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_5/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_6/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_7/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_8/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_9/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_10/progress");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_11/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_12/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_13/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_14/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_15/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_16/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_17/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_18/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_19/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_20/progress");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_21/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_22/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_23/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_24/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_25/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_26/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_27/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_28/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_29/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.HMC.german_credit import *; sample_with_progress(1000, 1000,100,0.005,"HMC_GC3/hmc_gc_10k_100_0.005_30/progress");' &
wait