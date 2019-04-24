#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgdgmm20
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/svgd_gmm_20.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/svgd_gmm_20.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run1/svgd_py3_gmm20_10k_0.1_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run2/svgd_py3_gmm20_10k_0.1_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run3/svgd_py3_gmm20_10k_0.1_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run4/svgd_py3_gmm20_10k_0.1_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run5/svgd_py3_gmm20_10k_0.1_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run6/svgd_py3_gmm20_10k_0.1_6");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run1/svgd_py3_gmm20_10k_0.5_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run2/svgd_py3_gmm20_10k_0.5_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run3/svgd_py3_gmm20_10k_0.5_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run4/svgd_py3_gmm20_10k_0.5_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run5/svgd_py3_gmm20_10k_0.5_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.targetGMM import *; sample(2000, 10000, 5e-3, "SVGD_GMM40_3/run6/svgd_py3_gmm20_10k_0.5_6");' &



wait
