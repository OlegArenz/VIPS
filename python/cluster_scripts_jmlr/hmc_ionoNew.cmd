#!/bin/bash
#SBATCH -A project00790
#SBATCH -J iono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/iono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/iono.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run1/hmc_iono2_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run2/hmc_iono2_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run3/hmc_iono2_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run4/hmc_iono2_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run5/hmc_iono2_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.01,"HMC_IONO_NEW/run6/hmc_iono2_10k_20_0.01");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run1/hmc_iono2_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run2/hmc_iono2_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run3/hmc_iono2_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run4/hmc_iono2_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run5/hmc_iono2_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(50, 1000,20,0.02,"HMC_IONO_NEW/run6/hmc_iono2_10k_20_0.02");' &



wait
