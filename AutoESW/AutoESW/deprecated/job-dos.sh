#!/bin/bash

# input:	
# indir:	solvent_name/bader_neu
# output:	DOSCAR

rm -r dos
mkdir dos
cp bader_neu/{INCAR,CHGCAR,CONTCAR,KPOINTS,POTCAR} dos
cd dos
cp CONTCAR POSCAR
utils-uncomment.sh density INCAR

sed -i "s/LCHARG =.*/LCHARG = F/" INCAR

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol
srun vasp_gam > vasp.out

vaspkit -task 111

cd ..
