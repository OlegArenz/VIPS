#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgdgmm40
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/svgd_gmm_40.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/svgd_gmm_40.out.%j
#
#SBATCH -n 5     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM40 import *; sample(2000, 10000, 5e-3, "SVGD_GMM40/svgd_py3_gmm40_10k_0.005_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM40 import *; sample(2000, 10000, 5e-3, "SVGD_GMM40/svgd_py3_gmm40_10k_0.01_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM40 import *; sample(2000, 10000, 5e-3, "SVGD_GMM40/svgd_py3_gmm40_10k_0.05_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM40 import *; sample(2000, 10000, 5e-3, "SVGD_GMM40/svgd_py3_gmm40_10k_0.1_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM40 import *; sample(2000, 10000, 5e-3, "SVGD_GMM40/svgd_py3_gmm40_10k_0.5_1");' &



wait
