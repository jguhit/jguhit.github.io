from PyQt5.QtWidgets import * 
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5 import QtWidgets, QtCore 
from PyQt5.QtWidgets import QApplication, QMainWindow
from pyqtgraph import PlotWidget, plot, mkPen
import pyqtgraph as pg
import sys
import os 
#from ps_funcs import comm, PS_on, PS_off, IV_meas
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
from ps_funcs_ps5 import comm5, PS_on5, PS_off5, IV_meas5
date = '0805'
condition = 'beam_run'
CSM1_csvname = 'CSM1_'+date+'_'+condition+'.csv'
CSM1_txtname = 'CSM1_'+date+'_'+condition+'.txt'
CSM2_csvname = 'CSM2_'+date+'_'+condition+'.csv'
CSM2_txtname = 'CSM2_'+date+'_'+condition+'.txt'

class Worker(QObject):
    finished = pyqtSignal()
    error = pyqtSignal(tuple)
    all_data = pyqtSignal(float, float, float, float, int, object) 
    gui_data = pyqtSignal(float, float, float, float) 

    def __init__(self, MyWindow):
        super(Worker, self).__init__()
        self.MyWindow = MyWindow 
        self.MyWindow.processing = True

    def run(self):
        self.MyWindow.time_last = 0
        time_accu = self.MyWindow.time_total 
        print("Start Monitoring")
        start = time.time()
        self.target_time = datetime.datetime.now()
        while self.MyWindow.processing: 
            self.target_time = self.target_time + datetime.timedelta(seconds=60)
            while self.MyWindow.device_release==0:
                pass
            self.MyWindow.device_release=0
            self.data = IV_meas5()
            self.MyWindow.device_release = 1
            time.sleep(2)
            end = time.time()
            self.MyWindow.time_last = end - start 
            self.all_data.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0], int(self.MyWindow.time_last), self.target_time)
            self.gui_data.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
            self.MyWindow.time_total = time_accu + self.MyWindow.time_last 

        print("End Monitoring")
        print("Monitoring Time: " + str(end-start))
        self.finished.emit()
        return 

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
        self.device_release = 1
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

        #self.layoutWidget10 = QtWidgets.QWidget(self)
        #self.layoutWidget10.setGeometry(QtCore.QRect(20,320,150,150))
        #self.layout10 = QtWidgets.QVBoxLayout(self.layoutWidget10)

        #self.layoutWidget11 = QtWidgets.QWidget(self)
        #self.layoutWidget11.setGeometry(QtCore.QRect(220,320,150,150))
        #self.layout11 = QtWidgets.QVBoxLayout(self.layoutWidget11)

        #plot layout
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
        self.b2.setText("PS ON")
        #self.b2.setGeometry(100,250,150,40) #50,250,150,40
        self.layout4.addWidget(self.b2)
        self.b2.clicked.connect(self.pwr_on)

        self.b3 = QtWidgets.QPushButton(self.layoutWidget5)
        self.b3.setText("PS OFF")
        #self.b3.setGeometry(300,250,150,40) #250,250,150,40
        self.layout5.addWidget(self.b3)
        self.b3.clicked.connect(self.pwr_off)

        self.b4 = QtWidgets.QPushButton(self.layoutWidget4)
        self.b4.setText("MONITOR ON")
        #self.b2.setGeometry(100,250,150,40) #50,250,150,40
        self.layout4.addWidget(self.b4)
        self.b4.clicked.connect(self.monitor_on)
        
        self.b5 = QtWidgets.QPushButton(self.layoutWidget5)
        self.b5.setText("MONITOR OFF")
        #self.b2.setGeometry(100,250,150,40) #50,250,150,40
        self.layout5.addWidget(self.b5)
        self.b5.clicked.connect(self.monitor_off)

        #pyqtgraph
        self.graphWidget = pg.PlotWidget()
        self.pen = pg.mkPen(color="k", width=3)
        self.layout6.addWidget(self.graphWidget)
        self.graphWidget.setBackground('w')
        self.graphWidget.setTitle("CSM1 Volt1 vs Time (sec)", color="b", size="10pt")
        self.graphWidget.setLabel('left', 'Volt1 (V)', color="r", size="5pt")
        self.graphWidget.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget.showGrid(x=True, y=True)

        self.graphWidget1 = pg.PlotWidget()
        self.layout7.addWidget(self.graphWidget1)
        self.graphWidget1.setBackground('w')
        self.graphWidget1.setTitle("CSM2 Volt2 vs Time (sec)", color="b", size="10pt")
        self.graphWidget1.setLabel('left', 'Volt2 (V)', color="r", size="5pt")
        self.graphWidget1.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget1.showGrid(x=True, y=True)
        
        self.graphWidget2 = pg.PlotWidget()
        self.layout8.addWidget(self.graphWidget2)
        self.graphWidget2.setBackground('w')
        self.graphWidget2.setTitle("CSM1 Curr1 vs Time (sec)", color="b", size="10pt")
        self.graphWidget2.setLabel('left', 'Curr1 (A)', color="r", size="5pt")
        self.graphWidget2.setLabel('bottom', 'Time (S)', color="r", size="5pt")
        self.graphWidget2.showGrid(x=True, y=True)

        self.graphWidget3 = pg.PlotWidget()
        self.layout9.addWidget(self.graphWidget3)
        self.graphWidget3.setBackground('w')
        self.graphWidget3.setTitle("CSM2 Curr2 vs Time (sec)", color="b", size="10pt")
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
        d = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        
        with open(CSM1_txtname, "a") as f:
            f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
            f.close()
        
        with open(CSM2_txtname, "a") as f:
            f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
            f.close()
    
        return 

    def pwr_on(self):
        while self.device_release == 0:
            pass
        self.device_release = 0
        self.ON = PS_on()
        self.device_release = 1
        print('OUTP ON')
        time.sleep(3)
        dop = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")

        with open(CSM1_txtname, "a") as f:
            f.write("%s %s" % (dop, "OUTP1 and OUTP2 ON") + '\n')
            f.close()

        with open(CSM2_txtname, "a") as f:
            f.write("%s %s" % (dop, "OUTP1 and OUTP2 ON") + '\n')
            f.close()

        return
    
    def pwr_off(self):
        while self.device_release == 0:
            pass
        self.device_release = 0
        self.OFF = PS_off()
        self.device_release = 1
        print('OUTP OFF')
        time.sleep(3)
        doff = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        
        with open(CSM1_txtname, "a") as f:
            f.write("%s %s" % (doff, "OUTP1 and OUTP2 OFF") + '\n')
            f.close()
        
        with open(CSM2_txtname, "a") as f:
            f.write("%s %s" % (doff, "OUTP1 and OUTP2 OFF") + '\n')
            f.close()

        return
    
    def monitor_on(self):
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.worker.all_data.connect(self.graph)
        self.worker.gui_data.connect(self.label_func)
        self.thread.start()
        self.b4.setEnabled(False)
        self.thread.finished.connect(lambda: self.b4.setEnabled(True))
        self.thread.finished.connect(self.monitor_off)
        d1 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        
        with open(CSM1_txtname, "a") as f:
            f.write("%s %s" %(d1, "Power Supply  ON") + '\n')
            f.close()
        
        with open(CSM2_txtname, "a") as f:
            f.write("%s %s" %(d1, "Power Supply  ON") + '\n')
            f.close()
        
        return

     def label_func(self, par1, par2, par3, par4):
        print("Label GUI for CSM1 and CSM2")
        self.label4.setText("%.5f"%(par1))
        self.label5.setText("%.5f"%(par2))
        self.label6.setText("%.5f"%(par3))
        self.label7.setText("%.5f"%(par4))
        return par1, par2, par3, par4

    def graph(self, f1, f2, f3, f4, i1, obj1):
        print("Get Data from CSM1 and CSM2")
        #legend:
        #f1:volt1 (CSM1) data_line, graphWidget
        #f2:volt2 (CSM2) data_line1, graphWidget1
        #f3:curr1 (CSM1) data_line2, graphWidget2
        #f4:curr2 (CSM2) data_line3, graphWidget3

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
        with open(CSM1_csvname, 'a') as csv1: 
            fieldnames = ['DateTime', 'Time_S', 'Volt1_V', 'Curr1_A']
            writer = csv.DictWriter(csv1, fieldnames=fieldnames)

            writer.writeheader()
            writer.writerow({'DateTime':d2, 'Time_S':str(i1), 'Volt1_V': str(f1), 'Curr1_A': str(f3)})

        with open(CSM2_csvname, 'a') as csv2: 
            fieldnames = ['DateTime', 'Time_S', 'Volt2_V', 'Curr2_A']
            writer = csv.DictWriter(csv2, fieldnames=fieldnames)

            writer.writeheader()
            writer.writerow({'DateTime':d2, 'Time_S':str(i1), 'Volt2_V': str(f2), 'Curr2_A': str(f4)})


        with open(CSM1_txtname, "a") as f1:
            f.write("%s %s" %(d2, "Get CSM1 IV Data") + '\n')
            f.write("%s %s %s" % (d2, "Volt1 (V): ", str(f1) +  '\n'))
            f.write("%s %s %s" % (d2, "Curr1 (A): ", str(f3) + '\n'))
            f.write("%s %s %s" % (d2, "Time (Sec): ", str(i1) + '\n'))
            f.close()

        with open(CSM2_txtname, "a") as f2:
            f.write("%s %s" %(d2, "Get CSM2 IV Data") + '\n')
            f.write("%s %s %s" % (d2, "Volt2 (V): ", str(f2) + '\n'))
            f.write("%s %s %s" % (d2, "Curr2 (A): ", str(f4) + '\n'))
            f.write("%s %s %s" % (d2, "Time (Sec): ", str(i1) + '\n'))
            f.close()
        
        return

    
    def monitor_off(self):
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
        print("MONITOR OFF")
        self.result = IV_meas5()
        self.label4.setText("%.5f"%(self.result[0]))
        self.label5.setText("%.5f"%(self.result[1]))
        self.label6.setText("%.5f"%(self.result[2]))
        self.label7.setText("%.5f"%(self.result[3]))
        d3 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        
        with open(CSM1_txtname, "a") as f:
            f.write("%s %s" % (d3, "Power Supply OFF") + '\n')
            f.close()

        with open(CSM2_txtname, "a") as f:
            f.write("%s %s" % (d3, "Power Supply OFF") + '\n')
            f.close()
        
        return 
    
    def update(self):
        self.label4.adjustSize()
        self.label5.adjustSize()
        self.label6.adjustSize()
        self.label7.adjustSize()
        return


def window():
    app = QApplication(sys.argv)
    win = MyWindow()
    win.show()
    sys.exit(app.exec_())

window()

