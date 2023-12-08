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
from matplotlib.animation import TimedAnimation, FuncAnimation
from matplotlib.lines import Line2D
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
import time
import datetime
import threading
from ps_funcs import comm, PS_on, PS_off, IV_meas

class CustomMainWindow(QMainWindow):
    def __init__(self):
        super(CustomMainWindow, self).__init__()
        # Define the geometry of the main window
        self.setGeometry(300, 300, 800, 400)
        self.setWindowTitle("my first window")
        # Create FRAME_A
        self.FRAME_A = QFrame(self)
        self.FRAME_A.setStyleSheet("QWidget { background-color: %s }" % QColor(210,210,235,255).name())
        self.LAYOUT_A = QGridLayout()
        self.FRAME_A.setLayout(self.LAYOUT_A)
        self.setCentralWidget(self.FRAME_A)
        # Place the zoom button
        #self.zoomBtn = QPushButton(text = 'zoom')
        #self.zoomBtn.setFixedSize(100, 50)
        #self.zoomBtn.clicked.connect(self.zoomBtnAction)
        #self.LAYOUT_A.addWidget(self.zoomBtn, *(0,0))
        # Place the matplotlib figure
        self.myFig = CustomFigCanvas()
        self.LAYOUT_A.addWidget(self.myFig, *(0,1))
        # Add the callbackfunc to ..
        myDataLoop = threading.Thread(name = 'myDataLoop', target = dataSendLoop, daemon = True, args = (self.addData_callbackFunc,))
        myDataLoop.start()
        self.show()
        return

    #def zoomBtnAction(self):
    #    print("zoom in")
    #    self.myFig.zoomIn(5)
    #    return

    def addData_callbackFunc(self, value):
        print("Add data: " + str(value))
        self.myFig.addData(value)
        return

''' End Class '''


class CustomFigCanvas(FigureCanvas, TimedAnimation): #check this out next
    def __init__(self):
        self.addedData = []
        self.time = [datetime.datetime.now()]
        #create a timr counterpart
        #print(matplotlib.__version__)
        # The data
        #self.xlim = 100
        #self.start_time = time.time()
        #self.n = np.linspace(0, self.xlim - 1, self.xlim)
        #a = []
        #b = []
        #a.append(2.0)
        #a.append(4.0)
        #a.append(2.0)
        #b.append(4.0)
        #b.append(3.0)
        #b.append(4.0)
        self.y = (self.n * 0.0) + 50
        # The window
        self.fig = Figure(figsize=(5,5), dpi=100)
        self.ax1 = self.fig.add_subplot(111)
        # self.ax1 settings
        self.ax1.set_xlabel('time')
        self.ax1.set_ylabel('current1 (A)') #change to current1, current2, voltage1, voltage2
        self.line1, = self.ax1.plot([],[], 'k-', label = 'Current', color = 'blue')
        #self.line1 = Line2D([], [], color='blue')
        #self.line1_tail = Line2D([], [], color='red', linewidth=2)
        #self.line1_head = Line2D([], [], color='red', marker='o', markeredgecolor='r')
        #self.ax1.add_line(self.line1)
        #self.ax1.add_line(self.line1_tail)
        #self.ax1.add_line(self.line1_head)
        #self.ax1.autoscale()
        #self.ax1.set_xlim(0, self.xlim - 1) #self.xlim - 1
        #self.ymin = np.min(i for i in range(self.addedData))
        #self.ymax = np.max(j for j in range(self.addedData))
        #self.ax1.set_ylim(ymin, ymax)
        #self.ax1.set_ylim(-5e-05, 10e-05) #0,100
        FigureCanvas.__init__(self, self.fig)
        #TimedAnimation.__init__(self, self.fig, interval = 5, blit = True) #interval = 50
        FuncAnimation.__init__(self, self.fig, self.animate, init_function=self.init, frames=self.frames1, blit=False)
        return

    #def new_frame_seq(self):
    #    return iter(range(self.n.size))

    #def _init_draw(self):
    #    lines = [self.line1, self.line1_tail, self.line1_head]
    #    for l in lines:
    #        l.set_data([], [])
    #    return

    def addData(self, value):
        self.addedData.append(value)
        return

    #def zoomIn(self, value):
    #    bottom = self.ax1.get_ylim()[0]
    #    top = self.ax1.get_ylim()[1]
    #    bottom += value
    #    top -= value
    #    self.ax1.set_ylim(bottom,top)
    #    self.draw()
    #    return

    def _step(self, *args):
        # Extends the _step() method for the TimedAnimation class.
        try:
            TimedAnimation._step(self, *args)
        except Exception as e:
            self.abc += 1
            print(str(self.abc))
            TimedAnimation._stop(self)
            pass
        return

    def _draw_frame(self, framedata):
        margin = 2
        while(len(self.addedData) > 0):
            self.y = np.roll(self.y, -1)
            self.y[-1] = self.addedData[0]
            del(self.addedData[0])

        self.line1.set_data(self.n[ 0 : self.n.size - margin ], self.y[ 0 : self.n.size - margin ])
        self.line1_tail.set_data(np.append(self.n[-10:-1 - margin], self.n[-1 - margin]), np.append(self.y[-10:-1 - margin], self.y[-1 - margin]))
        self.line1_head.set_data(self.n[-1 - margin], self.y[-1 - margin])
        self._drawn_artists = [self.line1, self.line1_tail, self.line1_head]
        return

''' End Class '''


# You need to setup a signal slot mechanism, to
# send data to your GUI in a thread-safe way.
# Believe me, if you don't do this right, things
# go very very wrong..
class Communicate(QObject):
    data_signal = pyqtSignal(float)

''' End Class '''



def dataSendLoop(addData_callbackFunc):
    # Setup the signal-slot mechanism.
    mySrc = Communicate()
    mySrc.data_signal.connect(addData_callbackFunc)

    gpib_inst = comm('6')
    ps_on = PS_on()
    #volt1, volt2, curr1, curr2 = IV_meas()
    #volt1 = volt1[0]
    #volt2 = volt2[0]
    #curr1 = curr1[0]
    #curr2 = curr2[0]
    #y.append(curr1) 
    #print(volt1, curr1)
    #print(volt2, curr2)
    #i = 0
    while True:
    #    if (i > 499):
    #        i = 0
    #    time.sleep(0.1)
        volt1, volt2, curr1, curr2 = IV_meas()
        volt1 = volt1[0]
        volt2 = volt2[0]
        curr1 = curr1[0]
        curr2 = curr2[0]
        time.sleep(0.1)
        mySrc.data_signal.emit(curr1)
    #    i += 1

    # Simulate some data
    #n = np.linspace(0, 499, 500)
    #y = 50 + 25*(np.sin(n / 8.3)) + 10*(np.sin(n / 7.5)) - 5*(np.sin(n / 1.5))
    #i = 0

    #while(True):
    #    if(i > 499):
    #        i = 0
    #    time.sleep(0.1)
    #    mySrc.data_signal.emit(y[i]) # <- Here you emit a signal!
    #    i += 1
    ###
###

if __name__== '__main__':
    app = QApplication(sys.argv)
    QApplication.setStyle(QStyleFactory.create('Plastique'))
    myGUI = CustomMainWindow()
    sys.exit(app.exec_())
