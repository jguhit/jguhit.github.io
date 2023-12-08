#!/usr/bin/env python
import json
import matplotlib.dates as md
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import datetime as dt
import time
from datetime import datetime
import itertools
import os
import glob
from PP_RBIN_func import RBIN

def AGLT2(host, metadata, varname, index):
    #print("----------------------")
    #print("Running AGLT2 function")
    #print("----------------------")
    host = str(host)
    metadata = str(metadata)
    varname = str(varname)
    index = int(index)
    
    #check here 
    #build the path and check if it exists 
    #filepath = os.path.join(os.environ["AGLT2"], "AGLT2_{}_{}.json".format(metadata, host))
    #verify if filepath exists: 
    	#df = pd.read
    #else: 
    #Print('warning, not found', filepath)
    inpath = os.path.join(os.environ["AGLT2dir"], "AGLT2_{}_{}.json".format(metadata,host))

    if os.path.exists(inpath):
           print("Path and file exists", inpath)
    else:
           print("Path and file does not exist")

    df = pd.read_json(inpath)
    #df = pd.read_json(os.path.join(os.environ["AGLT2dir"], "AGLT2_{}_{}.json".format(metadata,host)))
    start = df["meta"]["start"]
    end = df["meta"]["end"]
    #print('start_aglt2', start)
    #print('end_aglt2', end)
    LEG = df["meta"]["legend"]
    DATA = df["data"]["row"]
    DATA = pd.DataFrame(data = DATA)
    LEG = pd.DataFrame(data = LEG)
    row, col = DATA.shape
    start_rbin, end_rbin = RBIN('RBIN_0')
    start_datetime = datetime.utcfromtimestamp(start_rbin).strftime('%Y-%m-%d %H:%M:%S')
    end_datetime = datetime.utcfromtimestamp(end_rbin).strftime('%Y-%m-%d %H:%M:%S')
    #print('start_rbin', start_rbin)
    #print('end_rbin', end_rbin)
    #print('start_rbin_date', start_datetime)
    #print('end_rbin_date', end_datetime)
    
    timestamps = []
    for i in range(row):
        start = int(start)
        start = start + 60
        timestamps.append(start)
        #print(i, start)
    
    #start_aglt2 = df["meta"]["start"]
    #timestamps.insert(0, start_aglt2)
    
    #print(timestamps)
    values = []
    for i in range(row):
        datum = DATA.iloc[i,0]
        values.append(datum)
        #print(i, datum)
    
    #values.insert(len(values), np.zeros(len(values[0])))
    var_ave = []
    for i in range(len(values)):
        #print(values[i][5])
        var_ave.append(values[i][index])  

    #print(len(timestamps), len(values))
    tuples = list(zip(timestamps, var_ave))
    df_values = pd.DataFrame(data = tuples,columns=['Timestamp','{}'.format(varname)],dtype=float) 
    df_values["{}".format(varname)] = df_values["{}".format(varname)].replace(np.nan,0)
    df_values["Timestamp"] = pd.to_datetime(df_values["Timestamp"],unit='s')
    #print(df_values)
    df_values = df_values.set_index(["Timestamp"])
    df_values = df_values.resample("5T").mean()
    df_values = df_values.loc[start_datetime:end_datetime]
    #print(df_values)
    stats = df_values[['{}'.format(varname)]].describe()
    #print(stats)
    #create a new directory here for PP_AGLT2_dCache/metadata where (metadata = CPU_load, CPU_utilization, Memory, Disk_IO_SUMMARY)
    AGLT2path = os.environ["PP_AGLT2_dCache"]
     
    if os.path.isdir(AGLT2path):
           print("Path exists", AGLT2path)
    else:
           print("Path does not exist")

    #outpath = os.path.join(os.environ["PP_AGLT2_dCache"], "{}".format(metadata))
    outpath = os.path.join(AGLT2path, "{}".format(metadata))
    os.makedirs(outpath, exist_ok=True)
   
    time.sleep(5)

    if os.path.isdir(outpath):
           print("Path exists", outpath)
    else:
           print("Path does not exist")
    #validate error checking 
    #time.sleep(60)
    stats.to_csv(os.path.join(outpath, "Stats_{}_{}.csv".format(metadata, host)),index=True) 
    #outpath='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/AGLT2/dCache/{}'.format(metadata)
    #stats.to_csv(os.path.join(outpath, "Stats_{}_{}.csv".format(metadata, host)), index=True) 
    return None 
    #########################################################################################################################################################

