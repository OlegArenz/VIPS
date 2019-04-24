#!/bin/bash
#SBATCH -A project00730
#SBATCH -J vips_goodwin_neff
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vips_goodwin_neff.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vips_goodwin_neff.out.%j
#
#SBATCH -n 15     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/10/1/", rate_of_dumps=10, des_num_eff=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/10/2/", rate_of_dumps=10, des_num_eff=10);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/10/3/", rate_of_dumps=10, des_num_eff=10);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/20/1/", rate_of_dumps=10, des_num_eff=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/20/2/", rate_of_dumps=10, des_num_eff=20);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/20/3/", rate_of_dumps=10, des_num_eff=20);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/30/1/", rate_of_dumps=10, des_num_eff=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/30/2/", rate_of_dumps=10, des_num_eff=30);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/30/3/", rate_of_dumps=10, des_num_eff=30);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/40/1/", rate_of_dumps=10, des_num_eff=40);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/40/2/", rate_of_dumps=10, des_num_eff=40);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/40/3/", rate_of_dumps=10, des_num_eff=40);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/50/1/", rate_of_dumps=10, des_num_eff=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/50/2/", rate_of_dumps=10, des_num_eff=50);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Goodwin_Oscillator_1_12_2 import *; run_on_cluster("default", "VIPS_Goodwin10DesNumEff/50/3/", rate_of_dumps=10, des_num_eff=50);'  &

wait
