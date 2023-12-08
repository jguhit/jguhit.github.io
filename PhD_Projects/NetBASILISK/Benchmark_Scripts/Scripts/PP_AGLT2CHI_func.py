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
#import the function of rbin so i could get the timestamps
 
def AGLT2CHI(infile): #infile = AGLT2_CHI_0
    #print("-------------------------")
    #print("Running AGLT2CHI function")
    #print("-------------------------")

    infile = str(infile)
    inpath = os.path.join(os.environ["AGLT2CHIdir"], "{}.json".format(infile))
 
    if os.path.exists(inpath):
           print("Path and file exists", inpath)
    else:
           print("Path and file does not exist")

    df = pd.read_json(inpath)
    #df = pd.read_json(os.path.join(os.environ["AGLT2CHIdir"], "{}.json".format(infile))) 
    results = df["results"][0]
    df_results = pd.DataFrame(data=results)
    df_results.columns = ['input','output','description','intf', 'node']
    intf = df_results['intf'][0]
    node = df_results['node'][0]
    row, col = df_results.shape
    time = []
    inputval = []
    outputval = []
    start, end = RBIN('RBIN_0')
    start = int(start)
    end = int(end)
    start_datetime = datetime.utcfromtimestamp(start).strftime('%Y-%m-%d %H:%M:%S')
    end_datetime = datetime.utcfromtimestamp(end).strftime('%Y-%m-%d %H:%M:%S')
    #print(start, end)
    #print(start_datetime, end_datetime)
    #print(df_results)
    for i in range(row):
        #print(i, df_results["input"][i][0], df_results["input"][i][1], df_results["output"][i][1])
        time.append(df_results["input"][i][0])
        inputval.append(df_results["input"][i][1])
        outputval.append(df_results["output"][i][1])
    
    inputval.insert(len(inputval), 0)
    outputval.insert(len(outputval), 0)
    time.insert(len(time), time[len(time)-1]+60) 
    #print(time)
    #print(len(time))
    #print(time[len(time)-1]) 
    #print(time[len(time)-1]+60)
    tuples = list(zip(time, inputval, outputval))
    #print(tuples)
    df_finres = pd.DataFrame(data = tuples,columns=['Timestamp','Input','Output'])
    df_finres["Input"] = df_finres["Input"].replace(np.nan,0)
    df_finres["Output"] = df_finres["Output"].replace(np.nan,0)
    df_finres["Timestamp"] = pd.to_datetime(df_finres["Timestamp"],unit='s')
    #print(df_finres)
    df_finres = df_finres.set_index(["Timestamp"])
    df_finres = df_finres.resample("5T").mean()
    df_finres = df_finres.loc[start_datetime:end_datetime]
    cols = df_finres.columns
    df_finres[cols] = df_finres[cols] *(1.25e-10) 
    #print(df_finres)
    stats = df_finres[['Input', 'Output']].describe()
    
    AGLT2CHIpath = os.environ["PP_AGLT2CHI_dCache"]
    
    if os.path.isdir(AGLT2CHIpath):
           print("Path exists", AGLT2CHIpath)
    else:
           print("Path does not exist")
    
    stats.to_csv(os.path.join(AGLT2CHIpath, "Stats_{}.csv".format(infile)), index=True)
    #stats.to_csv(os.path.join(os.environ["PP_AGLT2CHI_dCache"], "Stats_{}.csv".format(infile)),index=True)
    #print(stats)
    return None

#AGLT2_CHI OLD INTERFACES, not used anymore
#0: et-0/3/0 sw2.star.omnipop.btaa.org
#1: et-3/1/0 sw2.star.omnipop.btaa.org
#2: et-1/3/0 sw2.600wchicag.omnipop.btaa.org
#3: et-5/0/0 sw2.600wchicag.omnipop.btaa.org
#4: et-0/1/0 sw2.600wchicag.omnipop.btaa.org
#5: et-2/1/0 sw2.600wchicag.omnipop.btaa.org
#OLD INTEFACES, not used anymore

