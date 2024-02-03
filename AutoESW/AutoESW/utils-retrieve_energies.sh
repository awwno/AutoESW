#!/bin/bash

# input: 	method_name
# indir: 	solvents, results
# output: 	results/energies+method_name.csv

getSpinMultiplicity () {				# For example,
	source utils-map
	current_job=$(basename $(pwd))			# neu_vib
	name=${current_job%_*}				# neu
	formal_charge=${name2charge[$name]}		# 0
	unparedElectrons=${formal_charge#-}		# 0
	spinMultiplicity=$(($unparedElectrons + 1))	# 1
}

mkdir results
startDir=$(pwd)
if [ $1 == "HL" ];then
	echo "solvent,HOMO,LUMO,Gap,Thermal_correction" > results/energiesHL.out
	cd solvents/
	for sol in *; do
        	echo $sol
        	cd $sol

        	cd neu
        	H=$(vaspkit -task 911 | awk '/Eigenvalue of VBM/ {print $NF}')
        	L=$(vaspkit -task 911 | awk '/Eigenvalue of CBM/ {print $NF}')
        	gap=$(vaspkit -task 911 | awk '/Band Gap/ {print $NF}')
        	cd ..
		
		cd neu_vib &&
			getSpinMultiplicity &&
                        corr=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..

		echo "$sol,$H,$L,$gap,$corr" >> $startDir/results/energiesHL.out
        	cd $startDir/solvents/
	done
elif [ $1 == "DA" ];then
	echo "solvent,neu,neusol,an,ansol,cat,catsol" > results/energiesDA.out
	echo "solvent,neu,neusol,an,ansol,cat,catsol" > results/thermal_correctionsDA.out
	cd solvents/
	for sol in *;do
		echo $sol
        	cd $sol

        	neu=$(grep -A 2 "FREE ENERGIE" neu/OUTCAR | tail -1 | awk '{print $5}')
        	an=$(grep -A 2 "FREE ENERGIE" an/OUTCAR | tail -1 | awk '{print $5}')
        	cat=$(grep -A 2 "FREE ENERGIE" cat/OUTCAR | tail -1 | awk '{print $5}')
        	neusol=$(grep -A 2 "FREE ENERGIE" neusol/OUTCAR | tail -1 | awk '{print $5}')
        	ansol=$(grep -A 2 "FREE ENERGIE" ansol/OUTCAR | tail -1 | awk '{print $5}')
        	catsol=$(grep -A 2 "FREE ENERGIE" catsol/OUTCAR | tail -1 | awk '{print $5}')
        	echo "$sol,$neu,$neusol,$an,$ansol,$cat,$catsol">> $startDir/results/energiesDA.out
		
		pwd
		cd neu_vib && 
			getSpinMultiplicity &&
                        corr_neu=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" | 
			       vaspkit | 
			       awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') && 
			cd ..
		cd an_vib &&
                        getSpinMultiplicity &&
                        corr_an=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..
		cd cat_vib &&
                        getSpinMultiplicity &&
                        corr_cat=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..
		cd neusol_vib &&
                        getSpinMultiplicity &&
                        corr_neusol=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..
		cd ansol_vib &&
                        getSpinMultiplicity &&
                        corr_ansol=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..
		cd catsol_vib &&
                        getSpinMultiplicity &&
                        corr_catsol=$(echo -e "502\n298.15\n1\n$spinMultiplicity\n" |
                               vaspkit |
                               awk '/Thermal correction to G\(T\)/ {print $(NF-1)}') &&
                        cd ..
		echo "$sol,$corr_neu,$corr_neusol,$corr_an,$corr_ansol,$corr_cat,$corr_catsol"\
			>> $startDir/results/thermal_correctionsDA.out

        	cd $startDir/solvents/
	done
fi
