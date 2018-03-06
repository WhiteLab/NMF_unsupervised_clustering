#!/usr/bin/env bash

export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

cores=$cpu
mem=$mem

spath=$p
outputDirectory=$o
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
n=1
echo $connectivityParams > $outputDirectory'conn_params.txt'
for matrices in $filesToRun;
do
	echo "Building connectivity matrix for "$matrices
    sbatch -c $cores --mem=$mem -J "connectivity_run_"$n -o "connectivity_run_"$n".log" --export=m="$matrices",connParams="$connectivityParams",p="$spath" $spath'/2a_run_connectivity.sl';
    ((n++))
done

