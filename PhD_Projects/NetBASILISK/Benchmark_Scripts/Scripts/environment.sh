#!/bin/bash

#****************************************#
#              environment.sh
#          written by Jem Guhit
#             October 14, 2020

#         Script responsible for  
#       running python scripts of 
#           monitoring tools 
#****************************************#

mkdir ${Env}/AGLT2
mkdir ${Env}/AGLT2_CHI
mkdir ${Env}/RBIN

AGLT2=${Env}/AGLT2
AGLT2CHI=${Env}/AGLT2_CHI
RBIN=${Env}/RBIN

export AGLT2
export AGLT2CHI
export RBIN

#python3 $MAINDIR/Scripts/AGLT2.py
#python3 $MAINDIR/Scripts/AGLT2_CHI.py
python3 $MAINDIR/Scripts/RBIN.py
wait
python3 $MAINDIR/Scripts/AGLT2_CHI.py
wait
python3 $MAINDIR/Scripts/AGLT2.py
