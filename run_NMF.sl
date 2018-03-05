#!/usr/bin/env bash

#SBATCH -c 8
#SBATCH --mem 4G
export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda
matrixFile=$m

outputDirectory=$o  #optional, comment out if not needed

#pick 'Euc' or 'KL'
metric='KL'

#the number of individual runs (i.e. number of times to perform NMF on the same input data)
numRuns=10

#pick 'connectivity' or 'k-means'
clusterType='connectivity'

#number of iterations for convergence (optional, comment out if not needed)
iterations=10

#number of desired clusters (optional, comment out if not needed)
clusters=3

#full path to file of sample names in order of matrix, one name per line (optional, comment out if not needed)
colNames=$c

#full path to file of feature/attribute names in order of matrix, one name per line (optional, comment out if not needed)
rowNames=$r
spath=$p
#optional, uncomment if user does not want data visualizations produced
#noPlotOut=False

#-------------------------------Running NMF, finished with user variable inputs---------------------------------

#determine which classifier to use
if [ $metric = "Euc" ]
then
	metric='python '$p'/NMF_Classifier_EucDist.py -input '$matrixFile
else
	metric='python '$p'/NMF_Classifier_KL_divergence.py -input '$matrixFile
fi


#sets desired cluster number
if [[ -v clusters ]]
then
	metric+=" -kclusters "$clusters
else
	echo "variable 'clusters' is set to defaults of classifier"
fi


#sets desired number of iterations to perform per run
if [[ -v iterations ]]
then
	metric+=" -iterations "$iterations
else
	echo "variable 'iterations' is set to defaults of classifier"
fi


#sets sample names for matrix
if [[ -v colNames ]]
then
	metric+=" --colNames "$colNames
else
	echo "variable 'colNames' is set to defaults of classifier"
fi


#sets attribute/feature names for matrix
if [[ -v rowNames ]]
then
	metric+=" --rowNames "$rowNames
else
	echo "variable 'rowNames' is set to defaults of classifier"
fi


#sets output directory for results
if [[ -v outputDirectory ]]
then
	metric+=" --output "$outputDirectory
else
	echo "variable 'outputDirectory' is set to defaults of classifier"
fi

#make visualizations or not
if [[ -v noPlotOut ]]
then
	echo "user has opted to disable visualization output"
        metric+=" --noPlotOut"
else
	echo "visualizations will be made for data"
fi


#run NMF
echo $metric
for i in $( seq 1 $numRuns);
do
	echo "Executing run number "$i
	$metric;
done







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
for matrices in $filesToRun;
do
	echo "Building connectivity matrix for "$matrices
	
	python $p/connectivity_matrix.py -input $matrices$connectivityParams
done



#run consensus matrix
echo "Running consensus matrix..."
python $p/consensus_matrix.py -input $outputDirectory/connectivity_matrix/paths_to_connectivity_matrices_to_analyze.txt$connectivityParams

