#!/bin/bash
#SBATCH -A project00790
#SBATCH -J hmcFrisk
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/hmcFrisk.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/hmcFrisk.out.%j
#
#SBATCH -n 8     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run6");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.frisk import *; sample_with_progress(100, 2000,50,0.005,"HMC_FRISK3/hmc_frisk_10k_50_0.005_run8");' &

wait
