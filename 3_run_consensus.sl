#!/usr/bin/env bash


#SBATCH -c 8
#SBATCH --mem 4G
export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

spath=$p
outputDirectory=$o
connectivityParams=`cat $outputDirectory'conn_params.txt'`
suffix=$s

#run consensus matrix
echo "Running consensus matrix..."
python $spath/consensus_matrix.py -input $outputDirectory/connectivity_matrix/paths_to_connectivity_matrices_to_analyze.txt $connectivityParams --suffix $suffix