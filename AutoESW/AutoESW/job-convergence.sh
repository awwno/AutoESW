#!/bin/bash

# input: 	minENCUT step maxENCUT solvent_name
# indir: 	CONTCAR INCAR(relax) KPOINTS POTCAR WAVECAR
# output: 	TOTENvsENCUT.csv

module load VASP/6.4.2-intel-2022b-wHDF5-wvtst-wsol

if [ $# -eq 4 ]; then
	cd neusol
else
	cd neu
fi

CONTCARline7=($(awk 'NR==7 {print $0}' CONTCAR))
#$(sed -n "7p" CONTCAR > list); mapfile -t CONTCARline7 < list; rm list
numberOfAtoms=0
for el in ${CONTCARline7[@]}; do
        let numberOfAtoms+=$el
done
echo "ECHO numberOfAtoms: $numberOfAtoms"

vaspENCUT () {
        mkdir ENCUTs
        cp -t ENCUTs CONTCAR INCAR KPOINTS POTCAR WAVECAR
        cd ENCUTs
        mv CONTCAR POSCAR
	sed -i "s/SYSTEM =.*/SYSTEM = convergence/" INCAR
        sed -i "s/ENCUT =.*/ENCUT = $1/" INCAR	# $1 is ENCUT
	sed -i "s/NSW =.*/NSW = 0/" INCAR
	sed -i "s/LWAVE =.*/LWAVE = F/" INCAR
        echo "ECHO: ENMAX=$1"
	srun vasp_gam &&
	  TOTEN+=(
		  $(echo "$(grep -A 2 "FREE ENERGIE" OUTCAR |
	    	  	  tail -1 |
	          	  grep -o "\-\?[[:digit:]]*\.[[:digit:]]*") / $numberOfAtoms" |
		  bc -l)
		  ) &&
	  ENCUT+=($1) &&
	  echo "TOTEN: ${TOTEN[@]}"      # TOTEN is actually energy per atom!!!
        cd ..
	rm -r ENCUTs
}

i=0
ENCUT=($(seq $1 $2 $3)) 
TOTEN=()
vaspENCUT $ENCUT    			# first element of the array ENCUT
echo "ENCUT,atom_en,diff" > TOTENvsENCUT.csv
echo "${ENCUT[i]},${TOTEN[i]},$diff" >> TOTENvsENCUT.csv
for en in ${ENCUT[@]:1}; do
	i=$(($i+1))
	vaspENCUT $en

        lower=${TOTEN[$(($i-1))]} ; echo "lower: $lower"  # TOTEN is actually energy per atom!!!
        upper=${TOTEN[i]}         ; echo "upper: $upper"  # TOTEN is actually energy per atom!!!
        diff=$(echo "$upper - $lower" | bc -l)
        echo "ECHO: diff is $diff"
        echo "${ENCUT[i]},${TOTEN[i]},$diff" >> TOTENvsENCUT.csv
done

cd .. 		# back to solvent_name/

