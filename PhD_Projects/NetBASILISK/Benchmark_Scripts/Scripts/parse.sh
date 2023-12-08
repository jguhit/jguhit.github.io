#!/bin/bash

#****************************************#
#              parse.sh
#          written by Jem Guhit
#             August 18, 2020
#
#         Collects important 
#       information from benchmark.sh 
#****************************************#

#Directory of run_control_new
PATH_RC=${Dir}/run_control/
#Directory of benchmark_new
PATH_BENCHMARK=${Dir}/benchmark/

cd $PATH_RC
#Important variables 
Bandwidth=$(grep -n "Bandwidth:" ${PATH_RC}Run_Control_Test${n}.log)
export Bandwidth
echo $Bandwidth | awk '{print $2}'  >> ${parse}bandwidth.txt
Ttime=$(grep -n "Total transfer time " ${PATH_RC}Run_Control_Test${n}.log)
export Ttime 
echo $Ttime |  awk '{print $5}' >> ${parse}totaltime.txt
ErrCt=$(grep -c "Error" ${PATH_RC}Run_Control_Test${n}.log)
Err=$(grep -n "Error" ${PATH_RC}Run_Control_Test${n}.log)
Time=$(grep "seconds" ${PATH_RC}Run_Control_Test${n}.log | head -n -1 | cut -d' ' -f 1)
echo ${currentdate}_test$n "  "  $Bandwidth "  "  $Ttime "  " $ErrCt "  "  >> ${parse}parseRC.txt
(echo "${currentdate}_test$n "; echo $Err ; echo " ") >> ${parse}parseRC_err.txt
echo -e "$Time" >> ${parse}Time_Test${n}.txt

wait 

paste $MAINDIR/txtfiles/Size_medium.txt ${parse}Time_Test${n}.txt | while read size time; do 
FileBW=$(echo "scale=5; $size/$time" | bc -l)
echo $FileBW >> ${parse}Speed_Test${n}.txt
done

wait

cd $PATH_BENCHMARK
grep -rsi "Run: " >> ${parse}XrootDErr.txt
#grep -rsi -m1 "Socket error: Connection reset by peer" >> ${Output}xrdcp_socket.txt 
