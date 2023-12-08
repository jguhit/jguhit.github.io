from PyQt5.QtWidgets import * 
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5 import QtWidgets, QtCore 
from PyQt5.QtWidgets import QApplication, QMainWindow
from pyqtgraph import PlotWidget, plot, mkPen
import pyqtgraph as pg
import sys
import os 
from ps_funcs import comm, PS_on, PS_off, IV_meas
import datetime 
import time 
#from matplotlib.backends.qt_compat import QtCore, QtWidgets 
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from  matplotlib.figure import Figure 
from  matplotlib.animation import FuncAnimation
import matplotlib.dates as mdates
import matplotlib.pyplot as plt 
import numpy as np
import threading 
import traceback
import csv 

class Worker(QObject):
    finished = pyqtSignal()
    error = pyqtSignal(tuple)
    result = pyqtSignal(object)  
    data_signal = pyqtSignal(float, float, float, float) 
    timeChangeSec = pyqtSignal(int)
    timeChangeDate = pyqtSignal(object) 
    all_data = pyqtSignal(float, float, float, float, int, object) 

    def __init__(self, MyWindow):
        super(Worker, self).__init__()
        self.MyWindow = MyWindow 
        self.MyWindow.processing = True

    def run(self):
        self.MyWindow.time_last = 0
        time_accu = self.MyWindow.time_total 
        print("Start Monitoring")
        start = time.time()
        self.ON = PS_on()
        print("Power Supply is on")
        print("Generating Time Variable")
        self.target_time = datetime.datetime.now()
        while self.MyWindow.processing: 
            self.target_time = self.target_time + datetime.timedelta(seconds=60)
            self.data = IV_meas()
            #print("Volt1: " + str(self.data[0][0]))
            #print("Volt2: " + str(self.data[1][0]))
            #print("Curr1: " + str(self.data[2][0]))
            #print("Curr2: " + str(self.data[3][0]))
            #print("Time: " + str(self.target_time))
            #print(type(self.target_time))
            time.sleep(0.1)
            self.timeChangeDate.emit(self.target_time)
            self.data_signal.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
            self.MyWindow.label4.setText("%.5f"%(self.data[0][0]))
            self.MyWindow.label5.setText("%.5f"%(self.data[1][0]))
            self.MyWindow.label6.setText("%.5f"%(self.data[2][0]))
            self.MyWindow.label7.setText("%.5f"%(self.data[3][0]))
            end = time.time()
            self.MyWindow.time_last = end - start 
            #print(type(self.MyWindow.time_last))
            self.timeChangeSec.emit(int(self.MyWindow.time_last))
            self.all_data.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0], int(self.MyWindow.time_last), self.target_time)
            self.MyWindow.time_total = time_accu + self.MyWindow.time_last 

        print("End Monitoring")
        print("Monitoring Time: " + str(end-start))
        self.finished.emit()
        return #self.data[0][0], self.data[1][0], self.data[2][0]. self.data[3][0]

    def stop(self):
        self.MyWindow.processing = False

