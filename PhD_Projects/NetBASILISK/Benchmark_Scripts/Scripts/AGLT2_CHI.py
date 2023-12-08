#!/usr/bin/env python 

import requests
import os
import json
import time
from datetime import datetime, timedelta
from Timing import roundups, rounddos
#url = "https://snapp-portal.omnipop.btaa.org/grafana/api/datasources/proxy/54/query.cgi"
url = "https://grafana.omnipop.btaa.org/grafana/api/datasources/proxy/68/query.cgi"

#identifier = ['d516dc0906bff35d6f5c2c9aae5dea21effaa46f96b00d9e0f28e81492c19853','183b07e6d13fa2c442ce7c7573550d4780be61d1f45fcab948102550a48cd977', 'f6e1d5da2b240f0df1be1209674215b55719235203b1d828e9494a3fa3f7e8c1','50912a45ce1a3d51ead67d63735b3e3563c0939aad10c1b6a166579a0524c6ed','d3947c64aa4ebd202cff06fb9c5e6badf51296db72ab3ba8ff01f35811d423ae', 'a45cf7de85707efbf8a4fb7b07af5b405c192682ddfcd165b5c9ad855b202d80']

identifier = ['620d46c684eff80106ffc4b5769f77e9f658cc7c3ee3cd847261da09570167f3', '696e977330667f44c13ffe5364446c96a2fa4cc9137b9e5ddbd23605bf489e12', 'fa5373adef061fa051ef458a8e028a84749385edb16955537eac43712b6ef72b', '939820268eaf905fae19a951a9bd73af2834017d0d2744229d71608b47afdf1c', 'd3947c64aa4ebd202cff06fb9c5e6badf51296db72ab3ba8ff01f35811d423ae', '1dd502cdcfac422ff031a6f097ef8385c7b4078b4a4b19081bb39c0dd86ddae7']

#new identifiers
#1. sw2.star.omnipop.btaa.org - et-1/0/1 - University of Michigan 100G | BTAA-STAR-STAR-100GE-1620
#620d46c684eff80106ffc4b5769f77e9f658cc7c3ee3cd847261da09570167f3
#2. sw2.star.omnipop.btaa.org - et-0/0/0 - L2 BB sw2.star to sw2.600WChicag et-0/0/0 200G LAG | BTAA-600WCHICAG-STAR-100GE-01578
#696e977330667f44c13ffe5364446c96a2fa4cc9137b9e5ddbd23605bf489e12 
#3. sw2.star.omnipop.btaa.org - et-1/0/0 - L2 BB sw2.star to sw2.600WChicag et-0/0/2 200G LAG | BTAA-600WCHICAG-STAR-100GE-01579
#fa5373adef061fa051ef458a8e028a84749385edb16955537eac43712b6ef72b
#4. sw2.star.omnipop.btaa.org - et-0/1/0 - ESnet 100G | BTAA-STAR-STAR-100GE-1623
#939820268eaf905fae19a951a9bd73af2834017d0d2744229d71608b47afdf1c
#5. sw2.600wchicag.omnipop.btaa.org - et-0/1/0 - ESnet 100GE 1of2 for LAG | BTAA-600WCHICAG-600WCHICAG-100GE-02273
#d3947c64aa4ebd202cff06fb9c5e6badf51296db72ab3ba8ff01f35811d423ae
#6. sw2.600wchicag.omnipop.btaa.org - et-1/0/2 - ESnet 100GE 2of2 for LAG | BTAA-600WCHICAG-600WCHICAG-100GE-02274
#1dd502cdcfac422ff031a6f097ef8385c7b4078b4a4b19081bb39c0dd86ddae7

variables = {}

with open(os.path.join(os.environ["Timepath"],"Time.txt")) as f:
#with open('/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/timestamp/Time.txt') as f:
    for line in f:
        name, value = line.split("=")
        variables[name] = float(value)

start = variables["start"]
#startf = int(start)
end = variables["end"]
#endf = int(end)

startf_unix_date = datetime.fromtimestamp(int(start)) #.strftime('%Y-%m-%d %H:%M:%S')
#startf_unix_date = datetime.strptime(startf_unix_date, '%Y-%m-%d %H:%M:%S')
endf_unix_date = datetime.fromtimestamp(int(end)) #.strftime('%Y-%m-%d %H:%M:%S')
#endf_unix_date = datetime.strptime(endf_unix_date, '%Y-%m-%d %H:%M:%S')

startdo = rounddos(startf_unix_date) #so this rounds down the start time to the earliest hour
start_final = time.mktime(startdo.timetuple())
#start_final = int(start_final)
endup = roundups(endf_unix_date) #this rounds up the end time to the closest hour
end_final = time.mktime(endup.timetuple())
#end_final = int(end_final)

with open(os.path.join(os.environ["AGLT2CHI"],'Time_final.txt'), 'w') as files:
#with open('/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/environment/AGLT2_CHI/Time_final.txt', 'w') as files:
    #files.write("Start Time" + str(start_final) + "\n")
    #files.write("End Time" + str(end_final) + "\n")
    files.write("start="+str(start_final)+"\n")
    files.write("end="+str(end_final)+"\n")    

#for i in identifier:
for index, line in enumerate(identifier):
	#query = "method=query;query=get%20intf%2C%20node%2C%20aggregate(values.input%2C%2060%2C%20average)%2C%20aggregate(values.output%2C%2060%2C%20average)%20between%20({}%2C%20{})%20by%20intf%2Cnode%20from%20interface%20where%20((identifier%20%3D%20%22{}%22))%20ordered%20by%20node".format(int(start_final),int(end_final),line)
	query = "method=query;query=get%20intf%2C%20node%2C%20description%2C%20aggregate(values.input%2C%2060%2C%20average)%2C%20aggregate(values.output%2C%2060%2C%20average)%20between%20({}%2C%20{})%20by%20intf%2Cnode%20from%20interface%20where%20((identifier%20%3D%20%22{}%22))%20ordered%20by%20node".format(int(start_final),int(end_final),line)
        #print(query)
	response = requests.request("POST", url,data=query)
	#print(response.text)
	todos = json.loads(response.text)
	todos == response.json()
	#time.sleep(600)
	#with open('testAGLT2CHI/AGLT2_CHI_{}.json'.format(index), 'a') as fp:
	with open(os.path.join(os.environ["AGLT2CHI"],"AGLT2_CHI_{}.json".format(index) ),'w') as fp:
	#with open('/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/environment/AGLT2_CHI/AGLT2_CHI_{}.json'.format(index), 'w') as fp: 
		json.dump(todos, fp, sort_keys=True, indent=4)
	
