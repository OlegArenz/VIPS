#!/bin/bash
#SBATCH -A project00490
#SBATCH -J VIPS_gcER
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs/VIPS_gc.err.%j
#SBATCH -o /home/j_arenz/jobs/VIPS_gc.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1000   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/1");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/2");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/3");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/4");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/5");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/6");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/7");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/8");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/9");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/10");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/11");'  &
srun -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.VIPS.german_credit import *; run_on_cluster("explorative", "VIPS_german_credit_rng2/explorative/12");'  &



wait
