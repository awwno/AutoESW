#!/bin/bash

#input:		convENCUT
#input dir:	solvents
#output:

#SBATCH --job-name=tests
#SBATCH --account=nn9264k
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=0:30:00
#SBATCH --qos=short

cd solvents/
for solvent in *; do
	cd $solvent/neu/
	mkdir re-relax/
	cp POTCAR CONTCAR KPOINTS re-relax/
	cd re-relax/
	mv CONTCAR POSCAR
	utils_sb_relax.sh
	sbatch sb_relax.sh $1 neu 	# makes INCAR
	cd ../../..
done
