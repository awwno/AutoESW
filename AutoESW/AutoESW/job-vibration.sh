#!/bin/bash

#input:		ENCUT, formal_charge, solvent_name
#input dir:	solvent/{POTCAR, POSCAR}
#output:	vasp_out

source utils-map

if [[ $# -eq 3 ]];then
	current_job=${charge2name[$2]}sol_vib
	upstream_job=${charge2name[$2]}sol
else
	current_job=${charge2name[$2]}_vib
	upstream_job=${charge2name[$2]}
fi
mkdir $current_job
cp -t $current_job $upstream_job/{POTCAR,CONTCAR,WAVECAR}
cd $current_job
cp CONTCAR POSCAR
make_kp.sh
make_incar.sh
#make_debugging_incar.sh

utils-uncomment.sh vibration INCAR
utils-comment.sh KPAR INCAR
utils-comment.sh NCORE INCAR
sed -i "s/SYSTEM =.*/SYSTEM = $current_job/" INCAR
sed -i "s/ENCUT =.*/ENCUT = $1/" INCAR
sed -i "s/IBRION = [[:digit:]]*/IBRION = 6/" INCAR
sed -i "s/NSW =.*/NSW = 1/" INCAR
sed -i "s/LWAVE = [[:alnum:]]*/LWAVE = F/" INCAR

utils-uncomment.sh electron INCAR
numberOfElectrons=$(($(cat ../numberOfElectrons)-$2))
sed -i "s/NELECT =.*/NELECT = $numberOfElectrons/" INCAR

if [[ $# -eq 3 ]];then
	utils-uncomment.sh solvation INCAR
	epsilon=$(grep "^$3" ~/scripts/dielectric_constants | grep -o "[[:digit:]]*\.[[:digit:]]*")
	sed -i "s/EB_K = [[:alnum:]]*/E_BK = $epsilon/" INCAR
fi

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam > vasp.out

cd .. 	# back to solvent_name/