class MyWindow(QMainWindow): 
    def __init__(self, *args, **kwargs): 
        super(MyWindow, self).__init__(*args, **kwargs)
        #self.setGeometry(300,300,550,400) #200,250,1500,700
        #self.setWindowTitle("GUI")
        self.setObjectName("GUI") 
        self.resize(1500,800)
        self.time_total = 0
        self.time_last = 0
        self.processing = False 

        self.initUI()
        self.thread = QThread()
        self.worker = Worker(self)
        return 
    
    def initUI(self):

        self.volt1 = []
        self.volt2 = []
        self.curr1 = []
        self.curr2 = []
        self.time = []
        self.date = []

        #layout
        self.layoutWidget = QtWidgets.QWidget(self)
        self.layoutWidget.setGeometry(QtCore.QRect(50,120,300,200))
        self.layout = QtWidgets.QVBoxLayout(self.layoutWidget)

        self.layoutWidget2 = QtWidgets.QWidget(self)
        self.layoutWidget2.setGeometry(QtCore.QRect(250,120,300,200))
        self.layout2 = QtWidgets.QVBoxLayout(self.layoutWidget2)

        self.layoutWidget3 = QtWidgets.QWidget(self)
        self.layoutWidget3.setGeometry(QtCore.QRect(100,0,200,150))
        self.layout3 = QtWidgets.QVBoxLayout(self.layoutWidget3)

        self.layoutWidget4 = QtWidgets.QWidget(self)
        self.layoutWidget4.setGeometry(QtCore.QRect(20,270,150,150))
        self.layout4 = QtWidgets.QVBoxLayout(self.layoutWidget4)

        self.layoutWidget5 = QtWidgets.QWidget(self)
        self.layoutWidget5.setGeometry(QtCore.QRect(220,270,150,150))
        self.layout5 = QtWidgets.QVBoxLayout(self.layoutWidget5)

        self.layoutWidget6 = QtWidgets.QWidget(self)
        self.layoutWidget6.setGeometry(QtCore.QRect(400, 40, 500, 350))
        self.layout6 = QtWidgets.QHBoxLayout(self.layoutWidget6)

        self.layoutWidget7 = QtWidgets.QWidget(self)
        self.layoutWidget7.setGeometry(QtCore.QRect(900, 40, 500, 350))
        self.layout7 = QtWidgets.QHBoxLayout(self.layoutWidget7)

        self.layoutWidget8 = QtWidgets.QWidget(self)
        self.layoutWidget8.setGeometry(QtCore.QRect(400, 400, 500, 350))
        self.layout8 = QtWidgets.QHBoxLayout(self.layoutWidget8)

        self.layoutWidget9 = QtWidgets.QWidget(self)
        self.layoutWidget9.setGeometry(QtCore.QRect(900, 400, 500, 350))
        self.layout9 = QtWidgets.QHBoxLayout(self.layoutWidget9)

        #labels
        self.label = QtWidgets.QLabel(self.layoutWidget)
        self.label.setText("Voltage1 (V):")
        self.label.setFont(QFont('Arial', 10))
        #self.label.setGeometry(100, 100, 150, 40) #50,100,150,40
        self.layout.addWidget(self.label)

        self.label1 = QtWidgets.QLabel(self.layoutWidget)
        self.label1.setText("Voltage2 (V):")
        #self.label1.setGeometry(100, 130, 150, 40) #100,130,150,40
        self.layout.addWidget(self.label1)

        self.label2 = QtWidgets.QLabel(self.layoutWidget)
        self.label2.setText("Current1 (A):")
        #self.label2.setGeometry(100, 160, 150, 40) #50,160,150,40
        self.layout.addWidget(self.label2)

        self.label3 = QtWidgets.QLabel(self.layoutWidget)
        self.label3.setText("Current2 (A):")
        #self.label3.setGeometry(100, 190, 150, 40) #50,190,150,40
        self.layout.addWidget(self.label3)

        #labels that needs to read IV data
        self.label4 = QtWidgets.QLabel(self.layoutWidget2)
        self.label4.setText("-")
        #self.label4.setGeometry(300, 100, 150, 40) #220,100,150,40
        self.layout2.addWidget(self.label4)

        self.label5 = QtWidgets.QLabel(self.layoutWidget2)
        self.label5.setText("-")
        #self.label5.setGeometry(300, 130, 150, 40) #220,130,150,40
        self.layout2.addWidget(self.label5)

        self.label6 = QtWidgets.QLabel(self.layoutWidget2)
        self.label6.setText("-")
        #self.label6.setGeometry(300, 160, 150, 40) #220,160,150,40
        self.layout2.addWidget(self.label6)

        self.label7 = QtWidgets.QLabel(self.layoutWidget2)
        self.label7.setText("-")
        #self.label7.setGeometry(300, 190, 150, 40) #220,190,150,40
        self.layout2.addWidget(self.label7)

        #pushbutton ps
        self.b1 = QtWidgets.QPushButton(self.layoutWidget3)
        self.b1.setText("Init Power Supply")
        #self.b1.setGeometry(180,40,200,40) #130,40,200,40
        self.layout3.addWidget(self.b1)
        self.b1.clicked.connect(self.gpib)

        self.b2 = QtWidgets.QPushButton(self.layoutWidget4)
        self.b2.setText("ON")
        #self.b2.setGeometry(100,250,150,40) #50,250,150,40
        self.layout4.addWidget(self.b2)
        self.b2.clicked.connect(self.pwr_on)

        self.b3 = QtWidgets.QPushButton(self.layoutWidget5)
        self.b3.setText("OFF")
        #self.b3.setGeometry(300,250,150,40) #250,250,150,40
        self.layout5.addWidget(self.b3)
        self.b3.clicked.connect(self.pwr_off)

        #pyqtgraph
        self.graphWidget = pg.PlotWidget()
        self.pen = pg.mkPen(color="k", width=3)
        self.layout6.addWidget(self.graphWidget)
        self.graphWidget.setBackground('w')
        self.graphWidget.setTitle("Volt1 vs Time (sec)", color="b", size="10pt")
        self.graphWidget.setLabel('left', 'Volt1 (V)', color="r", size="5pt")
        self.graphWidget.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget.showGrid(x=True, y=True)

        self.graphWidget1 = pg.PlotWidget()
        self.layout7.addWidget(self.graphWidget1)
        self.graphWidget1.setBackground('w')
        self.graphWidget1.setTitle("Volt2 vs Time (sec)", color="b", size="10pt")
        self.graphWidget1.setTitle("Volt2 vs Time(sec)", color="b", size="10pt")
        self.graphWidget1.setLabel('left', 'Volt2 (V)', color="r", size="5pt")
        self.graphWidget1.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget1.showGrid(x=True, y=True)
        
        self.graphWidget2 = pg.PlotWidget()
        self.layout8.addWidget(self.graphWidget2)
        self.graphWidget2.setBackground('w')
        self.graphWidget2.setTitle("Curr1 vs Time (sec)", color="b", size="10pt")
        self.graphWidget2.setTitle("Curr1 vs Time(sec)", color="b", size="10pt")
        self.graphWidget2.setLabel('left', 'Curr1 (A)', color="r", size="5pt")
        self.graphWidget2.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget2.showGrid(x=True, y=True)

        self.graphWidget3 = pg.PlotWidget()
        self.layout9.addWidget(self.graphWidget3)
        self.graphWidget3.setBackground('w')
        self.graphWidget3.setTitle("Curr2 vs Time (sec)", color="b", size="10pt")
        self.graphWidget3.setTitle("Curr2 vs Time(sec)", color="b", size="10pt")
        self.graphWidget3.setLabel('left', 'Curr2 (A)', color="r", size="5pt")
        self.graphWidget3.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget3.showGrid(x=True, y=True)

        #self.timer = QtCore.QTimer()
        #self.timer.setInterval(50)
        #self.timer.timeout.connect(self.update_plot_data)
        #self.timer.start()

    def gpib(self, addr): # dont know if it works yet 
        self.gpib_inst = comm('5')
        print("Power supply connected to GPIB")
        with open('PS_log.txt', "a") as f:
            d = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
            f.close()

    def pwr_on(self):
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.worker.data_signal.connect(self.get_data)
        self.worker.timeChangeSec.connect(self.get_time) 
        self.worker.timeChangeDate.connect(self.get_date)
        self.worker.all_data.connect(self.graph)
        self.thread.start()
        self.b2.setEnabled(False)
        self.thread.finished.connect(lambda: self.b2.setEnabled(True))
        self.thread.finished.connect(self.pwr_off)
        with open('PS_log.txt', "a") as f:
            d1 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            f.write("%s %s" %(d1, "Power Supply ON") + '\n')
            f.close()
        return

    def get_data(self,d1,d2,d3,d4):
        pass
        #self.volt1.append(d1)
        #self.volt2.append(d2)
        #self.curr1.append(d3)
        #self.curr2.append(d4)
        #print(self.volt1)
        return #self.volt1, self.volt2, self.curr1, self.curr2

    def get_time(self, t):
        pass
        #self.time.append(t)
        #print('Get time: ', self.time)
        return #self.time 


    def get_date(self, d):
        pass
        #self.date.append(d)
        #print('Get date: ', self.date)
        return #self.date

    def graph(self, f1, f2, f3, f4, i1, obj1):
        print("Get Data")
        #print(f1,f2, f3, f4, i1, obj1)
        self.volt1.append(f1)
        self.volt2.append(f2)
        self.curr1.append(f3)
        self.curr2.append(f4)
        self.time.append(i1)
        self.date.append(obj1)
        
        self.data_line =  self.graphWidget.plot(self.time, self.volt1, pen = self.pen)
        self.data_line1 = self.graphWidget1.plot(self.time, self.volt2, pen = self.pen)
        self.data_line2 = self.graphWidget2.plot(self.time, self.curr1, pen = self.pen)
        self.data_line3 = self.graphWidget3.plot(self.time, self.curr2, pen = self.pen)
        
        d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        with open('PS_IVdata.csv', 'a') as csv_file:
            fieldnames = ['DateTime','Time_S', 'Volt1_V', 'Volt2_V', 'Curr1_A', 'Curr2_A']
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

            writer.writeheader()
            writer.writerow({'DateTime': d2, 'Time_S': str(i1), 'Volt1_V': str(f1), 'Volt2_V': str(f2), 'Curr1_A': str(f3), 'Curr2_A': str(f4)})

        with open('PS_log.txt', "a") as f:
            #d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            f.write("%s %s" %(d2, "Get IV Data") + '\n')
            f.write("%s %s %s" % (d2, "Volt1 (V): ", str(f1) +  '\n'))
            f.write("%s %s %s" % (d2, "Volt2 (V): ", str(f2) + '\n'))
            f.write("%s %s %s" % (d2, "Curr1 (A): ", str(f3) + '\n'))
            f.write("%s %s %s" % (d2, "Curr2 (A): ", str(f4) + '\n'))
            f.write("%s %s %s" % (d2, "Time (Sec): ", str(i1) + '\n'))
            #f.write("%s %s %s" % (d2, "Date: ", str(obj1) + '\n' ))
            f.close()


        return self.data_line, self.data_line1, self.data_line2, self.data_line3 
        #print(self.volt1)
        #print(self.time)

    #def update_plot_data(self):
    #    if len(self.volt1) > 5:
    #        self.timer.start()
    #        self.volt1 = self.volt1[1:]
    #        self.volt1.append(self.volt1[-1])
    #        print(self.volt1)
    #        self.time = self.time[1:]
    #        self.time.append(self.time[-1] + 1)
    #        print(self.time)
    #        self.graphWidget.clear()
    #        self.data_line.setData(self.time, self.volt1)
    
    def pwr_off(self):
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
        self.OFF = PS_off()
        print("Power Supply OFF")
        self.result = IV_meas()
        self.label4.setText("%.5f"%(self.result[0]))
        self.label5.setText("%.5f"%(self.result[1]))
        self.label6.setText("%.5f"%(self.result[2]))
        self.label7.setText("%.5f"%(self.result[3]))
        with open('PS_log.txt', "a") as f:
            d3 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
            f.write("%s %s" % (d3, "Power Supply OFF") + '\n')
            f.close()
        return 
    
    def update(self):
        self.label4.adjustSize()
        self.label5.adjustSize()
        self.label6.adjustSize()
        self.label7.adjustSize()


