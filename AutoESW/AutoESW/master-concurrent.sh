#!/bin/bash
#SBATCH --job-name=concurrent
#SBATCH --account=nn9264k
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=0:10:00

# input:
# indir: 	solvents
# output:	

cd solvents/
for solvent in *; do
        cd $solvent
	rm slurm*
	
	# Vacuum convergence test
	#utils-get_max_ENMAX.sh
	#ENCUT=$(tail -1 maxENMAX)
	#sbatch master-current.sh \
	#  "job-relax.sh $ENCUT 0" \
	#  "job-convergence.sh 300 50 900"

	# Solvation convergence test
	#converged_ENCUT=530
	#sbatch master-current.sh \
	#  "job-relax.sh $converged_ENCUT 0" \
	#  "job-solvation.sh $converged_ENCUT 0 $solvent" \
	#  "job-convergence.sh 300 50 1100 $solvent"	

	# HL method
	#ENCUT_vacuum=530
   	#formal_charge=0
    	#sbatch master-current.sh \
      	#  "job-relax.sh $ENCUT_vacuum $formal_charge" \
      	#  "job-vibration.sh $ENCUT_vacuum $formal_charge"
	
	# DA method or Na method
	ENCUT_vacuum=530
    	ENCUT_solvation=750
	Na=1 			# 0 or 1 depending on without or with Na, respectively.
	fc_lower=$((-1+$Na))
	fc_higher=$((2+$Na))
	for (( formal_charge=$fc_lower;formal_charge<$fc_higher;formal_charge++ ));do
         	sbatch master-current.sh \
          	  "job-relax.sh $ENCUT_vacuum $formal_charge" \
          	  "job-vibration.sh $ENCUT_vacuum $formal_charge" \
          	  "job-solvation.sh $ENCUT_solvation $formal_charge $solvent" \
          	  "job-vibration.sh $ENCUT_solvation $formal_charge $solvent"
    	done

	# Post-processing: bader charge and density of states
	#formal_charge=$Na
        #sbatch master-current.sh \
        #  "job-post_processing.sh $formal_charge"
	
	cd ..
done
