#!/bin/bash -l

#input:         min step max
#input dir:     solvents
#output:        a TOTvsCUT.csv file in every solvent-folder.

#SBATCH --job-name=16solConv
#SBATCH --account=nn9264k
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=0:30:00
#SBATCH --exclusive

cd solvents/
#for solvent in *; do
for solvent in DEE PS; do
        echo "ECHO: $solvent"

        cd $solvent/neusol/
	cp ../neu/re-relax/{CONTCAR,WAVECAR} .
	cp CONTCAR POSCAR
	
	sbatch exec_convergence.sh $1 $2 $3 $solvent

        cd ../..
done
