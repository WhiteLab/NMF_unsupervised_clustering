#!/usr/bin/env bash

export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

cores=$cpu
mem=$mem
matrixFile=$m

outputDirectory=$o  #optional, comment out if not needed

#pick 'Euc' or 'KL'
metric='KL'

#the number of individual runs (i.e. number of times to perform NMF on the same input data)
numRuns=$runs

#pick 'connectivity' or 'k-means'
clusterType='connectivity'

#number of iterations for convergence (optional, comment out if not needed)
iterations=$iter

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
	metric='python '$spath'/NMF_Classifier_EucDist.py -input '$matrixFile
else
	metric='python '$spath'/NMF_Classifier_KL_divergence.py -input '$matrixFile
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
# added in sleep to keep jobs from running into each other
for i in $( seq 1 $numRuns);
do
	echo "Executing run number "$i
	sbatch -c $cores --mem=$mem -J "NMF_run_"$i -o "NMF_run_"$i".log" --export=m="$metric" $spath'/1a_run_NMF.sl';
	sleep 2
done



