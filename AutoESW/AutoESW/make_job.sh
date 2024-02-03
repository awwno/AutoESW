#!/bin/bash

#input: 	job_name
#in dir:	
#output:	job.sh

echo "#!/bin/bash -l
#SBATCH --job-name=$1
#SBATCH --account=nn9264k
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --time=2:00:00

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam >> vasp.out


" > job.sh
