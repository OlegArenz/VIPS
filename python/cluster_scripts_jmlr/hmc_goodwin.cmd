#!/bin/bash
#SBATCH -A project00790
#SBATCH -J hmc_gw
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/hmc_gw.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/hmc_gw.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run1/hmc_goodwin12_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run2/hmc_goodwin12_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run3/hmc_goodwin12_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run4/hmc_goodwin12_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run5/hmc_goodwin12_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.01,"HMC_GW12/run6/hmc_goodwin12_10k_20_0.01");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run1/hmc_goodwin12_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run2/hmc_goodwin12_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run3/hmc_goodwin12_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run4/hmc_goodwin12_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run5/hmc_goodwin12_10k_20_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.goodwin12 import *; sample_with_progress(100, 1000,20,0.02,"HMC_GW12/run6/hmc_goodwin12_10k_20_0.02");' &



wait
