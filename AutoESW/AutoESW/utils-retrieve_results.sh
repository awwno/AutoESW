#!/bin/bash

# doesnt work with pipes in expression

#input: 	path, expression, resultFile
#input dir: 	solvents
#output: 	resultFile

exp=$(sed -e 's/^"//' -e 's/"$//' <<< $2)
echo $exp
echo "RESULTS" > $3
startDir=$(pwd)
cd solvents/
for sol in *; do
	cd $sol/$1	# path
	echo "
	#############################
		$sol
	#############################" >> $startDir/$3
	$exp >> $startDir/$3
	cd $startDir/solvents/
done
