#!/bin/bash
#SBATCH -A project00490
#SBATCH -J vipsER_frisk
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/vipsE_frisk.err.%j
#SBATCH -o /home/j_arenz/jobs/vipsE_frisk.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/1");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/2");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/3");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/4");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/5");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/6");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/7");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/8");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/9");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/10");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/11");'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.frisk import *; run_on_cluster("explorative40", "VIPS_friskrng2/explorative40/12");'  &



wait
