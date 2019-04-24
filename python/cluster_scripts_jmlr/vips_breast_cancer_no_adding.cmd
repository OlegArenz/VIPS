#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_bc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_bc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_bc.out.%j
#
#SBATCH -n 15     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/noAddingOrDeletion/default/1/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/noAddingOrDeletion/default/2/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/noAddingOrDeletion/default/3/", rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/1/1/", rate_of_dumps=10, num_initial=1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/1/2/", rate_of_dumps=10, num_initial=1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/1/3/", rate_of_dumps=10, num_initial=1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/2/1/", rate_of_dumps=10, num_initial=2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/2/2/", rate_of_dumps=10, num_initial=2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/2/3/", rate_of_dumps=10, num_initial=2);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/5/1/", rate_of_dumps=10, num_initial=5);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/5/2/", rate_of_dumps=10, num_initial=5);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/5/3/", rate_of_dumps=10, num_initial=5);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/10/1/", rate_of_dumps=10, num_initial=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/10/2/", rate_of_dumps=10, num_initial=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("noAddingOrDeletion", "VIPS_breast_cancer/noAddingOrDeletion/10/3/", rate_of_dumps=10, num_initial=10);'  &

wait
