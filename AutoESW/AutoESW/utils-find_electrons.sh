#!/bin/bash

sev=($(awk 'NR==7 {print}' POSCAR))
zv=($(awk '/ZVAL/ { split($6, subfield, "."); print subfield[1] }' POTCAR))

#egrep -o "ZVAL[[:space:]]*=[[:space:]]*[[:digit:]]" POTCAR|egrep -o "[[:digit:]]" > array_file
#mapfile -t zv < array_file; rm array_file
#sed -n "7p" POSCAR | egrep -o "[[:digit:]]*" > list
#mapfile -t sev < list; rm list
echo "zv: ${zv[@]}"
echo "sev: ${sev[@]}"

numberOfElec=0
for ((i=0 ; i<${#zv[@]} ; i++)); do
	z=${zv[$i]}
	s=${sev[$i]}
	product=$(($z*$s))
	let numberOfElec+=$product
done
echo $numberOfElec > numberOfElectrons
