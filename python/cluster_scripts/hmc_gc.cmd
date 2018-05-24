#!/bin/bash
#SBATCH -A project00490
#SBATCH -J hmcN_gc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/hmcN_gc.err.%j
#SBATCH -o /home/j_arenz/jobs/hmcN_gc.out.%j
#
#SBATCH -n 40     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 1-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00001,"hmc_gc_10k_10_0.00001_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00001,"hmc_gc_10k_10_0.00001_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00001,"hmc_gc_10k_10_0.00001_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00001,"hmc_gc_10k_10_0.00001_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00001,"hmc_gc_10k_10_0.00001_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00002,"hmc_gc_10k_10_0.00002_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00002,"hmc_gc_10k_10_0.00002_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00002,"hmc_gc_10k_10_0.00002_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00002,"hmc_gc_10k_10_0.00002_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.00002,"hmc_gc_10k_10_0.00002_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0001,"hmc_gc_10k_10_0.0001_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0001,"hmc_gc_10k_10_0.0001_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0001,"hmc_gc_10k_10_0.0001_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0001,"hmc_gc_10k_10_0.0001_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0001,"hmc_gc_10k_10_0.0001_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0002,"hmc_gc_10k_10_0.0002_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0002,"hmc_gc_10k_10_0.0002_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0002,"hmc_gc_10k_10_0.0002_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0002,"hmc_gc_10k_10_0.0002_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.0002,"hmc_gc_10k_10_0.0002_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.001,"hmc_gc_10k_10_0.001_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.001,"hmc_gc_10k_10_0.001_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.001,"hmc_gc_10k_10_0.001_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.001,"hmc_gc_10k_10_0.001_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.001,"hmc_gc_10k_10_0.001_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.002,"hmc_gc_10k_10_0.002_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.002,"hmc_gc_10k_10_0.002_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.002,"hmc_gc_10k_10_0.002_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.002,"hmc_gc_10k_10_0.002_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.002,"hmc_gc_10k_10_0.002_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.01,"hmc_gc_10k_10_0.01_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.01,"hmc_gc_10k_10_0.01_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.01,"hmc_gc_10k_10_0.01_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.01,"hmc_gc_10k_10_0.01_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.01,"hmc_gc_10k_10_0.01_5");' &

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.02,"hmc_gc_10k_10_0.02_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.02,"hmc_gc_10k_10_0.02_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.02,"hmc_gc_10k_10_0.02_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.02,"hmc_gc_10k_10_0.02_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.german_credit import *; sample_with_progress(20, 1000,10,0.02,"hmc_gc_10k_10_0.02_5");' &

wait
