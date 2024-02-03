#!/bin/bash

#input:		name, time, file
#input dir:
#output:	sbatched file

sed "1i\#!/bin/bash\n\n#SBATCH --job-name=$1\n#SBATCH --account=nn9264k\n#SBATCH --nodes=2\n#SBATCH --ntasks-per-node=32\n#SBATCH --time=$2" ~/scripts/$3 > sb_$3
chmod u+x sb_$3