#new identifiers
#1. sw2.star.omnipop.btaa.org - et-1/0/1 - University of Michigan 100G | BTAA-STAR-STAR-100GE-1620
#2. sw2.star.omnipop.btaa.org - et-0/0/0 - L2 BB sw2.star to sw2.600WChicag et-0/0/0 200G LAG | BTAA-600WCHICAG-STAR-100GE-01578
#3. sw2.star.omnipop.btaa.org - et-1/0/0 - L2 BB sw2.star to sw2.600WChicag et-0/0/2 200G LAG | BTAA-600WCHICAG-STAR-100GE-01579
#4. sw2.star.omnipop.btaa.org - et-0/1/0 - ESnet 100G | BTAA-STAR-STAR-100GE-1623
#5. sw2.600wchicag.omnipop.btaa.org - et-0/1/0 - ESnet 100GE 1of2 for LAG | BTAA-600WCHICAG-600WCHICAG-100GE-02273
#6. sw2.600wchicag.omnipop.btaa.org - et-1/0/2 - ESnet 100GE 2of2 for LAG | BTAA-600WCHICAG-600WCHICAG-100GE-02274

def AGLT2CHI_Stats(metric):
     #print("-------------------------------")
     #print("Running AGLT2CHI_Stats function")
     #print("-------------------------------")
     metric = str(metric)
     #path='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/{}/dCache'.format(metric)
     #path='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/TestFiles/Output_20210201_1140/Stats/{}/dCache'.format(metric)
     AGLT2CHIpath = os.environ["PP_AGLT2CHI_dCache"]

     if os.path.isdir(AGLT2CHIpath):
           print("Path exists", AGLT2CHIpath)
     else:
           print("Path does not exist")
     #csvfiles = glob.glob(os.path.join(os.environ["PP_AGLT2CHI_dCache"], '*.csv'))
     csvfiles = glob.glob(os.path.join(AGLT2CHIpath, '*.csv'))
     csvfiles = sorted(csvfiles)
     print("Check the order of the files")
     print(csvfiles) 
     
     #loop through the files and read them in with pandas
     dataframes = []  # a list to hold all the individual pandas DataFrames
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
         #df.columns = ['et-0/3/0', 'et-3/1/0', 'et-1/3/0', 'et-5/0/0', 'et-0/1/0', 'et-2/1/0']
         df.columns = ['et-1/0/1', 'et-0/0/0', 'et-1/0/0', 'et-0/1/0_star', 'et-0/1/0_chic', 'et-1/0/2']
         df.drop('Metric', axis=0, inplace=True)
         #outpath='/lustre/umt3/user/guhitj/Gitlab/netbasilisk/XRootD/AGLT2/Scripts/Framework-Combined/Output/Output_20210319_1555/preprocessing/AGLT2_CHI/Metrics'
         #df.to_csv(os.path.join(outpath, "{}_{}.csv".format(metric,index)), index=True)
         #df.to_csv('{}/PP_Output/{}/Stats/{}/Metrics/{}_{}.csv'.format(path, directory,metric,metric,index), index=True)
         
         outpath = os.environ["PP_AGLT2CHI_Metrics"]

         if os.path.isdir(outpath):
            print("Path exists", outpath)
         else:
            print("Path does not exist")
         
         df.to_csv(os.path.join(outpath, "{}_{}.csv".format(metric,index)), index=True)
         #df.to_csv(os.path.join(os.environ["PP_AGLT2CHI_Metrics"], "{}_{}.csv".format(metric,index)), index=True)
         #print(df)
    
     for index, df in enumerate(dfs):
         transpose(index,df)

#AGLT2CHI_list = [0,1,2,3,4,5]
#for j in AGLT2CHI_list:
#    AGLT2CHI('AGLT2_CHI_{}'.format(j))

#time.sleep(120)

#AGLT2CHI_Stats('AGLT2_CHI')
