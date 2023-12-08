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

def AGLT2_mem(host, metadata, varname, index):
    host = str(host)
    metadata = str(metadata)
    varname = str(varname)
    index = int(index)
    
    inpath = os.path.join(os.environ["AGLT2dir"], "AGLT2_{}_{}.json".format(metadata,host))

    if os.path.exists(inpath):
           print("Path and file exists", inpath)
    else:
           print("Path and file does not exist")    
    
    df = pd.read_json(inpath)
    #df = pd.read_json(os.path.join(os.environ["testdir_aglt2"], "AGLT2_{}_{}.json".format(metadata,host)))
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

    #print(len(timestamps), len(values))
    #values.insert(len(values), np.zeros(len(values[0])))
    var_ave = []
    for i in range(len(values)):
        #print(values[i][11])
        var_ave.append(values[i][index])  
   
    tuples = list(zip(timestamps, var_ave))
    df_values = pd.DataFrame(data = tuples,columns=['Timestamp','{}'.format(varname)],dtype=float)
    df_values["{}".format(varname)] = df_values["{}".format(varname)].replace(np.nan,0)
    df_values["Timestamp"] = pd.to_datetime(df_values["Timestamp"],unit='s')
    df_values = df_values.set_index(["Timestamp"])
    df_values = df_values.resample("5T").mean()
    df_values = df_values.loc[start_datetime:end_datetime]
    cols = df_values.columns
    df_values[cols] = df_values[cols] *(1.25e-10)
    #print(df_values)
    stats = df_values[['{}'.format(varname)]].describe()
    #print(stats) 
    
    AGLT2path = os.environ["PP_AGLT2_dCache"]
   
    if os.path.isdir(AGLT2path):
           print("Path exists", AGLT2path)
    else:
           print("Path does not exist")

    outpath = os.path.join(AGLT2path, "{}".format(metadata))
    os.makedirs(outpath, exist_ok=True)

    time.sleep(5)
   
    if os.path.isdir(outpath):
           print("Path exists", outpath)
    else:
           print("Path does not exist")

    stats.to_csv(os.path.join(outpath, "Stats_{}_{}.csv".format(metadata, host)),index=True)

    return None 
