#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_goodwin_Kls
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_goodwin1_oldR.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_goodwin1_oldR.out.%j
#
#SBATCH -n 27     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten


srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/default/1/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/default/2/", rate_of_dumps=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/default/3/", rate_of_dumps=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/13/1/", rate_of_dumps=10, fixedKL=1e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/13/2/", rate_of_dumps=10, fixedKL=1e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/13/3/", rate_of_dumps=10, fixedKL=1e-3);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/53/1/", rate_of_dumps=10, fixedKL=5e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/53/2/", rate_of_dumps=10, fixedKL=5e-3);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/53/3/", rate_of_dumps=10, fixedKL=5e-3);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/12/1/", rate_of_dumps=10, fixedKL=1e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/12/2/", rate_of_dumps=10, fixedKL=1e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/12/3/", rate_of_dumps=10, fixedKL=1e-2);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/52/1/", rate_of_dumps=10, fixedKL=5e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/52/2/", rate_of_dumps=10, fixedKL=5e-2);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/52/3/", rate_of_dumps=10, fixedKL=5e-2);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/11/1/", rate_of_dumps=10, fixedKL=1e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/11/2/", rate_of_dumps=10, fixedKL=1e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/11/3/", rate_of_dumps=10, fixedKL=1e-1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/51/1/", rate_of_dumps=10, fixedKL=5e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/51/2/", rate_of_dumps=10, fixedKL=5e-1);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/51/3/", rate_of_dumps=10, fixedKL=5e-1);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/10/1/", rate_of_dumps=10, fixedKL=1e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/10/2/", rate_of_dumps=10, fixedKL=1e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/10/3/", rate_of_dumps=10, fixedKL=1e-0);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/50/1/", rate_of_dumps=10, fixedKL=5e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/50/2/", rate_of_dumps=10, fixedKL=5e-0);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_GoodwinKLs/kls/50/3/", rate_of_dumps=10, fixedKL=5e-0);'  &

wait