def AGLT2_Stats(metric, metadata):
    #print("-------------------------------")
    #print("Running AGLT2_Stats function")
    #print("-------------------------------")
    metric = str(metric)
    metadata = str(metadata)

    AGLT2path = os.environ["PP_AGLT2_dCache"]

    if os.path.isdir(AGLT2path):
           print("Path exists", AGLT2path)
    else:
           print("Path does not exist")

    #path = os.path.join(os.environ["PP_AGLT2_dCache"], "{}".format(metadata))
    outpath = os.path.join(AGLT2path, "{}".format(metadata))
    if os.path.isdir(outpath):
           print("Path exists", outpath)
    else:
           print("Path does not exist", outpath)
    csvfiles = glob.glob(os.path.join(outpath, '*.csv'))
    csvfiles = sorted(csvfiles)
    print("Check the order of the files")
    print(csvfiles)
    dataframes = []
    for csvfile in csvfiles:
        df = pd.read_csv(csvfile)
        dataframes.append(df)
    
    result = pd.concat(dataframes, ignore_index=True)
    DATA = pd.DataFrame(data = result)
    DATA = DATA.round(3)
    #print(DATA)
    df_count = DATA[DATA.index % 8 == 0]
    df_mean = DATA[DATA.index % 8 == 1]
    df_std = DATA[DATA.index % 8 == 2]
    df_min = DATA[DATA.index % 8 == 3]
    df_pt_25 =  DATA[DATA.index % 8 == 4]
    df_pt_50 =  DATA[DATA.index % 8 == 5]
    df_pt_75 =  DATA[DATA.index % 8 == 6]
    df_max =  DATA[DATA.index % 8 == 7]
    
    dfs = [df_count, df_mean, df_std, df_min, df_pt_25, df_pt_50, df_pt_75, df_max]
    for df in dfs:
        df.rename(columns={'Unnamed: 0':'Metric'}, inplace=True)

    def transpose(index, dataframe):
        df = dataframe.T
        columns = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21', 'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
        df.drop('Metric', axis=0, inplace=True)
        out1 = os.environ["PP_AGLT2_Metrics"]
        if os.path.isdir(outpath):
            print("Path exists", outpath)
        else:
            print("Path does not exist")
 
        out2 = os.path.join(out1, "{}".format(metadata))
        os.makedirs(out2, exist_ok=True)
        #outpath = os.path.join(os.environ["PP_AGLT2_Metrics"], "{}".format(metadata))
        #os.mkdir(outpath)
        time.sleep(5)

        if os.path.isdir(out2):
           print("Path exists", out2)
        else:
           print("Path does not exist")
        #outpath='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/{}/Metrics/{}'.format(metric, metadata)
        df.to_csv(os.path.join(out2, "{}_{}.csv".format(metric,index)), index=True)
        #df.to_csv('{}/PP_Output/{}/Stats/{}/Metrics/{}_{}.csv'.format(path, directory,metric,metric,index), index=True)
        #df.to_csv(os.path.join(os.environ["PP_RBIN_Metrics"], "{}_{}.csv".format(metric,index)), index=True)
        #print(df)
    
    for index, df in enumerate(dfs):
        transpose(index,df)


#servers = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21', 'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
#for i in servers:
#     AGLT2('{}'.format(i), 'CPU_load', 'load5_AVERAGE', 5)
#     AGLT2('{}'.format(i), 'CPU_utilization', 'util_AVERAGE', 11)
#     AGLT2('{}'.format(i), 'Disk_IO_SUMMARY', 'disk_utilization_AVERAGE', 2)
#     AGLT2('{}'.f rmat(i), 'Memory', 'mem_available_AVERAGE', 74)

#time.sleep(120)
#metadata = ['CPU_load', 'CPU_utilization', 'Disk_IO_SUMMARY', 'Memory']
#AGLT2_Stats('AGLT2', '{}'.format(metadata))

