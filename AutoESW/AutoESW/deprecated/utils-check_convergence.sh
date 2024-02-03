#!/bin/bash

# Doesnt work because the * isnt expanded.

# input: 	species_name
# indir: 	any parent folder of the solvents
# output: 	prints matched followed by unmatched solvents

dir=$(pwd)
echo "Molecules that converged:"
$(grep "reached required accuracy" $dir/*/$1/vasp.out)
echo "
Molecules that did not converge:"
$(grep -rL "reached required accuracy" $dir/*/$1/vasp.out)
