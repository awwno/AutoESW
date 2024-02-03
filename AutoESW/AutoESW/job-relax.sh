#!/bin/bash

#input:		ENCUT, formal_charge
#input dir:	solvent/{POTCAR, POSCAR}
#output:	vasp_out

utils-find_electrons.sh
source utils-map
current_job=${charge2name[$2]}
rm -r $current_job; mkdir $current_job
cp -t $current_job POTCAR POSCAR

cd $current_job
make_kp.sh
make_incar.sh
#make_debugging_incar.sh
sed -i "s/SYSTEM =.*/SYSTEM = $current_job/" INCAR
sed -i "s/ENCUT =.*/ENCUT = $1/" INCAR


utils-uncomment.sh electron INCAR
numberOfElectrons=$(($(cat ../numberOfElectrons)-$2))
sed -i "s/NELECT =.*/NELECT = $numberOfElectrons/" INCAR

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam > vasp.out

lastStep=$(grep "F= " vasp.out | tail -1| awk '{print $1}')
NSW=$(awk '/NSW[[:space:]]*=/ {print $3;exit}' OUTCAR)
if [[ $lastStep -eq $NSW ]];then
	cp POSCAR POSCAR.old ; cp CONTCAR POSCAR
	utils-uncomment.sh POTIM INCAR
	sed -i "s/SYSTEM =.*/SYSTEM = continuation/" INCAR
	sed -i "s/IBRION =.*/IBRION = 1/" INCAR
	oldPOTIM=$(awk '/POTIM[[:space:]]*=/ {print $3;exit}' OUTCAR)
	trialstep=$(grep "trialstep = " vasp.out | tail -1 |  awk '{print $NF}' | rev | cut -c2- | rev | sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' | bc -l)
	POTIM=$(echo "$trialstep * $oldPOTIM" | bc -l)
	sed -i "s/POTIM =.*/POTIM = $POTIM/" INCAR
	
	echo "
	IONIC CONVERGENCE NOT REACHED

	CONTINUATION JOB" >> vasp.out
	srun vasp_gam >> vasp.out
fi

cd .. 	# back to solvent_name/
