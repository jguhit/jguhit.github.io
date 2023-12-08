#!/usr/bin/env python3
import json
import requests
import os
import time
from datetime import datetime, timedelta
from Timing import roundups, rounddos
hosts = ['umfs06','umfs20', 'umfs23', 'umfs26', 'umfs09', 'umfs16', 'umfs21', 'umfs24', 'umfs27', 'umfs11', 'umfs19', 'umfs22', 'umfs25', 'umfs28' ]
#umfs02, umfs14
servers = ['CPU_load', 'CPU_utilization', 'Disk_IO_SUMMARY', 'Memory']
url = 'https://um-omd.aglt2.org/atlas/pnp4nagios/xport/json'

variables = {}

with open(os.path.join(os.environ["Timepath"], "Time.txt")) as f:
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

with open(os.path.join(os.environ["AGLT2"],'Time_final.txt'), 'w') as files:
    #files.write("Start Time" + str(start_final) + "\n")
    #files.write("End Time" + str(end_final) + "\n")
    files.write("start="+str(start_final)+"\n")
    files.write("end="+str(end_final)+"\n")    

for j in range(len(hosts)):
	for i in range(len(servers)):
#for i in range(len(servers)):
#         for j in range(len(hosts)):
                #querystring = {"start":"{}".format(int(start_final)),"end":"{}".format(int(end_final)),"host":"{}".format(hosts[j]), "srv":"{}".format(servers[i])}
		#querystring = {"start":"1602068400","end":"1602070200","host":"{}".format(hosts[j]), "srv":"{}".format(servers[i])} 
		#print(querystring)
                querystring = {"host":"{}".format(hosts[j]), "srv":"{}".format(servers[i]), "start":"{}".format(int(start_final)), "end":"{}".format(int(end_final))}
                payload = ""
                headers = {"cookie": "pnp4nagios=v7gj225tqflmgal5c1ji54rqj1", "Cookie": "__utma=37526576.779950651.1585936035.1585936035.1585936035.1; pnp4nagios=hru4rg9ch6imsi34khjc747jg3; auth_atlas=omdadmin:1618406441.45:d4e6cb1629f078fa89b59d2429785d00","Authorization": "Basic b21kYWRtaW46U05ldXRyaW5vOTk="} 
		#headers = {'cookie': "pnp4nagios=81b90oupt9qsjvd1h09unjivn1",'authorization': "Basic b21kYWRtaW46U05ldXRyaW5vOTk="}
                response = requests.request("GET", url, data=payload, headers=headers, params=querystring)
                #print(response.text)

                todos = json.loads(response.text)
                todos == response.json()
                #time.sleep(600)
                #with open('test/AGLT2_{0}_{1}.json'.format(servers[i],hosts[j]), 'w') as fp:
                with open(os.path.join(os.environ["AGLT2"], "AGLT2_{0}_{1}.json".format(servers[i],hosts[j])),'w') as fp:
                     json.dump(todos, fp, sort_keys=True, indent=4)
