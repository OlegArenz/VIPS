#!/bin/bash
#SBATCH -A project00490
#SBATCH -J svgdP_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/svgd_gmm_paperrun.err.%j
#SBATCH -o /home/j_arenz/jobs/svgd_gmm_paperrun.out.%j
#
#SBATCH -n 10     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_6");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_9");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005_10");' &


wait
