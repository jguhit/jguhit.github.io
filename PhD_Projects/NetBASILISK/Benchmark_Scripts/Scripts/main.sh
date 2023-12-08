#!/bin/bash

#****************************************#
#              main.sh
#          written by Jem Guhit
#             July 23, 2020

#    Runs run_control.sh in background
#****************************************#
currentdate=`date +"%Y%m%d_%H%M"`
export currentdate
MAINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"
export MAINDIR
mkdir $MAINDIR/Output/Output_${currentdate}
Dir=$MAINDIR/Output/Output_${currentdate}
export Dir
mkdir ${Dir}/main
Output=${Dir}/main

bash $MAINDIR/Scripts/run_control.sh > ${Output}/Main_Benchmark.log 2>&1

wait

echo 'Running Pre-processing script'

#Add the preprocessing script here 
mkdir ${Dir}/preprocessing
PP=${Dir}/preprocessing
export PP

mkdir ${Dir}/humio
Humio=${Dir}/humio
export Humio

bash $MAINDIR/Scripts/preprocessing.sh > ${PP}/preprocessing.log 2>&1
