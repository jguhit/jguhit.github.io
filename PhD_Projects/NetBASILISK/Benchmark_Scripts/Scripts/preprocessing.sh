#!/bin/bash

#****************************************#
#              preprocessing.sh
#          written by Jem Guhit
#             March 7, 2021

#         Script responsible for  
#       running python scripts of 
#           monitoring tools 
#****************************************#

mkdir ${PP}/AGLT2
mkdir ${PP}/AGLT2/dCache
mkdir ${PP}/AGLT2/Metrics
mkdir ${PP}/AGLT2_CHI
mkdir ${PP}/AGLT2_CHI/dCache 
mkdir ${PP}/AGLT2_CHI/Metrics
mkdir ${PP}/RBIN
mkdir ${PP}/RBIN/dCache 
mkdir ${PP}/RBIN/Metrics 

export PP_AGLT2=${PP}/AGLT2
export PP_AGLT2_dCache=${PP}/AGLT2/dCache
export PP_AGLT2_Metrics=${PP}/AGLT2/Metrics
export PP_AGLT2CHI=${PP}/AGLT2_CHI
export PP_AGLT2CHI_dCache=${PP}/AGLT2_CHI/dCache
export PP_AGLT2CHI_Metrics=${PP}/AGLT2_CHI/Metrics
export PP_RBIN=${PP}/RBIN
export PP_RBIN_dCache=${PP}/RBIN/dCache
export PP_RBIN_Metrics=${PP}/RBIN/Metrics

export RBINdir=${Dir}/environment/RBIN
export AGLT2CHIdir=${Dir}/environment/AGLT2_CHI
export AGLT2dir=${Dir}/environment/AGLT2

export parsedir=${Dir}/parse

export timedir=${Dir}/timestamp


echo "Starting preprocessing script"
echo "============================="

echo "========RBIN========"
python ${MAINDIR}/Scripts/PP_RBIN.py > ${PP}/PP_RBIN.log 2>&1
wait

echo "======AGLT2CHI======"
python ${MAINDIR}/Scripts/PP_AGLT2CHI.py > ${PP}/PP_AGLT2CHI.log 2>&1
wait

echo "======AGLT2dCache======"
python ${MAINDIR}/Scripts/PP_AGLT2_dCache.py > ${PP}/PP_AGLT2_dCache.log 2>&1
wait 

echo "======AGLT2Metrics======"
python ${MAINDIR}/Scripts/PP_AGLT2_Metrics.py > ${PP}/PP_AGLT2_Metrics.log 2>&1
wait

echo "Sucessful!! Preprocessing Script DONE"


echo "Sending pre-processed files to Humio"
python $MAINDIR/Scripts/post_humio.py > ${Humio}/humio.log 2>&1
wait
echo "Submit to Humio Successful!"

#python $MAINDIR/Scripts/PP_funcs.py > ${PP}/PP_funcs.log 2>&1
#python3 ${MAINDIR}/Scripts/PP_RBIN_func.py
#python3 ${MAINDIR}/Scripts/PP_AGLT2CHI_func.py
#python3 ${MAINDIR}/Scripts/PP_AGLT2_func.py
