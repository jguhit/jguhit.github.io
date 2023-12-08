from PyQt5.QtWidgets import * 
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5 import QtWidgets, QtCore 
from PyQt5.QtWidgets import QApplication, QMainWindow
#from pyqtgraph import PlotWidget, plot
# import pyqtgraph as pg
import sys
import os 
from ps_funcs_ind import comm, comm1, comm2, PS_on, PS_on1, PS_on2, PS_off, PS_off1, PS_off2, IV_meas, IV_meas_1, IV_meas_2 
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


class Worker(QObject):
    finished = pyqtSignal()
    error = pyqtSignal(tuple)
    result = pyqtSignal(object)  
    data_signal = pyqtSignal(float, float, float, float) 
    data_signal1 = pyqtSignal(float, float, float, float)
    data_signal2 = pyqtSignal(float, float) 
    timeChangeSec = pyqtSignal(int)
    timeChangeSec1 = pyqtSignal(int)
    timeChangeSec2 = pyqtSignal(int)
    timeChangeDate = pyqtSignal(object) 
    timeChangeDate1 = pyqtSignal(object)
    timeChangeDate2 = pyqtSignal(object) 
    all_data = pyqtSignal(float, float, float, float, int, object) 
    all_data1 = pyqtSignal(float, float, float, float, int, object)
    all_data2 = pyqtSignal(float, float, int, object) 

    def __init__(self, MyWindow): #number
        super(Worker, self).__init__()
        self.MyWindow = MyWindow 
        self.MyWindow.processing = True
        #self.number = number

    def run(self): 
        self.MyWindow.time_last = 0
        time_accu = self.MyWindow.time_total 
        print("Start Monitoring")
        start = time.time()
        #self.ON = PS_on()
        print("Power Supply is on")
        print("Generating Time Variable")
        self.target_time = datetime.datetime.now()
        while self.MyWindow.processing: 
            self.target_time = self.target_time + datetime.timedelta(seconds=60)
            self.data = IV_meas()
            print("Volt1: " + str(self.data[0][0]))
            print("Volt2: " + str(self.data[1][0]))
            print("Curr1: " + str(self.data[2][0]))
            print("Curr2: " + str(self.data[3][0]))
            print("Time: " + str(self.target_time))
            time.sleep(0.1)
            #self.timeChangeDate.emit(self.target_time)
            #self.data_signal.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
            self.MyWindow.label4.setText("%.5f"%(self.data[0][0]))
            self.MyWindow.label5.setText("%.5f"%(self.data[1][0]))
            self.MyWindow.label6.setText("%.5f"%(self.data[2][0]))
            self.MyWindow.label7.setText("%.5f"%(self.data[3][0]))
            end = time.time()
            self.MyWindow.time_last = end - start
            self.timeChangeSec.emit(int(self.MyWindow.time_last))
            self.all_data.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0], int(self.MyWindow.time_last), self.target_time)
            self.MyWindow.time_total = time_accu + self.MyWindow.time_last

            '''
            if self.number == 0:
                #self.ON = PS_on()
                self.target_time = self.target_time + datetime.timedelta(seconds=60)
                self.data = IV_meas()
                print("OUT1 and OUT2")
                print("Volt1: " + str(self.data[0][0]))
                print("Volt2: " + str(self.data[1][0]))
                print("Curr1: " + str(self.data[2][0]))
                print("Curr2: " + str(self.data[3][0]))
                print("Time: " + str(self.target_time))
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
            if self.number == 1:
                #self.ON = PS_on1()
                self.target_time = self.target_time + datetime.timedelta(seconds=60)
                self.data1 = IV_meas()
                print("OUT1")
                print("Volt1: " + str(self.data1[0][0]))
                print("Volt2: " + str(self.data1[1][0]))
                print("Curr1: " + str(self.data1[2][0]))
                print("Curr2: " + str(self.data1[3][0]))
                time.sleep(0.1)
                self.timeChangeDate1.emit(self.target_time)
                self.data_signal1.emit(self.data1[0][0], self.data1[1][0], self.data1[2][0], self.data1[3][0])
                self.MyWindow.label4.setText("%.5f"%(self.data1[0][0]))
                self.MyWindow.label5.setText("%.5f"%(self.data1[1][0]))
                self.MyWindow.label6.setText("%.5f"%(self.data1[2][0]))
                self.MyWindow.label7.setText("%.5f"%(self.data1[3][0]))
                end = time.time()
                self.MyWindow.time_last = end - start
                self.timeChangeSec1.emit(int(self.MyWindow.time_last))
                self.all_data1.emit(self.data1[0][0], self.data1[1][0], self.data1[2][0], self.data1[3][0], int(self.MyWindow.time_last), self.target_time)
                self.MyWindow.time_total = time_accu + self.MyWindow.time_last
            if self.number == 2:
                #self.ON = PS_on2()
                self.target_time = self.target_time + datetime.timedelta(seconds=60)
                self.data2 = IV_meas_2()
                print("OUT2")
                print("Volt1: " + str(self.data2[0][0]))
                print("Curr1: " + str(self.data2[1][0]))
                time.sleep(0.1)
                self.timeChangeDate2.emit(self.target_time)
                self.data_signal2.emit(self.data2[0][0], self.data2[1][0])
                self.MyWindow.label5.setText("%.5f"%(self.data2[0][0]))
                self.MyWindow.label7.setText("%.5f"%(self.data2[1][0]))
                end = time.time()
                self.MyWindow.time_last = end - start
                self.timeChangeSec2.emit(int(self.MyWindow.time_last))
                self.all_data2.emit(self.data2[0][0], self.data2[1][0], int(self.MyWindow.time_last), self.target_time)
                self.MyWindow.time_total = time_accu + self.MyWindow.time_last
            '''
        print("End Monitoring")
        print("Monitoring Time: " + str(end-start))
        self.finished.emit()
        return #self.data[0][0], self.data[1][0], self.data[2][0]. self.data[3][0]

    def stop(self):
        self.MyWindow.processing = False

