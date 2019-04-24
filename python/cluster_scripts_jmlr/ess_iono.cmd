#!/bin/bash
#SBATCH -A project00790
#SBATCH -J essIono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/essIono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/essIono.out.%j
#
#SBATCH -n 6      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1000 python3 -c 'from experiments.ESS.iono import *; sample(300000, "essIono_300k_6");' &

wait
