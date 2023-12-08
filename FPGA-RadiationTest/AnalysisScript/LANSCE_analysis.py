#!/usr/bin/env python
# coding: utf-8


#Correctiom Beam Divergence 
iceii = 13.87
csm1 = 0.7747
csm2 = 0.6858

board1 = (iceii/(iceii+csm1))**2
board2 = (iceii/(iceii+csm2))**2
corr1 = (1 - board1)*100
corr2 = (1 - board2)*100
print("board1: ", str.format('{0:.4f}', board1), ", beam intensity is reduced by", str.format('{0:.4f}', corr1),"%")
print("board2: ", str.format('{0:.4f}', board2), ", beam intensity is reduced by", str.format('{0:.4f}', corr2),"%")



import csv
import pandas as pd 
import os
from itertools import islice
import matplotlib.pyplot as plt
from functools import reduce

dfs1 = ('df1', 'df2', 'df3', 'df4', 'df5', 'df6')
dfs2 = ('df1', 'df2', 'df3', 'df4', 'df5', 'df6')
file_235 = ('summary7685-7686_235U.csv', 'summary7687-7693_235U.csv', 'summary7694-7711_235U.csv', 'summary7712-7740_235U.csv', 'summary7741-7764_235U.csv', 'summary7765-7771_235U.csv')
file_238 = ('summary7685-7686_238U.csv', 'summary7687-7693_238U.csv', 'summary7694-7711_238U.csv', 'summary7712-7740_238U.csv', 'summary7741-7764_238U.csv', 'summary7765-7771_238U.csv')
dfs_235 = {}
dfs_238 = {}
newdf_235 = {}
newdf_238 = {}
area = 24.718

for df, file in zip(dfs1, file_235):
    path = "/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log"
    filename = os.path.join(path, file)
    #print(filename)
    dfs_235[df] = pd.read_csv(filename, skiprows=6)
    dfs_235[df].drop(dfs_235[df].tail(3).index, inplace=True)
    newdf_235[df] = dfs_235[df].set_axis(['Bin', 'En_lo', 'En_hi', 'Eavg', 'n_MeV_Sr_up', 'Error', 'Tot_Fluence', 'Tot_Err', 'Unnamed'], axis=1, inplace=False)
    newdf_235[df]['En_lo'] = pd.to_numeric(newdf_235[df]['En_lo'],errors='coerce')
    newdf_235[df]['En_hi'] = pd.to_numeric(newdf_235[df]['En_hi'],errors='coerce')
    newdf_235[df]['binsize']  = newdf_235[df]['En_hi'] - newdf_235[df]['En_lo']
    newdf_235[df]["Fluence_cm2"] = newdf_235[df]["Tot_Fluence"]/area 
    #newdf_235[df]['Flu_bin'] = newdf_235[df]["Tot_Fluence"]/newdf_235[df]["binsize"]
    
for df, file in zip(dfs2, file_238):
    path = "/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log"
    filename = os.path.join(path, file)
    #print(filename)
    dfs_238[df] = pd.read_csv(filename, skiprows=6)
    dfs_238[df].drop(dfs_238[df].tail(3).index, inplace=True)
    newdf_238[df] = dfs_238[df].set_axis(['Bin', 'En_lo', 'En_hi', 'Eavg', 'n_MeV_Sr_up', 'Error', 'Tot_Fluence', 'Tot_Err', 'Unnamed'], axis=1, inplace=False)
    newdf_238[df]['En_lo'] = pd.to_numeric(newdf_238[df]['En_lo'],errors='coerce')
    newdf_238[df]['En_hi'] = pd.to_numeric(newdf_238[df]['En_hi'],errors='coerce')
    newdf_238[df]['binsize']  = newdf_238[df]['En_hi'] - newdf_238[df]['En_lo']
    newdf_238[df]["Fluence_cm2"] = newdf_238[df]["Tot_Fluence"]/area 
    #newdf_238[df]['Flu_bin'] = newdf_238[df]["Tot_Fluence"]/newdf_238[df]["binsize"]

