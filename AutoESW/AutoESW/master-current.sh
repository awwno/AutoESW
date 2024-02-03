#!/bin/bash

#input:		1-6 scripts
#input dir:	
#output:	

#SBATCH --job-name=current
#SBATCH --account=nn9264k
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --time=10:00:00

if [ $# -eq 1 ];then
        expr1=$(echo $1 | tr -d '"')
        $expr1
elif [ $# -eq 2 ];then
        expr1=$(echo $1 | tr -d '"')
        expr2=$(echo $2 | tr -d '"')
        $expr1 && $expr2
elif [ $# -eq 3 ];then
        expr1=$(echo $1 | tr -d '"')
        expr2=$(echo $2 | tr -d '"')
        expr3=$(echo $3 | tr -d '"')
        $expr1 && $expr2 && $expr3
elif [ $# -eq 4 ];then
        expr1=$(echo $1 | tr -d '"')
        expr2=$(echo $2 | tr -d '"')
        expr3=$(echo $3 | tr -d '"')
        expr4=$(echo $4 | tr -d '"')
        $expr1 && $expr2 && $expr3 && $expr4
elif [ $# -eq 5 ];then
        expr1=$(echo $1 | tr -d '"')
        expr2=$(echo $2 | tr -d '"')
        expr3=$(echo $3 | tr -d '"')
        expr4=$(echo $4 | tr -d '"')
        expr5=$(echo $5 | tr -d '"')
        $expr1 && $expr2 && $expr3 && $expr4 && $expr5
elif [ $# -eq 6 ];then
        expr1=$(echo $1 | tr -d '"')
        expr2=$(echo $2 | tr -d '"')
        expr3=$(echo $3 | tr -d '"')
        expr4=$(echo $4 | tr -d '"')
        expr5=$(echo $5 | tr -d '"')
        expr6=$(echo $6 | tr -d '"')
        $expr1 && $expr2 && $expr3 && $expr4 && $expr5 && $expr6

else
        echo "ECHO: forgot the scripts or too many!"
fi
