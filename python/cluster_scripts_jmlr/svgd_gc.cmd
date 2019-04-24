#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_gc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/svgd_gc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/svgd_gc.out.%j
#
#SBATCH -n 18     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run1/svgd_gc_2000_13k_0.005_run1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run2/svgd_gc_2000_13k_0.005_run2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run3/svgd_gc_2000_13k_0.005_run3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run4/svgd_gc_2000_13k_0.005_run4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run5/svgd_gc_2000_13k_0.005_run5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 5e-3, "SVGD2/GC/0.005/run6/svgd_gc_2000_13k_0.005_run6");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run1/svgd_gc_2000_13k_0.01_run1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run2/svgd_gc_2000_13k_0.01_run2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run3/svgd_gc_2000_13k_0.01_run3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run4/svgd_gc_2000_13k_0.01_run4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run5/svgd_gc_2000_13k_0.01_run5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.german_credit import *; sample(2000, 13000, 1e-2, "SVGD2/GC/0.01/run6/svgd_gc_2000_13k_0.01_run6");' &

wait
