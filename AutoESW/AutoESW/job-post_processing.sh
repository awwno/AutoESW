#!/bin/bash

# input:	formal_charge dos
# indir: 	solvent_name/(neu,an,cat)
# output:	ACF.dat, postACF.dat, CHARGE.vasp, TDOS.dat

source utils-map
current_job=${charge2name[$1]}_post
upstream_job=${charge2name[$1]}
mkdir $current_job
cp -t $current_job $upstream_job/{CONTCAR,KPOINTS,POTCAR,INCAR}
cd $current_job
cp CONTCAR POSCAR

sed -i "s/SYSTEM =.*/SYSTEM = $current_job/" INCAR
sed -i "s/LCHARG =.*/LCHARG = T/" INCAR
sed -i "s/LWAVE =.*/LWAVE = F/" INCAR
sed -i "s/IBRION =.*/IBRION = -1/" INCAR
sed -i "s/NSW =.*/NSW = 0/" INCAR

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam > vasp.out

bader CHGCAR
utils-get_charge.sh 	# generates postACF.dat with charge and element columns appended to ACF.dat
vaspkit -task 311 	# generates CHARGE.vasp

if [ $2 == "dos" ];then
	utils-uncomment.sh density INCAR
	utils-comment.sh ISPIN INCAR
	sed -i "s/LCHARG =.*/LCHARG = F/" INCAR
	srun vasp_gam >> vasp.out
	vaspkit -task 111
fi

rm CHG*
cd ..
