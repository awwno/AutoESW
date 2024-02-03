#!/bin/bash -l

#input:		_
#input dir:	solvents
#output:	a TOTvsCUT.csv file in every solvent-folder.

#SBATCH --job-name=16convergences
#SBATCH --account=nn9264k
#SBATCH --nodes=12
#SBATCH --ntasks-per-node=32
#SBATCH --time=2:00:00

cd solvents/
for solvent in *; do
	echo "ECHO: $solvent"
        
	cd $solvent
	utils-setup_solvent_dir.sh
	init_encut=$(tail -1 maxENMAX)
	enmax=$(tail -2 maxENMAX | head -1)
	
	cd neu/
	relax.sh $init_encut "neu" &&
		sbatch job-convergence.sh $1 $2 $3 #no solvation
	cd ../..
done


