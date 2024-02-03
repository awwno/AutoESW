#!/bin/bash

#input:
#input dir:	solvent/{POTCAR,POSCAR}
#output:	solvent dir

utils-find_electrons.sh ; utils-get_max_ENMAX.sh
make_kp.sh
mkdir neu neusol cat catsol an ansol neuvib catvib anvib
echo neu neusol cat catsol an ansol neuvib catvib anvib | xargs -n 1 cp POTCAR KPOINTS
cp POSCAR neu/
