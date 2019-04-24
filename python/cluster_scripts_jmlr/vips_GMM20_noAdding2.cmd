#!/bin/bash
#SBATCH -A project00790
#SBATCH -J vips_gmm20_A2
#SBATCH --mail-type=ALL
# Bitte achten Sie auf vollständige Pfad-Angaben:
#SBATCH -e /work/scratch/j_arenz/jobs_jmlr/vipsgmm20.err.%j
#SBATCH -o /work/scratch/j_arenz/jobs_jmlr/vipsgmm20.out.%j
#
#SBATCH -n 18      # Anzahl der MPI-Prozesse
#SBATCH -c 1     # Anzahl der Rechenkerne (OpenMP-Threads) pro MPI-Prozess
#SBATCH --mem-per-cpu=4096   # Hauptspeicher pro Rechenkern in MByte
#SBATCH -t 2-00:00:00     # in Stunden, Minuten und Sekunden, oder '#SBATCH -t 10' - nur Minuten

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/1/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/2/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/3/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/4/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/5/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init50/6/", num_dimensions=20, num_initial=50, rate_of_dumps=10, num_outer=2000);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/1/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/2/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/3/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/4/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/5/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init75/6/", num_dimensions=20, num_initial=75, rate_of_dumps=10, num_outer=2000);'  &

srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/1/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/2/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/3/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/4/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/5/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
srun -N1 -n1 -c1 --time=2-00:00:00 --mem-per-cpu=4096 python3 -c 'from experiments.VIPS.Target_GMM import *; run_on_cluster("noAddingOrDeletion", "VIPS_GMM20/noAddingOrDeletion/init100/6/", num_dimensions=20, num_initial=100, rate_of_dumps=10, num_outer=2000);'  &
wait
