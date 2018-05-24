#!/bin/bash
#SBATCH -A project00490
#SBATCH -J ess_gmm
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/ess_gmm.err.%j
#SBATCH -o /home/j_arenz/jobs/ess_gmm.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=2048   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_1");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_2");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_3");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_4");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_5");' &
srun -N1 -n1 -c1 --time=1-00:00:00 --mem-per-cpu=2048 python3 -c 'from sampler.ESS.target_GMM import *; sample(10000000, "ess_gmm_10mio_6");' &



wait
