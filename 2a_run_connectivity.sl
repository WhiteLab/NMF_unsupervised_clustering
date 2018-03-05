#!/usr/bin/env bash

export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

spath=$p
matrices=$m
connectivityParams=$connParams

python $spath/connectivity_matrix.py -input $matrices$connectivityParams