class MyWindow(QMainWindow): 
    def __init__(self, *args, **kwargs): 
        super(MyWindow, self).__init__(*args, **kwargs)
        self.setGeometry(300,300,600,600) #200,250,1500,700
        self.setWindowTitle("GUI")
        
        self.time_total = 0
        self.time_last = 0
        self.processing = False 

        self.initUI()
        self.thread = QThread()
        #self.thread1 = QThread()
        #self.thread2 = QThread()
        self.worker = Worker(self)
        #self.worker = Worker(self, 0)
        #self.worker1 = Worker(self, 1) #number 1 
        #self.worker2 = Worker(self, 2) #number 2
        return 
    
    def initUI(self):
        self.volt1 = []
        self.volt2 = []
        self.curr1 = []
        self.curr2 = []
        self.time = []
        self.date = []

        self.volt_out1 = []
        self.curr_out1 = []
        self.time_out1 = []
        self.date_out1 = []

        self.volt_out2 = []
        self.curr_out2 = []
        self.time_out2 = []
        self.date_out2 = []

        #labels
        self.label = QtWidgets.QLabel(self)
        self.label.setText("Voltage1 (V):")
        self.label.setGeometry(100, 100, 150, 40) #50,100,150,40
        self.label1 = QtWidgets.QLabel(self)
        self.label1.setText("Voltage2 (V):")
        self.label1.setGeometry(100, 130, 150, 40) #100,130,150,40
        self.label2 = QtWidgets.QLabel(self)
        self.label2.setText("Current1 (A):")
        self.label2.setGeometry(100, 160, 150, 40) #50,160,150,40
        self.label3 = QtWidgets.QLabel(self)
        self.label3.setText("Current2 (A):")
        self.label3.setGeometry(100, 190, 150, 40) #50,190,150,40
        
        #labels that needs to read IV data
        self.label4 = QtWidgets.QLabel(self)
        self.label4.setText("-")
        self.label4.setGeometry(300, 100, 150, 40) #220,100,150,40
        self.label5 = QtWidgets.QLabel(self)
        self.label5.setText("-")
        self.label5.setGeometry(300, 130, 150, 40) #220,130,150,40
        self.label6 = QtWidgets.QLabel(self)
        self.label6.setText("-")
        self.label6.setGeometry(300, 160, 150, 40) #220,160,150,40
        self.label7 = QtWidgets.QLabel(self)
        self.label7.setText("-")
        self.label7.setGeometry(300, 190, 150, 40) #220,190,150,40

        #pushbutton ps
        self.b1 = QtWidgets.QPushButton(self)
        self.b1.setText("Init Power Supply")
        self.b1.setGeometry(180,40,200,40) #130,40,200,40
        self.b1.clicked.connect(self.gpib)
        self.b2 = QtWidgets.QPushButton(self)
        self.b2.setText("OUT1 ON")
        self.b2.setGeometry(100,250,150,40) #50,250,150,40
        self.b2.clicked.connect(self.pwr_on_1)
        self.b3 = QtWidgets.QPushButton(self)
        self.b3.setText("OUT1 OFF")
        self.b3.setGeometry(300,250,150,40) #250,250,150,40
        self.b3.clicked.connect(self.pwr_off_1)

        self.b4 = QtWidgets.QPushButton(self)
        self.b4.setText("OUT2 ON")
        self.b4.setGeometry(100,300,150,40) 
        self.b4.clicked.connect(self.pwr_on_2)
        self.b5 = QtWidgets.QPushButton(self)
        self.b5.setText("MONITOR ON")
        self.b5.setGeometry(100,350,150,40)
        self.b5.clicked.connect(self.monitor_on)

        self.b6 = QtWidgets.QPushButton(self)
        self.b6.setText("OUT2 OFF")
        self.b6.setGeometry(300,300,150,40) #250,250,150,40
        self.b6.clicked.connect(self.pwr_off_2)
        self.b7 = QtWidgets.QPushButton(self)
        self.b7.setText("MONITOR OFF")
        self.b7.setGeometry(300,350,150,40) #250,250,150,40
        self.b7.clicked.connect(self.monitor_off)


        #pyqtgraph
        #self.graphWidget = pg.PlotWidget()
        #self.graphWidget.setGeometry(400,400, 500,500)

        #self.myfig = MyFigureCanvas(self, f1=self.volt1, f2=self.volt2, f3=self.curr1, f4=self.curr2, i1=self.time, obj1=self.date)
        #self.myfig = MyFigureCanvas(self)
        #self.myfig.show()
        #iself.fig = Figure(figsize=(8,5), dpi=100)
        #self.ax1 = self.fig.add_subplot(111)
        #self.ax1.set_xlabel('Time')
        #self.ax1.set_ylabel('Volt1 (V)')
        #self.line, = self.ax1.plot([],[], 'k-', label='Voltage 1')
        

    def gpib(self, addr): # dont know if it works yet 
        self.gpib_inst = comm('6')
        print("Power supply connected to GPIB")
        #with open('PS_log.txt', "a") as f:
        #    d = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
        #    f.close()

    def pwr_on_1(self):
        self.on1 = PS_on1()
        print('OUT1 ON')
        return 

    def pwr_on_2(self): 
        self.on2 = PS_on2()
        print('OUT2 ON')
        return

    def pwr_off_1(self):
        self.off1 = PS_off1()
        print('OUT1 OFF')
        return 

    def pwr_off_2(self):
        self.off2 = PS_off2()
        print('OUT2 OFF')
        return 

    def monitor_on(self):
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        #self.worker.data_signal.connect(self.get_data)
        #self.worker.timeChangeSec.connect(self.get_time) 
        #self.worker.timeChangeDate.connect(self.get_date)
        self.worker.all_data.connect(self.graph)
        self.thread.start()
        self.b5.setEnabled(False)
        self.thread.finished.connect(lambda: self.b5.setEnabled(True))
        #self.thread.finished.connect(self.monitor_off)
        #with open('PS_log.txt', "a") as f:
        #    d1 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" %(d1, "Power Supply ON") + '\n')
        #    f.write("%s %s %s" % (d1, "Volt1 (V): ", str(self.result[0][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Volt2 (V): ", str(self.result[1][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr1 (A): ", str(self.result[2][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr2 (A): ", str(self.result[3][0])) + '\n')
        return

    #def pwr_on_1(self):
        #self.worker1.moveToThread(self.thread1)
        #self.thread1.started.connect(self.worker1.run)
        #self.worker1.finished.connect(self.thread1.quit)
        #self.worker1.finished.connect(self.worker1.deleteLater)
        #self.thread1.finished.connect(self.thread1.deleteLater)
        #self.worker1.data_signal1.connect(self.get_data1)
        #self.worker1.timeChangeSec1.connect(self.get_time1)
        #self.worker1.timeChangeDate1.connect(self.get_date1)
        #self.worker1.all_data1.connect(self.graph1)
        #self.thread1.start()
        #self.b4.setEnabled(False)
        #self.thread1.finished.connect(lambda: self.b4.setEnabled(True))
        #self.thread1.finished.connect(self.pwr_off_1)

    #def pwr_on_2(self):
        #self.worker2.moveToThread(self.thread2)
        #self.thread2.started.connect(self.worker2.run)
        #self.worker2.finished.connect(self.thread2.quit)
        #self.worker2.finished.connect(self.worker2.deleteLater)
        #self.thread2.finished.connect(self.thread2.deleteLater)
        #self.worker2.data_signal2.connect(self.get_data2)
        #self.worker2.timeChangeSec2.connect(self.get_time2)
        #self.worker2.timeChangeDate2.connect(self.get_date2)
        #self.worker2.all_data2.connect(self.graph2)
        #self.thread2.start()
        #self.b5.setEnabled(False)
        #self.thread2.finished.connect(lambda: self.b5.setEnabled(True))
        #self.thread2.finished.connect(self.pwr_off_2)

    def get_data(self,d1,d2,d3,d4):
        pass
        return 

    def get_time(self, t):
        pass
        return  


    def get_date(self, d):
        pass
        return 

    def get_data1(self,d1,d2):
        pass
        return

    def get_time1(self, t):
        pass
        return


    def get_date1(self, d):
        pass
        return

    def get_data2(self,d1,d2):
        pass
        return

    def get_time2(self, t):
        pass
        return


    def get_date2(self, d):
        pass
        return

    def graph(self, f1, f2, f3, f4, i1, obj1):
        print(f1, f2, f3, f4, i1, obj1)
        self.volt1.append(f1)
        self.volt2.append(f2)
        self.curr1.append(f3)
        self.curr2.append(f4)
        self.time.append(i1)
        self.date.append(obj1)
        return 

    #def graph1(self, f1, f2, i1, obj1):
        #print("OUT1")
        #print(f1 , f2, i1, obj1)
        #self.volt_out1.append(f1)
        #self.curr_out1.append(f2)
        #self.time_out1.append(i1)
        #self.date_out1.append(obj1)
        #return

    #def graph2(self, f1, f2, i1, obj1):
        #print("OUT2")
        #print(f1, f2, i1, obj1)
        #self.volt_out2.append(f1)
        #self.curr_out2.append(f2)
        #self.time_out2.append(i1)
        #self.date_out2.append(obj1)
        #print(self.volt_out2)
        #print(self.time_out2)
        #return


    def monitor_off(self):
        #self.processing = False
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
        #self.OFF = PS_off()
        print("MONITOR OFF: OUT1 && OUT2")
        self.result = IV_meas()
        self.label4.setText("%.5f"%(self.result[0]))
        self.label5.setText("%.5f"%(self.result[1]))
        self.label6.setText("%.5f"%(self.result[2]))
        self.label7.setText("%.5f"%(self.result[3]))
        #with open('PS_log.txt', "a") as f:
        #    d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d2, "Power Supply OFF") + '\n')
        return 
    
    #def pwr_off_1(self):
        #self.worker1.stop()
        #self.thread1.quit()
        #self.thread1.wait()
        #self.OFF = PS_off1()
        #print("PS OFF: OUT1")
        #self.result = IV_meas_1()
        #self.label4.setText("%.5f"%(self.result[0]))
        #self.label6.setText("%.5f"%(self.result[1]))
        #with open('PS_log.txt', "a") as f:
        #    d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d2, "Power Supply OFF") + '\n')
        #return

    #def pwr_off_2(self):
        #self.worker2.stop()
        #self.thread2.quit()
        #self.thread2.wait()
        #self.OFF = PS_off2()
        #print("PS OFF: OUT2")
        #self.result = IV_meas_2()
        #self.label5.setText("%.5f"%(self.result[0]))
        #self.label7.setText("%.5f"%(self.result[1]))
        #with open('PS_log.txt', "a") as f:
        #    d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d2, "Power Supply OFF") + '\n')
        #return


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

