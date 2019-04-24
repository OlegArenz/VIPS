#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_bc_A1
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_bc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_bc.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/1/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/2/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/3/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/4/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/5/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/6/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/7/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/8/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/9/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/10/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/11/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.breast_cancer import *; run_on_cluster("oldSampleReusage", "VIPS_breast_cancer/oldSampleReusage/12/", rate_of_dumps=10);'  &

wait
