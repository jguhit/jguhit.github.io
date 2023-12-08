import requests
import csv
import os 
import time
import json
from datetime import datetime, timedelta
from Timing import roundups, rounddos
url = "http://capm-da-asb.umnet.umich.edu:8581/odata/api/interfaces"

variables = {}

with open(os.path.join(os.environ["Timepath"],"Time.txt")) as f:
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


with open(os.path.join(os.environ["RBIN"],'Time_final.txt'), 'w') as files:
    #files.write("Start Time" + str(start_final) + "\n")
    #files.write("End Time" + str(end_final) + "\n")
    files.write("start="+str(start_final)+"\n")
    files.write("end="+str(end_final)+"\n")

hosts = ['et-8/2/0','et-8/0/0','et-4/3/0']
#et-4/3/0
for index, line in enumerate(hosts):
        #print(index,line)
#for i in range(len(hosts)):
        #querystring = {"resolution":"RATE","starttime":"{}".format(startf),"endtime":"{}".format(endf),"$expand":"portmfs","$select":"ID,portmfs/im_BitsIn,portmfs/im_BitsOut,portmfs/im_BitsPerSecondIn,portmfs/im_BitsPerSecondOut,portmfs/im_UtilizationIn,portmfs/im_UtilizationOut","$filter":"((tolower(device/Name) eq tolower('r-bin-seb.umnet.umich.edu')) and (tolower(Name) eq tolower('{}')))".format(hosts[i])}
        querystring = {"resolution":"RATE","starttime":"{}".format(int(start_final)),"endtime":"{}".format(int(end_final)),"$expand":"portmfs","$select":"ID,portmfs/Timestamp,portmfs/im_BitsIn,portmfs/im_BitsOut,portmfs/im_BitsPerSecondIn,portmfs/im_BitsPerSecondOut,portmfs/im_UtilizationIn,portmfs/im_UtilizationOut","$filter":"((tolower(device/Name) eq tolower('r-bin-seb.umnet.umich.edu')) and (tolower(Name) eq tolower('{}')))".format(line)}
        #querystring = {"resolution":"RATE","starttime":"1606978800","endtime":"1606986000","$expand":"portmfs","$select":"ID,portmfs/Timestamp,portmfs/im_BitsIn,portmfs/im_BitsOut,portmfs/im_BitsPerSecondIn,portmfs/im_BitsPerSecondOut,portmfs/im_UtilizationIn,portmfs/im_UtilizationOut","$filter":"((tolower(device/Name) eq tolower('r-bin-seb.umnet.umich.edu')) and (tolower(Name) eq tolower('{}')))".format(line)}
        payload = ""
        headers = {'cookie': "JSESSIONID=p0pnitc0u19atbaqu91ajkov", 'Authorization': "Basic c3BlY3RwZDozckJAZSFAbiE="}
        response = requests.request("GET", url, data=payload, headers=headers, params=querystring)
        #time.sleep(600)
        start = time.time()
        #with open('testRBIN/RBIN_{}.csv'.format(index), 'w') as f:
        with open(os.path.join(os.environ["RBIN"],"RBIN_{}.csv".format(index)), 'wb') as f:
             for chunk in response:
                 f.write(chunk)

        end = time.time()
        total = 5 + ( end - start )
        #print(total)
        time.sleep(total)
        #print("done sleep")
        #with open('testRBIN/RBIN_{}.csv'.format(index)) as csvfile:
        with open(os.path.join(os.environ["RBIN"],"RBIN_{}.csv".format(index))) as csvfile:
             reader = csv.DictReader(csvfile)
             dict_list = []
             for row in reader:
                 #print(row['ID'], row['portmfs/Timestamp'])
                 dict_list.append(row)
                 
                 #with open('testRBIN/RBIN_{}.json'.format(index), 'w') as fp:
                 with open(os.path.join(os.environ["RBIN"],"RBIN_{}.json".format(index)), 'w') as fp:
                      json.dump(dict_list, fp, sort_keys=True, indent=4)
