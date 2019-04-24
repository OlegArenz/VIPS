#!/bin/bash
#SBATCH -A project00790
#SBATCH -J svgd_iono
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs/svgd_iono.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs/svgd_iono.out.%j
#
#SBATCH -n 9     # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=1024   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

### Run 1
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 1e-4, "SVGD_IONO4/0.0001/run1/svgdiono_500_10k_0.0001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 1e-3, "SVGD_IONO4/0.001/run1/svgdiono_500_10k_0.001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 1e-2, "SVGD_IONO4/0.01/run1/svgdiono_500_10k_0.01");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 2e-4, "SVGD_IONO4/0.0002/run1/svgdiono_500_10k_0.0002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 2e-3, "SVGD_IONO4/0.002/run1/svgdiono_500_10k_0.002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 2e-2, "SVGD_IONO4/0.02/run1/svgdiono_500_10k_0.02");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 5e-4, "SVGD_IONO4/0.0005/run1/svgdiono_500_10k_0.0005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 5e-3, "SVGD_IONO4/0.005/run1/svgdiono_500_10k_0.005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python3 -c 'from experiments.SVGD.iono2 import *; sample(500, 10000, 5e-2, "SVGD_IONO4/0.05/run1/svgdiono_500_10k_0.05");' &


wait
