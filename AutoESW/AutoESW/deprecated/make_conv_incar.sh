#!/bin/bash

echo "SYSTEM = conv
PREC = Normal
ALGO = Fast
NCORE = 16

ISMEAR = 0
SIGMA = 0.05
NELM = 300
EDIFF = 1e-7
ENCUT = 500

EDIFFG = 1e-4
IBRION = 2
NSW = 0
!POTIM = 0.5 !default

LWAVE = F
LCHARG = F

!LSOL = T !solvation
!EB_K = 20 !solvation
!!EPSILON = 20 !solvation

!!IBRION = 8 !vibration
!NFREE = 2 !vibration

!NELECT = 40 !electron d/a" > INCAR


if [ $# -eq 1 ]; then
	uncomment.sh solvation INCAR
	epsilon=$(grep "^$1" ~/scripts/dielectric_constants | grep -o "[[:digit:]]*\.[[:digit:]]*")
	sed -i "s/EB_K = [[:alnum:]]*/EB_K = $epsilon/" INCAR
	sed -i "s/EPSILON = [[:alnum:]]*/EPSILON = $epsilon/" INCAR
	echo "ECHO: made solvation INCAR for $1 with EB_K = $epsilon for convergence test"
else
	echo "EHCO: made vacuum INCAR for convergence test"
fi
