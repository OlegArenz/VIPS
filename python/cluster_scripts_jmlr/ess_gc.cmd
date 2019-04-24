#!/bin/bash
#SBATCH -A project00790
#SBATCH -J ess_gc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/ess_gc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/ess_gc.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.german_credit import *; sample(10000000, "ess_gc_10mio_6");' &



wait
