#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_frisk
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/svgd_frisk.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/svgd_frisk.out.%j
#
#SBATCH -n 6    # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python -c 'from experiments.SVGD.frisk import *; sample(2000, 13000, 5e-3, "SVGD_FRISK/svgd_frisk_2000_13k_0.005_run6");' &


wait
