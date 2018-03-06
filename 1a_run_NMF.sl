#!/usr/bin/env bash

export PATH=/cephfs/users/mbrown/PIPELINES/TOOLS/miniconda3/bin:$PATH
source activate nmf_conda

metrics=$m
$metrics --run $run