df_sum = reduce(pd.DataFrame.add, [newdf_235['df1'], newdf_235['df2'], newdf_235['df3'], newdf_235['df4'], newdf_235['df5'], newdf_235['df6']])
totflu = df_sum["Fluence_cm2"]
binsize = newdf_235['df1']['binsize']
eavg = newdf_235['df1']['Eavg']
tuples = list(zip(binsize, eavg, totflu))
df_fin = pd.DataFrame(data = tuples,columns=['Binsize','Eavg','Sum_Fluence'])
df_fin["Flu_bin"] = df_fin["Sum_Fluence"]/df_fin["Binsize"]

df_sum2 = reduce(pd.DataFrame.add, [newdf_238['df1'], newdf_238['df2'], newdf_238['df3'], newdf_238['df4'], newdf_238['df5'], newdf_238['df6']])
totflu2 = df_sum2["Fluence_cm2"]
binsize2 = newdf_238['df1']['binsize']
eavg2 = newdf_238['df1']['Eavg']
tuples2 = list(zip(binsize2, eavg2, totflu2))
df_fin2 = pd.DataFrame(data = tuples2,columns=['Binsize','Eavg','Sum_Fluence'])
df_fin2["Flu_bin"] = df_fin2["Sum_Fluence"]/df_fin2["Binsize"]

fig, ax = plt.subplots(facecolor=(1, 1, 1))
#df_fin.plot(kind='line', x="Eavg", y="Flu_bin", legend=True, label='235U', figsize=(20,10), logy = True, logx = True, ax = ax)
df_fin2.plot(kind='line', x="Eavg", y="Flu_bin", legend=True, label='238U', figsize=(10,8), logy = True, logx = True, ax = ax)
plt.title(r"$\frac{Total\ Fluence}{Eavg}$ vs. Eavg", fontsize=20)
plt.xlabel('Eavg (MeV)', fontsize=16)
plt.ylabel(r'$\frac{Total\ Fluence \ (\frac{n}{cm^{2}})}{Eavg\ (MeV)}$', fontsize=16)
plt.legend(fontsize=15)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
#fig.savefig('/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/plots/FluenceEnergy_238_newsize.pdf', bbox_inches='tight', dpi=500)



import csv
import pandas as pd 
import os
from itertools import islice
import matplotlib.pyplot as plt
from functools import reduce
import matplotlib.dates as mdates
import pathlib 
import glob
from scipy.interpolate import make_interp_spline
import numpy as np
from matplotlib.lines import Line2D

iceii = 13.87
csm1 = 0.7747
csm2 = 0.6858

board1 = (iceii/(iceii+csm1))**2
board2 = (iceii/(iceii+csm2))**2

calibration = [21492, 21536, 21499, 21551, 21591, 21615]
path = '/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/UMichiganAug2021/2021-08-05_7-53-AM'
filename = os.path.join(path, "Counter-8-5-2021_7-53-15-AM.csv")

df = pd.read_csv(filename, skiprows=7)
df.columns = ['Index', 'Time', 'C1', 'C2', 'C3', 'C4']
df =  df.drop(['Index', 'C3', 'C4'], axis=1)
cal1 = [21492 for num in range(0,671)]
cal2 = [21536 for num in range(671,3084)]
cal3 = [21499 for num in range(3084,9321)]
cal4 = [21551 for num in range(9321,19543)]
cal5 = [21591 for num in range(19543,28146)]
cal6 = [21615 for num in range(28146,30636)]
caltot = cal1 + cal2 + cal3 + cal4 + cal5 + cal6
index = [num for num in range(0, 30636)]

df['calnum'] = caltot 
df['fluence'] = df['C2']*df['calnum']
df['fcsm1'] = df['C2']*df['calnum']*board1
df['fcsm2'] = df['C2']*df['calnum']*board2

