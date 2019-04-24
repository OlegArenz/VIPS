#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_iono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/svgd_iono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/svgd_iono.out.%j
#
#SBATCH -n 16     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

### Run 1


srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run1/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run2/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run3/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run4/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run5/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run6/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run7/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run8/svgdiono_2000_10k_0.01");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run9/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run10/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run11/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run12/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run13/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run14/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run15/svgdiono_2000_10k_0.01");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(2000, 10000, 1e-2, "SVGD_IONO4_2000/0.01/run16/svgdiono_2000_10k_0.01");' &


wait
