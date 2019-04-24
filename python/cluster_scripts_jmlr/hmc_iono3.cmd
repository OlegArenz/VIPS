#!/bin/bash
#SBATCH -A project00730
#SBATCH -J hmcIono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/hmciono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/hmciono.out.%j
#
#SBATCH -n 30    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run1/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run2/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run3/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run4/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run5/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run6/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run7/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run8/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run9/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run10/progress");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run11/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run12/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run13/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run14/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run15/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run16/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run17/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run18/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run19/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run20/progress");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run21/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run22/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run23/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run24/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run25/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run26/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run27/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run28/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run29/progress");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.iono2 import *; sample_with_progress(100, 1000,20, 0.01,"hmc_iono/100k_20_0.01/run30/progress");' &

wait
