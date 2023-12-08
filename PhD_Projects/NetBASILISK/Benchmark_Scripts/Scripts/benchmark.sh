#!/bin/bash

#****************************************#
#              benchmark.sh
#          written by Jem Guhit
#             July 23, 2020

#         Script responsible for  
#       transferring specific set of 
#       files and timing how long it 
#       takes. Produces log files
#****************************************#

#Directory of files 
Source=root://dcgftp.usatlas.bnl.gov:1094//pnfs/usatlas.bnl.gov/MCDISK/hiro/test/

#Directory of transferred files 
Dest=root://xrootd.aglt2.org:1094//pnfs/aglt2.org/atlasscratchdisk/NetBASILISK/XrootD/

#Directory of log files 
mkdir ${Dir}/benchmark/
Output=${Dir}/benchmark/

#Creates the $Dest directory. 
uberftp -mkdir gsiftp://dcdum01.aglt2.org/pnfs/aglt2.org/atlasscratchdisk/NetBASILISK/XrootD

echo "Begin Loop"
mkdir -p ${Output}${currentdatenew}_${n}
if [ $? -eq 0 ]; then
    echo ""
else
    echo "FAIL. Error Code: $?"
fi
startTot=$(date +%s)
paste $MAINDIR/txtfiles/TestFiles_medium.txt $MAINDIR/txtfiles/Checksumvals_medium.txt | while read line1 line2; do
#paste $MAINDIR/txtfiles/TestFiles_medium_og.txt $MAINDIR/txtfiles/Checksumvals_medium_og.txt | while read line1 line2; do
  echo "Reading $line1"
  echo "which xrdcp: "
  which xrdcp 
  start=$(date +%s)
  xrdcp --verbose --debug 3 --force --streams 4 --retry 0 --cksum adler32:$line2 $Source$line1 $Dest$line1 > ${Output}${currentdatenew}_${n}/${line1}.log 2>&1 
  if [ $? -eq 0 ]; then
    echo ""
  else
    echo "FAIL. Error Code: $?"
  fi
  
  end=$(date +%s)
  seconds=$(echo "$end - $start" | bc)
  echo $seconds 'seconds'
echo "------------------------------------------------------" 
done
endTot=$(date +%s)
secondsTot=$(echo "$endTot - $startTot" | bc)
echo 'Total transfer time is: ' $secondsTot 'seconds'
#Bandwidth=$( echo "scale=5 ; 219885.3914/$secondsTot"| bc) old values
Bandwidth=$( echo "scale=5 ; 236032/$secondsTot"| bc) #Total size for both good and bad file
echo "Bandwidth:" $Bandwidth "MB/s"
echo "Done!"
echo "------------------------------------------------------"

