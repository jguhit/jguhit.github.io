import pandas as pd
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.dates import DateFormatter
import matplotlib.dates as mdates
from itertools import count
import os 
import time
import datetime 
plt.style.use('fivethirtyeight')

x_values = []
y_values = []

index = count()

path = '/home/guhitj/Documents/GUI_scripts/GUI_LosAlamos'

def animate(p1, p2, day, filename, outname):
    p1 = int(p1)
    p2 = int(p2)
    day = int(day) 
    filename = str(filename)
    outname = str(outname) 

    filepath = os.path.join(path, '{}_beam_run.csv'.format(filename))
    if os.path.exists(filepath):
           print("Path and file exists", filepath)
    else:
           print("Path and file does not exist")
 
    data = pd.read_csv(filepath)
    #print(data)
    x_values = data['DateTime']
    x_values = [v for i, v in enumerate(x_values) if i % 2 == 0]
    y1_values = data['Volt1_V']
    y1_values = [v for i, v in enumerate(y1_values) if i % 2 == 0]
    y2_values = data['Curr1_A']
    y2_values = [v for i, v in enumerate(y2_values) if i % 2 == 0]
    
    #for i in range(p1,p2):
    #    print(i, x_values[i]) #125, #989
     
    time = x_values[p1:p2]
    volt = y1_values[p1:p2]
    curr = y2_values[p1:p2]
    #print(time, volt, curr)
    
    
    tuples = list(zip(time, volt, curr))
    df = pd.DataFrame(data = tuples, columns=['Timestamp', 'Voltage', 'Current'])
    #df['date'] = pd.to_datetime(df['Timestamp']).dt.date
    #df['time'] = pd.to_datetime(df['Timestamp']).dt.time
    df['Voltage'] = pd.to_numeric(df['Voltage'], errors='coerce')
    df['Current'] = pd.to_numeric(df['Current'], errors = 'coerce')
    #time = df['time']
    time = df['Timestamp']
    volt1 = df['Voltage']
    curr1 = df['Current']

    listv = list(zip(time, volt1))
    listc = list(zip(time, curr1))
    list_all = list(zip(time, volt1, curr1))
    
    dfv = pd.DataFrame(data = listv, columns = ['Time', 'Volt1'])
    #dfv = dfv.sort_values(by=['Time'], ascending=False).reset_index(drop=True)
    dfv.set_index('Time', inplace=True)
    #print(dfv)
    
    dfc = pd.DataFrame(data = listc, columns = ['Time', 'Curr1']) 
    #dfc = dfc.sort_values(by=['Time'], ascending=False).reset_index(drop=True)
    dfc.set_index('Time', inplace=True)
    #df_all = pd.DataFrame(data = list_all, columns = ['Time', 'Volt1', 'Curr1'])
    
    #for i in range(len(dfv.index)):
    #    print(i, dfv.index[i])
    
    fig, axes = plt.subplots(2) 
    ax0 = dfv.plot(ax = axes[0], kind='line', figsize=(22,18), rot=20, x_compat=True)
    ax0.set_ylabel("Volt1 (V)", fontsize=20)
    ax0.set_xlabel("Time", fontsize=20)
    ax0.set_ylim([6.5,8.5])
    #date_form = DateFormatter("%H:%M:%S")
    #ax0.xaxis.set_major_formatter(date_form)
    #ax0.set_xticklabels(dfv.index)
    #ax0.invert_xaxis()
    ax0.set_title("{} Volt1 vs Time".format(outname), fontsize=25)
   
    ax1 = dfc.plot(ax = axes[1], kind='line', figsize=(22,18), rot=20, x_compat=True)
    ax1.set_ylabel("Curr1 (A)", fontsize=20)
    ax1.set_xlabel("Time", fontsize=20)
    ax1.set_ylim([0.3,0.6])
    #date_form = DateFormatter("%H:%M:%S")
    #ax1.xaxis.set_major_formatter(date_form)
    #ax1.set_xticklabels(dfc.index)
    #ax1.invert_xaxis()
    ax1.set_title("{} Curr1 vs Time".format(outname), fontsize=25)
    
    #fig.suptitle("AUG {}: Power Supply Data".format(day), fontsize=35)
    fig.tight_layout(pad=2.0)
    timestr = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    fig.savefig('{}_'.format(outname)+timestr+'_'+'{}'.format(p1)+'_'+'{}'.format(p2)+'.png')
     
#low = [125, 989, 1850, 2413, 1850, 3144, 3967]
#upper = [990, 1851, 2414, 3145, 3145, 3968, 4761]
#low = [4760, 5481, 6126, 6710, 7245, 7749, 125, 4760, 8649, 10221, 11020, 11880]
#upper = [5482, 6127, 6711, 7246, 7750, 8650, 4760, 8649, 9463, 11020, 11880, 12684 ]
#low = [12684, 13421, 14083, 14692, 15250, 15773, 16260, 8649, 13421, 125]
#upper = [13421, 14083, 14692, 15250, 15773, 16260, 17176, 13421, 17176, 8649]
low = [17176, 18057, 18907, 19790, 20644, 21465, 22224 , 22903, 23729, 24576, 25377, 26116, 26785, 27395, 27954, 28474, 17176, 22224, 17176]
upper = [18057, 18907, 19790, 20644, 21465, 22224, 22903, 23729, 24576, 25377, 26116, 26785, 27395, 27954, 28474, 29248, 26785, 26785, 26785 ]
for l, u in zip(low, upper):
    print(l, u)
    animate(l, u, 5, 'CSM1_0805', 'CSM1_ADDR5')
    animate(l, u, 5, 'CSM2_0805', 'CSM2_ADDR8')

#125:12nn, 990:2pm 
#989:2pm, 1851:4pm
#1850:4pm, 2414: 5:15pm
#2414: 5:15pm, 3145: 8pm 
#3144:8pm , 3968: 10pm
#3967:10pm , 4761: 12am

#animate(17176, 26785, 5, 'CSM2_0805', 'CSM2_ADDR8#')
#animate(171, 30000, 5, 'CSM1_0805', 'CSM1_ADDR5')
