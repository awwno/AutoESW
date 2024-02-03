#!/bin/bash

#input: 	path, resultFile
#input dir: 	solvents
#output: 	resultFile

echo "solvent,HOMO,LUMO,Gap,HOMOsol,LUMOsol,Gapsol,neu,neusol,an,ansol,cat,catsol" > energies.out
startDir=$(pwd)
cd solvents/
for sol in *; do
	echo $sol
	cd $sol

	cd neu
	H=$(vaspkit -task 911 | awk '/Eigenvalue of VBM/ {print $NF}')
	L=$(vaspkit -task 911 | awk '/Eigenvalue of CBM/ {print $NF}')
	gap=$(vaspkit -task 911 | awk '/Band Gap/ {print $NF}')
	cd ..

	cd neusol
	Hsol=$(vaspkit -task 911 | awk '/Eigenvalue of VBM/ {print $NF}')
	Lsol=$(vaspkit -task 911 | awk '/Eigenvalue of CBM/ {print $NF}')
	gapsol=$(vaspkit -task 911 | awk '/Band Gap/ {print $NF}')
	cd ..

	neu=$(grep -A 2 "FREE ENERGIE" neu/OUTCAR | tail -1 | awk '{print $5}')
	an=$(grep -A 2 "FREE ENERGIE" an/OUTCAR | tail -1 | awk '{print $5}')
	cat=$(grep -A 2 "FREE ENERGIE" cat/OUTCAR | tail -1 | awk '{print $5}')
	neusol=$(grep -A 2 "FREE ENERGIE" neusol/OUTCAR | tail -1 | awk '{print $5}')
	ansol=$(grep -A 2 "FREE ENERGIE" ansol/OUTCAR | tail -1 | awk '{print $5}')
	catsol=$(grep -A 2 "FREE ENERGIE" catsol/OUTCAR | tail -1 | awk '{print $5}')
	echo "$sol,$H,$L,$gap,$Hsol,$Lsol,$gapsol,$neu,$neusol,$an,$ansol,$cat,$catsol">> $startDir/energies.out
	cd $startDir/solvents/
done
