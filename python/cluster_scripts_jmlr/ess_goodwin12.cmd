#!/bin/bash
#SBATCH -A project00790
#SBATCH -J ess_goodwin
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /home/j_arenz/jobs_jmlr/ess_goodwin.err.%j
#SBATCH -o /home/j_arenz/jobs_jmlr/ess_goodwin.out.%j
#
#SBATCH -n 10      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=1, path="ESS_GW12/ess_goodwin_2mio_1");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=2, path="ESS_GW12/ess_goodwin_2mio_2");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=3, path="ESS_GW12/ess_goodwin_2mio_3");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=4, path="ESS_GW12/ess_goodwin_2mio_4");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=5, path="ESS_GW12/ess_goodwin_2mio_5");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=6, path="ESS_GW12/ess_goodwin_2mio_6");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=7, path="ESS_GW12/ess_goodwin_2mio_7");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=8, path="ESS_GW12/ess_goodwin_2mio_8");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=9, path="ESS_GW12/ess_goodwin_2mio_9");' &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.ESS.goodwin12 import *; sample(2000000, seed=10, path="ESS_GW12/ess_goodwin_2mio_10");' &


wait
