#!/bin/bash

#input:         ENCUT, formal_charge, solvent_name
#input dir:     solvent/{POTCAR, POSCAR, neu/cat/an/{CONTCAR,WAVECAR}}
#output:        solvation.out

source utils-map
current_job=${charge2name[$2]}sol
upstream_job=${charge2name[$2]}
rm -r $current_job; mkdir $current_job
cp -t $current_job $upstream_job/{POTCAR,CONTCAR,WAVECAR}

cd $current_job
cp CONTCAR POSCAR
make_kp.sh
make_incar.sh
#make_debugging_incar.sh

epsilon=$(grep "^$3" ~/scripts/dielectric_constants | grep -o "[[:digit:]]*\.[[:digit:]]*")
sed -i "s/SYSTEM =.*/SYSTEM = $current_job/" INCAR
sed -i "s/ENCUT =.*/ENCUT = $1/" INCAR
sed -i "s/EDIFF =.*/EDIFF = 1e-5/" INCAR

utils-uncomment.sh solvation INCAR
sed -i "s/NSW =.*/NSW = 0/" INCAR
sed -i "s/EB_K = [[:alnum:]]*/E_BK = $epsilon/" INCAR
#sed -i "s/EPSILON = [[:alnum:]]*/EPSILON = $epsilon/"

utils-uncomment.sh electron INCAR
numberOfElectrons=$(($(cat ../numberOfElectrons)-$2))
sed -i "s/NELECT =.*/NELECT = $numberOfElectrons/" INCAR

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam > vasp.out

cd ..   # back to solvent_name/
