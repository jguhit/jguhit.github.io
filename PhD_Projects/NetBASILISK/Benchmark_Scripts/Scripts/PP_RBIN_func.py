#!/usr/bin/env python
import json
import matplotlib.dates as md
import numpy as np
import pandas as pd 
import datetime as dt
import time
from datetime import datetime
import itertools 
import os 
import glob

def RBIN(infile):
    #print("----------------------")
    #print("Running RBIN function")
    #print("----------------------")

    infile = str(infile)
    inpath = os.path.join(os.environ["RBINdir"], "{}.json".format(infile)) 
    
    if os.path.exists(inpath):
           print("Path and file exists", inpath)
    else:
           print("Path and file does not exist")
    
    df = pd.read_json(inpath)
    #df = pd.read_json(os.path.join(os.environ["RBINdir"], "{}.json".format(infile)))
    ID, time, BitsIn, BitsOut, BitsSecIn, BitsSecOut, UtilIn, UtilOut = df.columns
    starttime = df["portmfs/Timestamp"].iloc[[0]]
    #starttime = int(starttime)
    starttime = int(float(starttime))
    endtime = df["portmfs/Timestamp"].iloc[[-1]]
    #endtime = int(endtime)
    endtime = int(float(endtime))
    df[time] = pd.to_datetime(df[time],unit='s')
    cols = df.columns.drop([ID,time,UtilIn,UtilOut])
    df[cols] = df[cols]* (1.25e-10)
    row, col = df.shape
    df = df[0:row]
    stats = df[[BitsIn, BitsOut,BitsSecIn, BitsSecOut, UtilIn, UtilOut]].describe()
    #print(stats)
   
    RBINpath = os.environ["PP_RBIN_dCache"]

    if os.path.isdir(RBINpath):
           print("Path exists", RBINpath)
    else:
           print("Path does not exist")
    
    stats.to_csv(os.path.join(RBINpath, "Stats_{}.csv".format(infile)), index=True)
    #stats.to_csv(os.path.join(os.environ["PP_RBIN_dCache"], "Stats_{}.csv".format(infile)),index=True) 
    #outpath='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/RBIN/dCache'
    #stats.to_csv(os.path.join(outpath, "Stats_{}.csv".format(infile)), index=True)
    #print(df)
    #print(starttime)
    #print(endtime) 
    return starttime, endtime 


#0: et-8/0/0, 1: et-8/2/0
def RBIN_Stats(metric): #metric
    #print("----------------------")
    #print("Running RBIN Stats function")
    #print("----------------------")
    metric = str(metric)
    #path='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/{}/dCache'.format(metric)
    #path='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/TestFiles/Output_20210201_1140/Stats/{}/dCache'.format(metric)
    RBINpath = os.environ["PP_RBIN_dCache"]
    
    if os.path.isdir(RBINpath):
           print("Path exists", RBINpath)
    else:
           print("Path does not exist")

    #csvfiles = glob.glob(os.path.join(os.environ["PP_RBIN_dCache"], '*.csv'))
    csvfiles = glob.glob(os.path.join(RBINpath, '*.csv'))
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
        df.columns = ['et-8/2/0','et-8/0/0','et-4/3/0']
        df.drop('Metric', axis=0, inplace=True)
        #outpath='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/RBIN/Metrics'
        #df.to_csv(os.path.join(outpath, "{}_{}.csv".format(metric,index)), index=True)
        #df.to_csv('{}/PP_Output/{}/Stats/{}/Metrics/{}_{}.csv'.format(path, directory,metric,metric,index), index=True)
        outpath = os.environ["PP_RBIN_Metrics"]
        
        if os.path.isdir(outpath):
           print("Path exists", outpath)
        else:
           print("Path does not exist")
        
        df.to_csv(os.path.join(outpath, "{}_{}.csv".format(metric,index)), index=True)
        #df.to_csv(os.path.join(os.environ["PP_RBIN_Metrics"], "{}_{}.csv".format(metric,index)), index=True)
        #print(df)
    
    for index, df in enumerate(dfs):
        transpose(index,df)

#Legend for index:
#0 = count, 1 = mean, 2 = std, 3 = min, 4 = pt_25, 5 = pt_50, 6 = pt_75, 7 = max 

#RBIN_list = [0,1,2]
#for i in RBIN_list:
   #print("RBIN_{}".format(i))
   #RBIN('RBIN_{}'.format(i))

#time.sleep(120)

#RBIN_Stats('RBIN')
