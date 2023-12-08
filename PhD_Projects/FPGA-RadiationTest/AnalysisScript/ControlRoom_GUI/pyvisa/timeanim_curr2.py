import random
import time
from matplotlib import pyplot as plt
import matplotlib.dates as mdates
from matplotlib import animation
import datetime
from ps_funcs import comm, PS_on, PS_off, IV_meas
import numpy as np 

# Plot parameters
fig, ax = plt.subplots(figsize=(10,6))
line, = ax.plot([], [], 'k-', label = 'Current', color = 'blue')
legend = ax.legend(loc='upper right',frameon=False)
plt.setp(legend.get_texts(), color='grey')
ax.margins(0.05)
#ax.grid(True, which='both', color = 'grey')
# Creating data variables
x = [datetime.datetime.now()]
#y = [1]
y = []

def init():
    line.set_data(x[:1],y[:1])
    line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S")) #%H:%M:%S
    return line,

#animate.counter = 0 
cnt = 0
def animate(args):
    # Args are the incoming value that are animated    
    #animate.counter = 0
    #animate.counter += 1
    #print('animate.counter', animate.counter)
    global cnt 
    cnt += 1
    print('cnt', cnt)
    #i = animate.counter
    #print('i', i)
    #win = 10
    #imin = max(0, i - win) #make sure that imin ==0
    #print('imin', imin)
    print('args0', args[0]) #time
    print('args1', args[1]) #curr
    x.append(args[0])
    y.append(args[1])
    print('x', x)
    print('y', y)

    #xdata = x[imin:i]
    #ydata = y[imin:i]
    xdata = x[0:cnt]
    ydata = y[0:cnt]
    print('xdata', xdata)
    print('ydata', ydata)

    ymin = np.min(ydata)
    ymax = np.max(ydata)
    ax.set_ylim(ymin,ymax)
    
    line.set_data(xdata, ydata)
    line.set_color("red")

    plt.title('Power Supply', color = 'grey')
    plt.ylabel("Current1 (A)", color ='grey')
    plt.xlabel("Time", color = 'grey')

    #ax.set_facecolor('black')
    ax.xaxis.label.set_color('grey')
    ax.tick_params(axis='x', colors='grey')
    ax.yaxis.label.set_color('grey')
    ax.tick_params(axis='y', colors='grey')

    ax.relim()
    ax.autoscale()

    return line,

#animate.counter = 0

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
        #x = diff
        y = curr2
        #y = random.randint(250,450)/10
        yield (x,y)  
        #time.sleep(random.randint(2,5))
        time.sleep(0.1)

anim = animation.FuncAnimation(fig, animate,init_func=init,frames=frames1, blit=False)

plt.show()
