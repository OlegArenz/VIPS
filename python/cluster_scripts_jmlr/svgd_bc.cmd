#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_bc
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/svgd_bc.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/svgd_bc.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run10");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run11");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 2e-1, "SVGD_BC/0.2/svgd_bc_2000_13k_run12");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run9");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run10");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run11");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.breast_cancer import *; sample(2000, 13000, 5e-1, "SVGD_BC/0.5/svgd_bc_2000_13k_run12");' &





wait
