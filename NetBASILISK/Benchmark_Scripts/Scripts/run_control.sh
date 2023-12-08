#!/bin/bash

#****************************************#
#              run_control.sh
#          written by Jem Guhit
#             July 23, 2020

#          Runs the atlas environment 
#          setup and the benchmark 
#****************************************#
mkdir ${Dir}/run_control/
mkdir ${Dir}/timestamp/
mkdir ${Dir}/environment/
mkdir ${Dir}/parse/
Output=${Dir}/run_control/
Timepath=${Dir}/timestamp
export Timepath
Env=${Dir}/environment/
export Env
parse=${Dir}/parse/
export parse
currentdatenew=`date +"%Y%m%d_%H%M"`
export currentdatenew
#Transferring File
startTot=$(date +%s) 
echo "Starting Benchmark Program" 
for n in {1..1}; do #Number of times you want to repeat the benchmark
   echo "TEST $n"
   export n 
   #ATLAS SETUP
   ###########################################################
   echo "Reading atlas_setup.sh"
   #nohup
   bash $MAINDIR/Scripts/atlas_setup.sh 
   wait
   if [ $? -eq 0 ]; then
    echo ""
   else
    echo "FAIL. Error Code: $?"
   fi
   ###########################################################
   
   #Benchmark
   ###########################################################
   echo "Reading benchmark.sh"
   bash $MAINDIR/Scripts/benchmark.sh > ${Output}Run_Control_Test${n}.log 2>&1 
   if [ $? -eq 0 ]; then
    echo ""
   else
    echo "FAIL. Error Code: $?" 
   fi

   echo "Wait for xrootd to finish"
   wait

   if [ $? -eq 0 ]; then
    echo ""
   else
    echo "FAIL. Error Code: $?"
   fi
   ###########################################################
   
   #PARSING
   ########################################################### 
   echo "Running parse.sh"
   bash $MAINDIR/Scripts/parse.sh

echo "------------------------------------------------------------"
done
endTot=$(date +%s)
echo -e "start=$startTot\nend=$endTot" > ${Timepath}/Time.txt
secondsTot=$(echo "$endTot - $startTot" | bc)
echo 'Total Benchmark time is: ' $secondsTot 'seconds' 

#ENVIRONMENT
###########################################################
#Run Environment.sh
echo "Running environment.sh"
bash $MAINDIR/Scripts/environment.sh
wait

#CLEANUP
########################################################### 
#rm ${Timepath}/Time.txt 

#add it here or at main.sh 
echo "Benchmark Program Successful"
