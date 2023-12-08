import os
import time
import requests
from extract_dict import Extract_AGLT2, Extract_CHIC, Extract_RBIN 
import json 
import datetime 
from Timing import roundups, rounddos
tags = {}

metadata = ['CPU_load', 'CPU_utilization','Disk_IO_SUMMARY', 'Memory']
##varname = ['load5_AVERAGE', 'util_AVERAGE', 'disk_utilization_AVERAGE', 'mem_available_AVERAGE']
ave = []
std = []
minimum = []
maximum = []

##for i,j in zip(metadata,varname):
for j in metadata:
         ave_loop = Extract_AGLT2(j, '1')
         std_loop = Extract_AGLT2(j, '2')
         min_loop = Extract_AGLT2(j, '3')
         max_loop = Extract_AGLT2(j, '7')
         ave.append(ave_loop)
         std.append(std_loop)
         minimum.append(min_loop)
         maximum.append(max_loop)

stats = ['1','2','3','7']
chicaglt2 = []
rbin = []
for i in stats:
         chicaglt2_loop = Extract_CHIC(i)
         rbin_loop = Extract_RBIN(i)
         chicaglt2.append(chicaglt2_loop)
         rbin.append(rbin_loop)

variables = {}

with open(os.path.join(os.environ["parsedir"], "totaltime.txt")) as f: 
	for line in f: 
		tot_time = line.rstrip() 
with open(os.path.join(os.environ["parsedir"], "bandwidth.txt")) as g: 
	for line in g: 
		bw = line.rstrip()

with open(os.path.join(os.environ["timedir"], "Time.txt")) as t:
	for line in t:
		name, value = line.split("=")
		variables[name] = float(value)

start = variables["start"]
end = variables["end"]
startf_unix_date = datetime.datetime.fromtimestamp(int(start))
endf_unix_date = datetime.datetime.fromtimestamp(int(end))
startdo = rounddos(startf_unix_date)
endup = roundups(endf_unix_date)
	
date = os.environ["currentdate"]
print(tot_time, bw)
#Tot_time = os.environ["Ttime"]
#bw = os.environ["Bandwidth"]
attributes = {
    "summary": {
       'Benchmark Directory': date
       ,
       'Start Time': str(startdo)
       ,
       'End Time': str(endup)
       ,
       'Files Transferred': '50'
       ,
       'Total File Size': '236032'
       ,
       'Total Benchmark Time': tot_time
       ,
       'Bandwidth': bw


    },
    "server stats": {
        'cpu load ave': ave[0]
        ,
        'cpu load std': std[0]
        ,
        'cpu load min': minimum[0]
 	,
        'cpu load max': maximum[0]
        ,
 	'cpu utilization ave': ave[1]
        ,
        'cpu utilization std': std[1]
        ,
        'cpu utilization min': minimum[1]
        ,
        'cpu utilization max': maximum[1]
        ,
        'disk io ave': ave[2]
        ,
        'disk io std': std[2]
        ,
        'disk io min': minimum[2]
        ,
        'disk io max': maximum[2]
        ,
        'memory ave': ave[3]
        ,
        'memory std': std[3]
        ,
        'memory min': minimum[3]
        ,
        'memory max': maximum[3]	
    },
    "paths":{
        "rbin":{
            "ports ave": rbin[0]
            ,
            "ports std": rbin[1]
            ,
            "ports min": rbin[2]
            ,
            "ports max": rbin[3]
        },
        "chicaglt2":{
             "ports ave": chicaglt2[0]
             ,
             "ports std": chicaglt2[1]
             ,
             "ports min": chicaglt2[2]
             ,
             "ports max": chicaglt2[3]
        },
    },
}


data = [
    {
        "tags": tags,
        "events": [
            {
                "timestamp": time.time() * 1000,
                "attributes": attributes,
            }
        ]
    }
]

#URL = os.environ["HUMIO_URL"]
#TOKEN = os.environ["INGEST_TOKEN"]
TOKEN='730dca88-8a99-4bd6-99e4-27e1e68c2027'
URL='https://bsec-humio-aldn.umnet.umich.edu/internal/humio'

resp = requests.post('{}/api/v1/ingest/humio-structured'.format(URL), headers={'Authorization': 'Bearer {}'.format(TOKEN)}, json=data,)
#resp = requests.post(
#    f'{os.getenv("HUMIO_URL")}/api/v1/ingest/humio-structured',
#    headers={
#        'Authorization': f'Bearer {os.getenv("INGEST_TOKEN")}'
#    },
#    json=data,
#)

#resp = requests.post(f'{os.getenv("HUMIO_URL")}/api/v1/ingest/humio-structured', headers={'Authorization': f'Bearer {os.getenv("INGEST_TOKEN")}'},json=data,)

resp.raise_for_status()
print(resp)
