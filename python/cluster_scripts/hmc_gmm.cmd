#!/bin/bash
#SBATCH -A project00490
#SBATCH -J hmc_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/hmc_gmm.err.%j
#SBATCH -o /home/j_arenz/jobs/hmc_gmm.out.%j
#
#SBATCH -n 24     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.00001,"hmc_gmm_20k_5_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.00001,"hmc_gmm_20k_20_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.00001,"hmc_gmm_20k_50_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.00001,"hmc_gmm_20k_100_0.00001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.0001,"hmc_gmm_20k_5_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.0001,"hmc_gmm_20k_20_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.0001,"hmc_gmm_20k_50_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.0001,"hmc_gmm_20k_100_0.0001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.001,"hmc_gmm_20k_5_0.001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.001,"hmc_gmm_20k_20_0.001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.001,"hmc_gmm_20k_50_0.001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.001,"hmc_gmm_20k_100_0.001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.005,"hmc_gmm_20k_5_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.005,"hmc_gmm_20k_20_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.005,"hmc_gmm_20k_50_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.005,"hmc_gmm_20k_100_0.005");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.01,"hmc_gmm_20k_5_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.01,"hmc_gmm_20k_20_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.01,"hmc_gmm_20k_50_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.01,"hmc_gmm_20k_100_0.01");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,5,0.1,"hmc_gmm_20k_5_0.1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,20,0.1,"hmc_gmm_20k_20_0.1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,50,0.1,"hmc_gmm_20k_50_0.1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.targetGMM import *; sample_with_progress(20, 1000,100,0.1,"hmc_gmm_20k_100_0.1");' &
wait
