#!/bin/bash
#SBATCH -A project00490
#SBATCH -J svgd_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/svgd_gmm.err.%j
#SBATCH -o /home/j_arenz/jobs/svgd_gmm.out.%j
#
#SBATCH -n 18     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-5, "svgd_gmm_10k_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-4, "svgd_gmm_10k_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-3, "svgd_gmm_10k_0.001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-2, "svgd_gmm_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-1, "svgd_gmm_10k_0.1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 1e-0, "svgd_gmm_10k_1");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-5, "svgd_gmm_10k_0.00002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-4, "svgd_gmm_10k_0.0002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-3, "svgd_gmm_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-2, "svgd_gmm_10k_0.02");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-1, "svgd_gmm_10k_0.2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 2e-0, "svgd_gmm_10k_2");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-5, "svgd_gmm_10k_0.00005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-4, "svgd_gmm_10k_0.0005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "svgd_gmm_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-2, "svgd_gmm_10k_0.05");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-1, "svgd_gmm_10k_0.5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from sampler.SVGD.targetGMM import *; sample(2000, 10000, 5e-0, "svgd_gmm_10k_5");' &


wait
