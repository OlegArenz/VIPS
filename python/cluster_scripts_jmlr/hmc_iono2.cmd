#!/bin/bash
#SBATCH -A project00790
#SBATCH -J hmcIono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/hmciono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/hmciono.out.%j
#
#SBATCH -n 10    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.001,"hmc_iono/10k_20_0.001/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.002,"hmc_iono/10k_20_0.002/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.005,"hmc_iono/10k_20_0.005/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.01,"hmc_iono/10k_20_0.01/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.02,"hmc_iono/10k_20_0.02/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.05,"hmc_iono/10k_20_0.05/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.1,"hmc_iono/10k_20_0.1/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.2,"hmc_iono/10k_20_0.2/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,0.5,"hmc_iono/10k_20_0.5/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono import *; sample_with_progress(20, 1000,20,1,"hmc_iono/10k_20_1/progress");' &



wait
