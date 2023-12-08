import sys
import os
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *
import functools
import numpy as np
import random as rd
import matplotlib
matplotlib.use("Qt5Agg")
from matplotlib.figure import Figure
from matplotlib import animation
from matplotlib.animation import TimedAnimation, FuncAnimation
from matplotlib.lines import Line2D
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
import matplotlib.dates as mdates
import time
import datetime
import threading
from ps_funcs import comm, PS_on, PS_off, IV_meas

class CustomMainWindow(QMainWindow):
    def __init__(self):
        super(CustomMainWindow, self).__init__()
        # Define the geometry of the main window
        self.setGeometry(300, 300, 800, 400)
        self.setWindowTitle("GUI")
        # Create FRAME_A
        self.FRAME_A = QFrame(self)
        self.FRAME_A.setStyleSheet("QWidget { background-color: %s }" % QColor(210,210,235,255).name())
        self.LAYOUT_A = QGridLayout()
        self.FRAME_A.setLayout(self.LAYOUT_A)
        self.setCentralWidget(self.FRAME_A)
        # Place the matplotlib figure
        self.myFig = CustomFigCanvas()
        self.LAYOUT_A.addWidget(self.myFig, *(0,1))
        # Add the callbackfunc to ..
        #myDataLoop = threading.Thread(name = 'myDataLoop', target = dataSendLoop, daemon = True, args = (self.addData_callbackFunc,))
        #myDataLoop.start()
        self.show()
        return

    #def addData_callbackFunc(self, value):
    #    print("Add data: " + str(value))
    #    self.myFig.addData(value)
    #    return

''' End Class '''


class CustomFigCanvas(FigureCanvas, FuncAnimation):
    def __init__(self):
        #Data
        self.x = [datetime.datetime.now()]
        self.y = []
        #self.addedData = []
        #Window 
        self.fig = Figure(figsize=(6,4), dpi=100)
        self.ax = self.fig.add_subplot(111)
        self.line, = self.ax.plot([],[], 'k-', label = 'Plot', color='blue')

        #Axis Settings 
        self.ax.set_xlabel('Time')
        self.ax.set_xlabel('Current1 (A)')

        FigureCanvas.__init__(self, self.fig)
        FuncAnimation.__init__(self, self.fig, self.animate, init_func=self.init, frames=self.frames1, blit=False)
        #FigureCanvas.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding,QtWidgets.QSizePolicy.Expanding)


    #def addData(self, value):
    #    self.addedData.append(value)
    #    return

    def init(self):
        self.line.set_data(self.x[:1],self.y[:1])
        self.line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S")) #%H:%M:%S
        return self.line,

    def animate(self, args):
        # Args are the incoming value that are animated    
        animation.animate.counter += 1
        i = animation.animate.counter
        win = 60
        imin = max(0, i - win)
        self.x.append(args[0])
        self.y.append(args[1])
        
        self.xdata = self.x[imin:i]
        self.ydata = self.y[imin:i]
        self.ymin = np.min(self.ydata)
        self.ymax = np.max(self.ydata)
        self.ax.set_ylim(self.ymin,self.ymax)
        
        self.line.set_data(self.xdata, self.ydata)
        self.line.set_color("red")

        self.ax.xaxis.label.set_color('grey')
        self.ax.tick_params(axis='x', colors='grey')
        self.ax.yaxis.label.set_color('grey')
        self.ax.tick_params(axis='y', colors='grey')
        self.ax.relim()
        self.ax.autoscale()

        return self.line,

    animation.animate.counter = 0

    def frames1(self):
        # Generate Time Var
        self.target_time = datetime.datetime.now()
        self.orig_time = self.target_time.strftime("%H:%M:%S")
        self.t_orig = time.strptime(self.orig_time, '%H:%M:%S')
        self.secs_orig = datetime.timedelta(hours=self.t_orig.tm_hour,minutes=self.t_orig.tm_min,seconds=self.t_orig.tm_sec).total_seconds()
        print("Orig Time: ", self.orig_time, "Orig Secs: ", self.secs_orig)
        gpib_inst = comm('6')
        ps_on = PS_on()
        while True:
            # Add new time + 60 seconds
            self.volt1, self.volt2, self.curr1, self.curr2 = IV_meas()
            self.volt1 = self.volt1[0]
            self.volt2 = self.volt2[0]
            self.curr1 = self.curr1[0]
            self.curr2 = self.curr2[0]
            
            self.target_time = self.target_time + datetime.timedelta(seconds=60)
            self.newtime = self.target_time.strftime("%H:%M:%S")
            self.t = time.strptime(self.newtime, '%H:%M:%S')
            self.secs = datetime.timedelta(hours=self.t.tm_hour,minutes=self.t.tm_min,seconds=self.t.tm_sec).total_seconds()
            self.diff = self.secs - self.secs_orig
            #print(newtime, secs, diff)
            self.x = self.target_time
            #x = diff
            self.y = self.curr1
            #y = random.randint(250,450)/10
            yield (self.x,self.y)
            #time.sleep(random.randint(2,5))
            time.sleep(0.1)
'''
class Communicate(QObject):
    data_signal = pyqtSignal(float)

    #End Class

def dataSendLoop(addData_callbackFunc):
    mySrc = Communicate()
    mySrc.data_signal.connect(addData_callbackFunc)

    gpib_inst = comm('6')
    ps_on = PS_on()

    while True:
        volt1, volt2, curr1, curr2 = IV_meas()
        volt1 = volt1[0]
        volt2 = volt2[0]
        curr1 = curr1[0]
        curr2 = curr2[0]
        time.sleep(0.1)
        mySrc.data_signal.emit(curr1)
'''

if __name__ == "__main__":
    app = QApplication(sys.argv)
    QApplication.setStyle(QStyleFactory.create('Plastique'))
    myGUI = CustomFigCanvas() #CustomMainWindow()
    myGUI.show()
    sys.exit(app.exec_())
