#!/bin/sh

if [ $2 = "INCAR" ]; then
	sed -i "/$1/s/^!//" INCAR
elif [ $2 = "job.sh" ]; then
	sed -i "/$1/s/^#//" job.sh
else
	echo "invalid file"
fi
