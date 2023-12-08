import random
import time
from matplotlib import pyplot as plt
import matplotlib.dates as mdates
from matplotlib import animation
import datetime
from ps_funcs import comm, PS_on, PS_off, IV_meas
import numpy as np 

# Plot parameters
#fig = plt.figure(figsize = (8,6), dpi = 100)
fig, ax = plt.subplots(nrows=2, ncols=2, figsize = (20,10)) #fig, 
fig.tight_layout(pad=3.0)
line, = ax[0,0].plot([], [], 'k-', label = 'Current', color = 'blue')
line1, = ax[0,1].plot([], [], 'k-', label = 'Current', color = 'blue')

legend = ax[0,0].legend(loc='upper right',frameon=False)
legend1 = ax[0,1].legend(loc='upper right',frameon=False)

plt.setp(legend.get_texts(), color='grey')
plt.setp(legend1.get_texts(), color='grey')

ax[0,0].margins(0.05)
ax[0,1].margins(0.05)

#ax.grid(True, which='both', color = 'grey')
# Creating data variables
#ax[0,0]
x = [datetime.datetime.now()]
y = []
#y = [1]
#ax[0,1]
x1 = [datetime.datetime.now()]
y1 = []

def init():
    line.set_data(x[:1],y[:1])
    line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S")) #%H:%M:%S
    line1.set_data(x1[:1],y1[:1])
    line1.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S"))
    return line, line1,

def animate(args):
    # Args are the incoming value that are animated    
    animate.counter += 1
    i = animate.counter
    win = 60
    imin = max(0, i - win)
    x.append(args[0])
    y.append(args[1])
    x1.append(args[0])
    y1.append(args[1])

    xdata = x[imin:i]
    ydata = y[imin:i]
    xdata1 = x1[imin:i]
    ydata1 = y1[imin:i]

    ymin = np.min(ydata)
    ymax = np.max(ydata)
    ymin1 = np.min(ydata1)
    ymax1 = np.max(ydata1)

    ax[0,0].set_ylim(ymin,ymax)
    ax[0,1].set_ylim(ymin1, ymax1)

    line.set_data(xdata, ydata)
    line.set_color("red")
    line1.set_data(xdata1, ydata1)
    line1.set_color("red")

    #plt.title('Power Supply', color = 'grey')
    #plt.ylabel("Current1 (A)", color ='grey')
    #plt.xlabel("Time", color = 'grey')

    #ax.set_facecolor('black')
    ax[0,0].xaxis.label.set_color('grey')
    ax[0,0].tick_params(axis='x', colors='grey')
    ax[0,0].yaxis.label.set_color('grey')
    ax[0,0].tick_params(axis='y', colors='grey')
    ax[0,0].set_ylabel('Current 1 (A)')
    ax[0,0].set_xlabel('Time')
    ax[0,0].relim()
    ax[0,0].autoscale()

    ax[0,1].xaxis.label.set_color('grey')
    ax[0,1].tick_params(axis='x1', colors='grey')
    ax[0,1].yaxis.label.set_color('grey')
    ax[0,1].tick_params(axis='y1', colors='grey')
    ax[0,1].set_ylabel('Current 2 (A)')
    ax[0,1].set_xlabel('Time')
    ax[0,1].relim()
    ax[0,1].autoscale()

    return line, line1,

animate.counter = 0

def frames1():
    # Generating time variable
    target_time = datetime.datetime.now()
    orig_time = target_time.strftime("%H:%M:%S")
    t_orig = time.strptime(orig_time, '%H:%M:%S')
    secs_orig = datetime.timedelta(hours=t_orig.tm_hour,minutes=t_orig.tm_min,seconds=t_orig.tm_sec).total_seconds()
    print("Orig Time: ", orig_time, "Orig Secs: ", secs_orig)
    gpib_inst = comm('6')
    ps_on = PS_on()
    while True:
        # Add new time + 60 seconds
        volt1, volt2, curr1, curr2 = IV_meas()
        volt1 = volt1[0]
        volt2 = volt2[0]
        curr1 = curr1[0]
        curr2 = curr2[0]
        target_time = target_time + datetime.timedelta(seconds=60)
        newtime = target_time.strftime("%H:%M:%S")
        t = time.strptime(newtime, '%H:%M:%S')
        secs = datetime.timedelta(hours=t.tm_hour,minutes=t.tm_min,seconds=t.tm_sec).total_seconds()
        diff = secs - secs_orig
        #print(newtime, secs, diff)
        x = target_time
        x1 = target_time
        y = curr1
        y1  = curr2
        print(y,y1)
        yield (x,y)  
        yield (x1,y1)
        time.sleep(0.1)

anim = animation.FuncAnimation(fig, animate,init_func=init,frames=frames1, blit=False)

plt.show()
