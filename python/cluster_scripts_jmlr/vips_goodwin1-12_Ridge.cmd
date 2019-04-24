#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_goodwin_ridge
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_goodwin_ridge.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_goodwin_ridge.out.%j
#
#SBATCH -n 30     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/default/1/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/defual/2/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/defaul/3/", rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/14/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/14/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/14/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-14);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/13/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/13/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/13/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-13);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/12/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/12/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/12/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-12);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/11/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/11/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/11/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-11);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/10/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/10/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/10/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/9/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/9/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/9/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-9);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/8/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/8/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/8/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-8);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/7/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/7/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/7/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-7);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/6/1/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/6/2/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10Ridge/6/3/", rate_of_dumps=10, adapt_ridge=False, ridge_coeff=1e-6);'  &

wait