df['Time'] =  pd.to_datetime(df['Time'])
df['C2'] = pd.to_numeric(df['C2'],errors='coerce')
df['fluence'] = pd.to_numeric(df['fluence'],errors='coerce')
df['fcsm1'] = pd.to_numeric(df['fcsm1'],errors='coerce')
df['fcsm2'] = pd.to_numeric(df['fcsm2'],errors='coerce')

df['duration'] = pd.to_timedelta(df['Time'] - df['Time'][0]).astype('timedelta64[s]')
df['aveflux'] = df['fluence']/df['duration']
df['aveflux'] = df['aveflux'].fillna(0)
df['fluxb1'] = df['fcsm1']/df['duration']
df['fluxb1'] = df['fluxb1'].fillna(0)
df['fluxb2'] = df['fcsm2']/df['duration']
df['fluxb2'] = df['fluxb2'].fillna(0)
df['index'] = index

df = df.set_index(pd.DatetimeIndex(df['Time']))

df = df.sort_index()
start = df.index[0]
end = df.index[-1]
index_hourly = pd.date_range(start, end, freq='1H')
df_smooth = df.reindex(index = index_hourly).interpolate('polynomial', order=5)
#print('fluence', df['fluence'][-1])
#print('fcsm1', df['fcsm1'][-1])
#print('fcsm2', df['fcsm2'][-1])

#print('flux', df['aveflux'][-1])
#print('fluxb1', df['fluxb1'][-1])
#print('fluxb2', df['fluxb2'][-1])
#print('mean flux', np.mean(df['aveflux']))
#print('mean fluxb1', np.mean(df['fluxb1']))
#print('mean fluxb2', np.mean(df['fluxb2']))


fig3 = plt.figure(figsize=(10,8))
ax3 = fig3.add_subplot(facecolor=(1, 1, 1))
#line2, = ax3.plot(df.index,df['fluxb1'], color="black")
line3, = ax3.plot(df.index, df['fluxb2'], color="black")
#ax3.legend([line3], ['CSM Board 2'])
colors = ['blue', 'magenta', 'red']
linesb = Line2D(range(1), range(1), color="blue", marker='o', markersize=5)
linesm = Line2D(range(1), range(1), color="magenta", marker='o', markersize=5)
linesr = Line2D(range(1), range(1), color="red", marker='o', markersize=5)
linesc = Line2D(range(1), range(1), color="cyan", marker='o', markersize=5)
labels = ['Soft Error', 'SEM Soft Error' 'SEM Hard Error', 'Hard Error']
ax3.legend([line3,linesb, linesc, linesm, linesr], ['CSM Board 2', 'Soft Error', 'SEM Soft Error', 'SEM Hard Error', 'Hard Error'], loc='lower right')

#ax3.legend([line2, line3], ['CSM Board 1', 'CSM Board 2'])
ax3.xaxis.set_major_locator(mdates.HourLocator(interval=12))
ax3.xaxis.set_major_formatter(mdates.DateFormatter('%D %H:%M:%S'))
ax3.xaxis.set_minor_locator(mdates.HourLocator(interval=2))
ax3.tick_params(axis='x', labelrotation = 15)
ax3.set_title("Average Flux vs Time", fontsize=20)
ax3.set_xlabel('Datetime', fontsize=16)
ax3.set_ylabel(r'Average Flux\ $(\frac{n}{cm2*s})$', fontsize=16)
ax3.tick_params(axis='both', which='major', labelsize=14)
ax3.tick_params(axis='both', which='minor', labelsize=12)
ax3.yaxis.offsetText.set_fontsize(20)

#Soft Errors
#ax3.plot(df.index[8556], df['fluxb1'][8556], 'bo')
#ax3.plot(df.index[19214], df['fluxb1'][19214], 'mo')
#ax3.plot(df.index[20596], df['fluxb1'][20596], 'ro')
#ax3.plot(df.index[20648], df['fluxb1'][20648], 'mo')
#ax3.plot(df.index[28456], df['fluxb1'][28456], 'bo')


