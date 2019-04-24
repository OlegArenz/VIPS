#!/bin/bash
#SBATCH -A project00790
#SBATCH -J hmc_bc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/hmc_bc.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/hmc_bc.out.%j
#
#SBATCH -n 20     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 1-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,5,0.00001,"HMC_BC/hmc_bc_10k_5_0.00001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,5,0.0001,"HMC_BC/hmc_bc_10k_5_0.0001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,5,0.001,"HMC_BC/hmc_bc_10k_5_0.001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,5,0.01,"HMC_BC/hmc_bc_10k_5_0.01");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,5,0.1,"HMC_BC/hmc_bc_10k_5_0.1");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,10,0.00001,"HMC_BC/hmc_bc_10k_10_0.00001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,10,0.0001,"HMC_BC/hmc_bc_10k_10_0.0001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,10,0.001,"HMC_BC/hmc_bc_10k_10_0.001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,10,0.01,"HMC_BC/hmc_bc_10k_10_0.01");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,10,0.1,"HMC_BC/hmc_bc_10k_10_0.1");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,20,0.00001,"HMC_BC/hmc_bc_10k_20_0.00001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,20,0.0001,"HMC_BC/hmc_bc_10k_20_0.0001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,20,0.001,"HMC_BC/hmc_bc_10k_20_0.001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,20,0.01,"HMC_BC/hmc_bc_10k_20_0.01");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,20,0.1,"HMC_BC/hmc_bc_10k_20_0.1");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,50,0.00001,"HMC_BC/hmc_bc_10k_50_0.00001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,50,0.0001,"HMC_BC/hmc_bc_10k_50_0.0001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,50,0.001,"HMC_BC/hmc_bc_10k_50_0.001");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,50,0.01,"HMC_BC/hmc_bc_10k_50_0.01");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.HMC.breast_cancer import *; sample_with_progress(100, 2000,50,0.1,"HMC_BC/hmc_bc_10k_50_0.1");' &

wait
