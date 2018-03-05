#!/usr/bin/env bash


#SBATCH -c 8
#SBATCH --mem 4G
export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

spath=$p
outputDirectory=$o  #optional, comment out if not needed
colNames=$c
connectivityParams=''
#sets output directory for results
if [[ -v outputDirectory ]]
then
        connectivityParams+=" --output "$outputDirectory
else
        echo "variable 'outputDirectory' is set to defaults of classifier"
fi

#sets sample names for matrix
if [[ -v colNames ]]
then
        connectivityParams+=" --colNames "$colNames
else
        echo "variable 'colNames' is set to defaults of classifier"
fi

#run connectivity
filesToRun=$outputDirectory'matrixH/*'
echo $filesToRun
echo $connectivityParams > $outputDirectory'conn_params.txt'
for matrices in $filesToRun;
do
	echo "Building connectivity matrix for "$matrices

	python $spath/connectivity_matrix.py -input $matrices$connectivityParams
done

