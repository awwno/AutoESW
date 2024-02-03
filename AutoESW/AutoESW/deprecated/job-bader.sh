#!/bin/bash

# input:	formal_charge
# indir: 	solvent_name/{}
# output:	ACF.dat

source utils-map
current_job=${charge2name[$1]}_bader
upstream_job=${charge2name[$1]}
mkdir $current_job
cp $upstream_job/{CONTCAR,KPOINTS,POTCAR,INCAR} current_job
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
rm CHG*
cd ..
