import json
import matplotlib.dates as md
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
import datetime as dt
import time
from datetime import datetime
import itertools 
import glob
import os
#varname = ['load5_AVERAGE', 'util_AVERAGE', 'disk_utilization_AVERAGE', 'mem_available_AVERAGE']
def Extract_AGLT2(metadata, stat): #directory, interface
    metadata = str(metadata)
    stat = str(stat)
    out1 = os.environ["PP_AGLT2_Metrics"]
    if os.path.isdir(out1):
        print("Path exists", out1)
    else:
        print("Path does not exist")

    if metadata == 'CPU_load':
        out2 = os.path.join(out1, "{}".format(metadata))
        if os.path.isdir(out2):
            print("Path exists", out2)
        else:
            print("Path does not exist") 
        df = pd.read_csv(os.path.join(out2, "AGLT2_{}.csv".format(stat))) #metric = AGLT2, #stat = 0-7 
        df = df.drop('Unnamed: 0', axis = 1)
        df = df.T
        df['Servers'] = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21',
                        'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
        df = df.rename(columns={0: "load5_AVERAGE"}) #varname = load5_AVERAGE, etc
        df = pd.Series(df.load5_AVERAGE.values,index=df.Servers).to_dict()
        print(df)
        return df

    if metadata == 'CPU_utilization':
        out2 = os.path.join(out1, "{}".format(metadata))
        if os.path.isdir(out2):
            print("Path exists", out2)
        else:
            print("Path does not exist")
        df = pd.read_csv(os.path.join(out2, "AGLT2_{}.csv".format(stat))) #metric = AGLT2, #stat = 0-7 
        df = df.drop('Unnamed: 0', axis = 1)
        df = df.T
        df['Servers'] = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21',
                        'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
        df = df.rename(columns={0: "util_AVERAGE"}) #varname = load5_AVERAGE, etc
        df = pd.Series(df.util_AVERAGE.values,index=df.Servers).to_dict()
        print(df)
        return df

    if metadata == 'Disk_IO_SUMMARY':
        out2 = os.path.join(out1, "{}".format(metadata))
        if os.path.isdir(out2):
            print("Path exists", out2)
        else:
            print("Path does not exist")
        df = pd.read_csv(os.path.join(out2, "AGLT2_{}.csv".format(stat))) #metric = AGLT2, #stat = 0-7 
        df = df.drop('Unnamed: 0', axis = 1)
        df = df.T
        df['Servers'] = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21',
                        'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
        df = df.rename(columns={0: "disk_utilization_AVERAGE"}) #varname = load5_AVERAGE, etc
        df = pd.Series(df.disk_utilization_AVERAGE.values,index=df.Servers).to_dict()
        print(df)
        return df

    if metadata == 'Memory':
        out2 = os.path.join(out1, "{}".format(metadata))
        if os.path.isdir(out2):
            print("Path exists", out2)
        else:
            print("Path does not exist")
        df = pd.read_csv(os.path.join(out2, "AGLT2_{}.csv".format(stat))) #metric = AGLT2, #stat = 0-7 
        df = df.drop('Unnamed: 0', axis = 1)
        df = df.T
        df['Servers'] = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21',
                        'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
        df = df.rename(columns={0: "mem_available_AVERAGE"}) #varname = load5_AVERAGE, etc
        df = pd.Series(df.mem_available_AVERAGE.values,index=df.Servers).to_dict()
        print(df)
        return df

def Extract_CHIC(stat):
    stat = str(stat)
    outpath = os.environ["PP_AGLT2CHI_Metrics"]
    if os.path.isdir(outpath):
        print("Path exists", outpath)
    else:
        print("Path does not exist") 
    df =  pd.read_csv(os.path.join(outpath, "AGLT2_CHI_{}.csv".format(stat)))
    df = df.drop('Unnamed: 0', axis = 1)   
    df = df.T
    df = df.rename(columns={0: "Input", 1: "Output"})
    df = df.round(5)
    df = df.to_dict(orient='Index')
    print(df)
    return df

def Extract_RBIN(stat):
    stat = str(stat)
    outpath = os.environ["PP_RBIN_Metrics"]
    if os.path.isdir(outpath):
        print("Path exists", outpath)
    else:
        print("Path does not exist")   
    df =  pd.read_csv(os.path.join(outpath, "RBIN_{}.csv".format(stat)))
    df = df.drop('Unnamed: 0', axis = 1)
    df = df.T
    df = df.rename(columns={0: "GBIn", 1: "GBOut", 2: "GBPerSecIn", 3: "GBPerSecOut", 4: "UtilIn", 5: "UtilOut"})
    df = df.round(5)
    df = df.to_dict(orient='Index')
    print(df)   
    return df
