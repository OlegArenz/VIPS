#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_goodwin
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/svgd_goodwin.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/svgd_goodwin.out.%j
#
#SBATCH -n 12     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run1/svgdgoodwin_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run2/svgdgoodwin_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run3/svgdgoodwin_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run4/svgdgoodwin_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run5/svgdgoodwin_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 2e-3, "SVGD_GOODWIN12_500/0.002/run6/svgdgoodwin_500_10k_0.002");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run1/svgdgoodwin_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run2/svgdgoodwin_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run3/svgdgoodwin_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run4/svgdgoodwin_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run5/svgdgoodwin_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.goodwin12 import *; sample(500, 10000, 5e-3, "SVGD_GOODWIN12_500/0.005/run6/svgdgoodwin_500_10k_0.005");' &


wait