#class MyFigureCanvas(FigureCanvas, FuncAnimation):
    #def __init__(self, f1=self.MyWindow.volt1, f2=self.MyWindow.volt2, f3=self.MyWindow.curr1, f4=self.MyWindow.curr2, i1=self.MyWindow.time, obj1=self.MyWindow.date):
    #def __init__(self, win):
        #super(MyFigureCanvas, self).__init__()
        #self.cnt = 0
        #self.win = win
        #self.cnt = 0
        #self.v1 = self.MyWindow.volt1
        #self.v2 = self.MyWindow.volt2
        #self.i1 = self.MyWindow.curr1
        #self.i2 = self.MyWindow.curr2
        #3self.t1 = self.MyWindow.time 
        #self.obj1 = self.MyWindow.date

        #self.fig = Figure(figsize=(8,5), dpi=100)
        #self.ax1 = self.fig.add_subplot(111)
        #self.ax1.set_xlabel('Time')
        #self.ax1.set_ylabel('Volt1 (V)')
        #self.line, = self.ax1.plot([],[], 'k-', label='Voltage 1')

        #FigureCanvas.__init__(self, self.fig)
        #FuncAnimation.__init__(self, self.fig, animate, self, init_func = self.init, blit=False) #init_func = self.init #frames=frames1
        #return
    
    #def init(self):
        #self.line.set_data(self.win.time[:1], self.win.volt1[:1])
        #print('ok')
        #self.line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S"))
        #print('ok')
        #return self.line, 

    #cnt = 0
