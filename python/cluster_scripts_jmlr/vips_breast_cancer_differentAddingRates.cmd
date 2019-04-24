#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_bc_A2
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_bc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_bc.out.%j
#
#SBATCH -n 21     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/1/1/", rate_of_dumps=10, adding_rate=1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/1/2/", rate_of_dumps=10, adding_rate=1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/1/3/", rate_of_dumps=10, adding_rate=1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/5/1/", rate_of_dumps=10, adding_rate=5);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/5/2/", rate_of_dumps=10, adding_rate=5);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/5/3/", rate_of_dumps=10, adding_rate=5);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/10/1/", rate_of_dumps=10, adding_rate=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/10/2/", rate_of_dumps=10, adding_rate=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/10/3/", rate_of_dumps=10, adding_rate=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/20/1/", rate_of_dumps=10, adding_rate=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/20/2/", rate_of_dumps=10, adding_rate=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/20/3/", rate_of_dumps=10, adding_rate=20);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/30/1/", rate_of_dumps=10, adding_rate=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/30/2/", rate_of_dumps=10, adding_rate=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/30/3/", rate_of_dumps=10, adding_rate=30);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/50/1/", rate_of_dumps=10, adding_rate=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/50/2/", rate_of_dumps=10, adding_rate=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/50/3/", rate_of_dumps=10, adding_rate=50);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/100/1/", rate_of_dumps=10, adding_rate=100);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/100/2/", rate_of_dumps=10, adding_rate=100);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("default", "VIPS_breast_cancer/addingRate/100/3/", rate_of_dumps=10, adding_rate=100);'  &
wait
