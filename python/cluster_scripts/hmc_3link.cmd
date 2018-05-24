#!/bin/bash
#SBATCH -A project00490
#SBATCH -J hmc_3l
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/hmc3l.err.%j
#SBATCH -o /home/j_arenz/jobs/hmc3l.out.%j
#
#SBATCH -n 24     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.00001,"hmc3lV2_10k_20_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.00001,"hmc3lV2_10k_50_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.00001,"hmc3lV2_10k_100_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.00001,"hmc3lV2_10k_150_0.00001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.00002,"hmc3lV2_10k_20_0.00002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.00002,"hmc3lV2_10k_50_0.00002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.00002,"hmc3lV2_10k_100_0.00002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.00002,"hmc3lV2_10k_150_0.00002");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.00005,"hmc3lV2_10k_20_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.00001,"hmc3lV2_10k_50_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.00001,"hmc3lV2_10k_100_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.00001,"hmc3lV2_10k_150_0.00001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.0001,"hmc3lV2_10k_20_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.0001,"hmc3lV2_10k_50_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.0001,"hmc3lV2_10k_100_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.0001,"hmc3lV2_10k_150_0.0001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.0005,"hmc3lV2_10k_20_0.0005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.0005,"hmc3lV2_10k_50_0.0005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.0005,"hmc3lV2_10k_100_0.0005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.0005,"hmc3lV2_10k_150_0.0005");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,20,0.005,"hmc3lV2_10k_20_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,50,0.005,"hmc3lV2_10k_50_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,100,0.005,"hmc3lV2_10k_100_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.HMC.planar_robot_3 import *; sample_with_progress(20, 1000,150,0.005,"hmc3lV2_10k_150_0.005");' &




wait
