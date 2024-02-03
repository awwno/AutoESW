#!/bin/bash

declare -A map

repeatChar() {
    local input="$1"
    local count="$2"
    printf -v myString '%*s' "$count"
    printf '%s\n' "${myString// /$input}"
}

elements=($(sed -n "6p" POSCAR))
numbers=($(sed -n "7p" POSCAR))
zvals=($(awk '/ZVAL/ {print $6}' POTCAR))

elstr=""
for i in ${!elements[@]};do
	elstr=$elstr$(repeatChar ${elements[i]} ${numbers[i]})
	map[${elements[i]}]=${zvals[i]}
done
charges=($(head -n-4 ACF.dat | awk 'NR>2{print $5}'))
len=${#charges[@]}
frac_charge=()
for (( i=0; i<$len; i++)); do
	echo "i=$i,  map[elstr] is ${map[${elstr:$i:1}]},   charge is ${charges[i]}
	but together
	$(echo "${map[${elstr:$i:1}]} - ${charges[i]}" | bc -l))"
	frac_charge+=($(echo "${map[${elstr:$i:1}]} - ${charges[i]}" | bc -l)) 	# ZVAL
done
echo ${frac_charge[@]} > frac_charge
echo "FRAC_CHARGE
-" > frac_charge_T
for e in $(cat frac_charge); do echo $e >> frac_charge_T;done

echo "ELEMENT
-" > ELEMENT
for (( i=0; i<${#elstr}; i++ )); do
	echo ${elstr:$i:1} >> ELEMENT
done
paste -d " " ACF.dat frac_charge_T ELEMENT> postACF.dat
rm frac_ch* ELEMENT