#def animate(args): #args
    #win = args[0]
    #print('f1', win.volt1)
    #print('obj1', win.time)
    #return
        #global cnt 
        #cnt += 1
        #print('cnt', cnt)
        #print(args[0])
        #print('f1', self.win.volt1)
        #print('obj1', self.win.time)

        #self.xdata = self.win.time[0:cnt]
        #self.volt1_data = self.win.volt1[0:cnt]
        #print('xdata', self.xdata)
        #print('volt1', self.volt1_data)

        #self.volt1min = np.min(self.volt1_data)
        #self.volt1max = np.max(self.volt1_data)
        #self.ax1.set_ylim(self.volt1min, self.volt1max)

        #self.line.set_data(self.xdata, self.volt1_data)
        #self.line.set_color('red')

        #self.ax1.relim()
        #self.ax1.autoscale()

        #return #self.line, 

    #def frames1(self):
    #    self.target_time = datetime.datetime.now()
    #    self.orig_time = self.target_time.strftime("%H:%M:%S")
    #    self.t_orig = time.strptime(self.orig_time, "%H:%M:%S")
    #    self.secs_orig = datetime.timedelta(hours=t_org.tm_hour, minutes=t_orig.tm_min, seconds=t_orig.tm_sec).total_seconds()
    #    yield(self.time, self.volt1)
        #print(self.volt1)         
    


def window():
    app = QApplication(sys.argv)
    win = MyWindow()
    win.show()
    sys.exit(app.exec_())

window()

