import sys
from PyQt5 import QtWidgets, QtCore, QtGui
import numpy as np 
import matplotlib
matplotlib.use("Qt5Agg")
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure 
from matplotlib.animation import FuncAnimation 
import matplotlib.dates as mdates
import datetime
import time 

class MyMplCanvas(FigureCanvas):
    def __init__(self, parent=None, width=5, height=4, dpi=100):
        fig = Figure(figsize=(width,height), dpi=dpi)
        self.axes = fig.add_subplot(111)
        #self.axes.hold(False)
        self.compute_initial_figure()
        FigureCanvas.__init__(self, fig)
        self.setParent(parent)
        print(' canvas good')
    
    def compute_initial_figure(self):
        pass

class AnimationWidget(QtWidgets.QWidget):
    def __init__(self):
        QtWidgets.QWidget.__init__(self)

        vbox = QtWidgets.QVBoxLayout()
        self.canvas = MyMplCanvas(self, width=5, height=4, dpi=100)
        vbox.addWidget(self.canvas)

        hbox = QtWidgets.QHBoxLayout()
        self.start_button = QtWidgets.QPushButton("Start", self)
        self.stop_button = QtWidgets.QPushButton("Stop", self)
        self.start_button.clicked.connect(self.on_start)
        self.stop_button.clicked.connect(self.on_stop)
        hbox.addWidget(self.start_button)
        hbox.addWidget(self.stop_button)
        vbox.addLayout(hbox)
        self.setLayout(vbox)
        
        self.x = [datetime.datetime.now()]
        self.y = []
        self.line, = self.canvas.axes.plot([], [], 'k-', animated=True, color = 'blue')
        print('animation widget good')
        #self.x = np.linspace(0, 5*np.pi, 400)
        #self.p = 0.0
        #self.y = np.sin(self.x + self.p)
        #self.line, = self.canvas.axes.plot(self.x, self.y, animated=True, lw=2) 
        
    
    def init(self):
        self.line.set_data(self.x[:1],self.y[:1])
        self.line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S"))
        print('init good ')
        return self.line, 

    cnt = 0
    def animate(self, args):
        global cnt
        cnt += 1
        print('cnt', cnt)
        print('args0', args[0]) #time
        print('args1', args[1]) #curr
        self.x.append(args[0])
        self.y.append(args[1])
        print('x', self.x)
        print('y', self.y)

        self.xdata = self.x[0:cnt]
        self.ydata = self.y[0:cnt]
        self.ymin = np.min(self.ydata)
        self.ymax = np.max(self.ydata)
        self.axes.set_ylim(self.ymin,self.ymax)

        self.line.set_data(self.xdata, self.ydata)
        self.line.set_color("red")

        self.axes.xaxis.label.set_color('grey')
        self.axes.tick_params(axis='x', colors='grey')
        self.axes.yaxis.label.set_color('grey')
        self.axes.tick_params(axis='y', colors='grey')
        self.axes.relim()
        self.axes.autoscale()
        print('animate good')
        return self.line,

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

        print('frames good')
    #animate.counter = 0

    #def update_line(self, i):
    #    self.p += 0.1
    #    y = np.sin(self.x + self.p)
    #    self.line.set_ydata(y)
    #    return [self.line]

    def on_start(self):
        self.ani = FuncAnimation(self.canvas.figure, self.animate, init_func=self.init, frames=self.frames1, blit=False)
        print('start works')

    def on_stop(self):
        self.ani._stop()
        print('stop works')
        
if __name__ == "__main__":
    qApp = QtWidgets.QApplication(sys.argv)
    aw = AnimationWidget()
    aw.show()
    sys.exit(qApp.exec_())

