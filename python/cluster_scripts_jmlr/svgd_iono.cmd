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
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 1e-6, "SVGD_IONO3/0.000001/run1/svgdiono_500_10k_0.000001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 1e-5, "SVGD_IONO3/0.00001/run1/svgdiono_500_10k_0.00001");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 1e-4, "SVGD_IONO3/0.0001/run1/svgdiono_500_10k_0.0001");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 2e-6, "SVGD_IONO3/0.000002/run1/svgdiono_500_10k_0.000002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 2e-5, "SVGD_IONO3/0.00002/run1/svgdiono_500_10k_0.00002");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 2e-4, "SVGD_IONO3/0.0002/run1/svgdiono_500_10k_0.0002");' &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 5e-6, "SVGD_IONO3/0.000005/run1/svgdiono_500_10k_0.000005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 5e-5, "SVGD_IONO3/0.00005/run1/svgdiono_500_10k_0.00005");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=1024 python -c 'from experiments.SVGD.iono import *; sample(500, 10000, 5e-4, "SVGD_IONO3/0.0005/run1/svgdiono_500_10k_0.0005");' &


wait
