#!/bin/bash

# input: 	
# indir: 	POTCAR
# output: 	maxENMAX file
# makes a file w/enmax values, like: 400\n700\n4600

ENMAXs=($(grep ENMAX POTCAR | awk -F'[[:blank:]]*|;' '{print $4}'))
max=${ENMAXs[0]} # finds max
for n in "${ENMAXs[@]}"; do
	echo $n
	(( $(echo "$n > $max" | bc) == 1 )) &&
	  max=$n
done
echo "ECHO: maxENMAX = $max"
echo $max > maxENMAX
encut=$(echo "$max*1.3" | bc -l)
echo "ECHO: 1.3 * maxENMAX = $encut"
echo $encut >> maxENMAX
