#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_goodwin1_12_A1
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_goodwin1_12_A.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_goodwin1_12_A.out.%j
#
#SBATCH -n 15     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default/init_1/1/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default/init_1/2/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default/init_1/3/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default/init_1/4/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default/init_1/5/", rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInit/init_1/1/", rate_of_dumps=10, old_cov_init=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInit/init_1/2/", rate_of_dumps=10, old_cov_init=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInit/init_1/3/", rate_of_dumps=10, old_cov_init=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInit/init_1/4/", rate_of_dumps=10, old_cov_init=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInit/init_1/5/", rate_of_dumps=10, old_cov_init=True);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInitISO/init_1/1/", rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInitISO/init_1/2/", rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInitISO/init_1/3/", rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInitISO/init_1/4/", rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "GoodwinCovInit/default_oldCovInitISO/init_1/5/", rate_of_dumps=10, old_cov_init=True, isotropic=True);'  &
wait