#Hard Errors
#ax3.plot(df.index[2747],df['fluxb2'][2747], 'mo')
#ax3.plot(df.index[3199], df['fluxb2'][3199], 'mo')
ax3.plot(df.index[9244], df['fluxb2'][9244], 'co')
ax3.plot(df.index[9313], df['fluxb2'][9313], 'ro')
ax3.plot(df.index[9380], df['fluxb2'][9380], 'ro')
ax3.plot(df.index[11967], df['fluxb2'][11967], 'bo')
ax3.plot(df.index[12015], df['fluxb2'][12015], 'bo')
ax3.plot(df.index[12254], df['fluxb2'][12254], 'ro')
ax3.plot(df.index[14657], df['fluxb2'][14657], 'bo')
#ax3.plot(df.index[17202], df['fluxb2'][17202], 'ro')
#ax3.plot(df.index[18045], df['fluxb2'][18045], 'mo') 
ax3.plot(df.index[24066], df['fluxb2'][24066], 'bo') 
ax3.plot(df.index[24499], df['fluxb2'][24499], 'bo')
ax3.plot(df.index[24844], df['fluxb2'][24844], 'bo')
ax3.plot(df.index[25995], df['fluxb2'][25995], 'bo')
ax3.plot(df.index[29818], df['fluxb2'][29818], 'mo')
ax3.plot(df.index[30412], df['fluxb2'][30412], 'mo')
#fig3.savefig('/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/plots/AveFlux_CSM2_dot.pdf', bbox_inches='tight', dpi=500)

#Zoom in for Soft and Hard Errors
fig3a = plt.figure(figsize=(10,8))
ax3a = fig3a.add_subplot(facecolor=(1, 1, 1))
#line2a, = ax3a.plot(df.index[19150:20680],df['fluxb1'][19150:20680], color="black")
line2a, = ax3a.plot(df.index[9000:13000],df['fluxb2'][9000:13000], color="black")
ax3a.legend([line2a, linesb,linesc, linesm, linesr], ['CSM Board 2','Soft Error', 'SEM Soft Error', 'SEM Hard Error', 'Hard Error'], loc='lower right')
#ax3a.xaxis.set_major_locator(mdates.HourLocator(interval=4))
ax3a.xaxis.set_major_formatter(mdates.DateFormatter('%D %H:%M:%S'))
#ax3a.xaxis.set_minor_locator(mdates.HourLocator(interval=1))
ax3a.tick_params(axis='x', labelrotation = 15)
ax3a.set_title("Average Flux vs Time", fontsize=20)
ax3a.set_xlabel('Datetime', fontsize=16)
ax3a.set_ylabel(r'Average Flux\ $(\frac{n}{cm2*s})$', fontsize=16)
ax3a.tick_params(axis='both', which='major', labelsize=14)
ax3a.tick_params(axis='both', which='minor', labelsize=12)
ax3a.yaxis.offsetText.set_fontsize(20)

#Hard Errors Zoomed
ax3a.plot(df.index[9244], df['fluxb2'][9244], 'co')
ax3a.plot(df.index[9313], df['fluxb2'][9313], 'ro')
ax3a.plot(df.index[9380], df['fluxb2'][9380], 'ro')
ax3a.plot(df.index[11967], df['fluxb2'][11967], 'bo')
ax3a.plot(df.index[12015], df['fluxb2'][12015], 'bo')
ax3a.plot(df.index[12254], df['fluxb2'][12254], 'ro')

#Soft Errors Zoomed
#ax3a.plot(df.index[19214], df['fluxb1'][19214], 'mo')
#ax3a.plot(df.index[20596], df['fluxb1'][20596], 'ro')
#ax3a.plot(df.index[20648], df['fluxb1'][20648], 'mo')
#fig3a.savefig('/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/plots/AveFlux_CSM2_dot_zoom.pdf', bbox_inches='tight', dpi=500)


#Fluence plot plus labels 
fig4 = plt.figure(figsize=(20,10))
ax4 = fig4.add_subplot(facecolor=(1, 1, 1))
line4, = ax4.plot(df.index,df['fcsm1'])
line5, = ax4.plot(df.index, df['fcsm2'])
ax4.legend([line4, line5, linesb,linesc, linesm, linesr], ['CSM Board 1', 'CSM Board 2','Soft Error', 'SEM Soft Error', 'SEM Hard Error', 'Hard Error'])
ax4.xaxis.set_major_locator(mdates.HourLocator(interval=12))
ax4.xaxis.set_major_formatter(mdates.DateFormatter('%D %H:%M:%S'))
ax4.xaxis.set_minor_locator(mdates.HourLocator(interval=2))
ax4.tick_params(axis='x', labelrotation = 15)
ax4.set_title("Fluence vs Time", fontsize=20)
ax4.set_xlabel('Datetime', fontsize=16)
ax4.set_ylabel('Fluence (n/cm2)', fontsize=16)
ax4.tick_params(axis='both', which='major', labelsize=14)
ax4.tick_params(axis='both', which='minor', labelsize=12)
ax4.yaxis.offsetText.set_fontsize(20)
ax4.plot(df.index[8556], df['fcsm1'][8556], 'bo')
ax4.plot(df.index[19214], df['fcsm1'][19214], 'mo')
ax4.plot(df.index[20596], df['fcsm1'][20596], 'ro')
ax4.plot(df.index[20648], df['fcsm1'][20648], 'mo')
ax4.plot(df.index[28456], df['fcsm1'][28456], 'bo')

ax4.plot(df.index[9244], df['fcsm2'][9244], 'co')
ax4.plot(df.index[9313], df['fcsm2'][9313], 'ro')
ax4.plot(df.index[9380], df['fcsm2'][9380], 'ro')
ax4.plot(df.index[11967], df['fcsm2'][11967], 'bo')
ax4.plot(df.index[12015], df['fcsm2'][12015], 'bo')
ax4.plot(df.index[12254], df['fcsm2'][12254], 'ro')
ax4.plot(df.index[14657], df['fcsm2'][14657], 'bo')
ax4.plot(df.index[24066], df['fcsm2'][24066], 'bo') 
ax4.plot(df.index[24499], df['fcsm2'][24499], 'bo')
ax4.plot(df.index[24844], df['fcsm2'][24844], 'bo')
ax4.plot(df.index[25995], df['fcsm2'][25995], 'bo')
ax4.plot(df.index[29818], df['fcsm2'][29818], 'mo')
ax4.plot(df.index[30412], df['fcsm2'][30412], 'mo')
#fig4.savefig('/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/plots/Fluence_CSM1_2_dot.pdf', bbox_inches='tight', dpi=500)


fig5 = plt.figure(figsize=(20,10))
ax5 = fig5.add_subplot(facecolor=(1, 1, 1))
line6, = ax5.plot(df.index, df['C2'])
ax5.xaxis.set_major_locator(mdates.HourLocator(interval=12))
ax5.xaxis.set_major_formatter(mdates.DateFormatter('%D %H:%M:%S'))
ax5.xaxis.set_minor_locator(mdates.HourLocator(interval=2))
ax5.tick_params(axis='x', labelrotation = 15)
ax5.set_title("Integrated Fission Count vs Time", fontsize=20)
ax5.set_xlabel('Datetime', fontsize=16)
ax5.set_ylabel('Integrated Fission Count (FP)', fontsize=16)
ax5.tick_params(axis='both', which='major', labelsize=14)
ax5.tick_params(axis='both', which='minor', labelsize=12)
ax5.yaxis.offsetText.set_fontsize(20)
#fig5.savefig('/Users/guhitj/Documents/Michigan/Research/QualTask/beam_log/plots/FissionCount_Int_wider.pdf', bbox_inches='tight', dpi=500)


