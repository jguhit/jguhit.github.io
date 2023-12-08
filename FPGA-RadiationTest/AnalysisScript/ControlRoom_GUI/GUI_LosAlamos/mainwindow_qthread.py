from PyQt5.QtWidgets import * 
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5 import QtWidgets, QtCore 
from PyQt5.QtWidgets import QApplication, QMainWindow 
import sys
from ps_funcs import comm, PS_on, PS_off, IV_meas
import datetime 
import time 
#from matplotlib.backends.qt_compat import QtCore, QtWidgets 
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from  matplotlib.figure import Figure 
from  matplotlib.animation import FuncAnimation
import numpy as np
import threading 
import traceback

class Worker(QObject):
    finished = pyqtSignal()
    error = pyqtSignal(tuple)
    result = pyqtSignal(object)  
    data_signal = pyqtSignal(float, float, float, float) 

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
        while self.MyWindow.processing: 
            self.data = IV_meas()
            print("Volt1: " + str(self.data[0][0]))
            print("Volt2: " + str(self.data[1][0]))
            print("Curr1: " + str(self.data[2][0]))
            print("Curr2: " + str(self.data[3][0]))
            time.sleep(0.1)
            self.data_signal.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
            self.MyWindow.label4.setText("%.5f"%(self.data[0][0]))
            self.MyWindow.label5.setText("%.5f"%(self.data[1][0]))
            self.MyWindow.label6.setText("%.5f"%(self.data[2][0]))
            self.MyWindow.label7.setText("%.5f"%(self.data[3][0]))
            end = time.time()
            self.MyWindow.time_last = end - start 
            self.MyWindow.time_total = time_accu + self.MyWindow.time_last 

        print("End Monitoring")
        print("Monitoring Time: " + str(end-start))
        self.finished.emit()

    def stop(self):
        self.MyWindow.processing = False

class MyWindow(QMainWindow): 
    def __init__(self): 
        super(MyWindow, self).__init__()
        self.setGeometry(200,250,1500,700)
        self.setWindowTitle("GUI")
        
        #self.canvas = MyFigureCanvas()
        #self.canvas.show()

        self.time_total = 0
        self.time_last = 0
        self.processing = False 
        self.initUI()
        self.thread = QThread()
        self.worker = Worker(self)
        return 
    
    def initUI(self):
        self.canvas = MyFigureCanvas()
        self.canvas.show()
        #labels
        self.label = QtWidgets.QLabel(self)
        self.label.setText("Voltage1 (V):")
        self.label.setGeometry(50, 100, 150, 40)
        self.label1 = QtWidgets.QLabel(self)
        self.label1.setText("Voltage2 (V):")
        self.label1.setGeometry(50, 130, 150, 40)
        self.label2 = QtWidgets.QLabel(self)
        self.label2.setText("Current1 (A):")
        self.label2.setGeometry(50, 160, 150, 40)
        self.label3 = QtWidgets.QLabel(self)
        self.label3.setText("Current2 (A):")
        self.label3.setGeometry(50, 190, 150, 40)
        
        #labels that needs to read IV data
        self.label4 = QtWidgets.QLabel(self)
        self.label4.setText("-")
        self.label4.setGeometry(220, 100, 150, 40)
        self.label5 = QtWidgets.QLabel(self)
        self.label5.setText("-")
        self.label5.setGeometry(220, 130, 150, 40)
        self.label6 = QtWidgets.QLabel(self)
        self.label6.setText("-")
        self.label6.setGeometry(220, 160, 150, 40)
        self.label7 = QtWidgets.QLabel(self)
        self.label7.setText("-")
        self.label7.setGeometry(220, 190, 150, 40)

        #pushbutton ps
        self.b1 = QtWidgets.QPushButton(self)
        self.b1.setText("Init Power Supply")
        self.b1.setGeometry(130,40,200,40)
        self.b1.clicked.connect(self.gpib)
        self.b2 = QtWidgets.QPushButton(self)
        self.b2.setText("ON")
        self.b2.setGeometry(50,250,150,40)
        self.b2.clicked.connect(self.pwr_on)
        self.b3 = QtWidgets.QPushButton(self)
        self.b3.setText("OFF")
        self.b3.setGeometry(250,250,150,40)
        self.b3.clicked.connect(self.pwr_off)

    def gpib(self, addr): # dont know if it works yet 
        self.gpib_inst = comm('6')
        print("Power supply connected to GPIB")
        #with open('PS_log.txt', "a") as f:
        #    d = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
        #    f.close()

    def pwr_on(self):
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()
        self.b2.setEnabled(False)
        self.thread.finished.connect(lambda: self.b2.setEnabled(True))
        self.thread.finished.connect(self.pwr_off)
        #with open('PS_log.txt', "a") as f:
        #    d1 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" %(d1, "Power Supply ON") + '\n')
        #    f.write("%s %s %s" % (d1, "Volt1 (V): ", str(self.result[0][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Volt2 (V): ", str(self.result[1][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr1 (A): ", str(self.result[2][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr2 (A): ", str(self.result[3][0])) + '\n')
        return

    def pwr_off(self):
        self.worker.stop()
        self.thread.quit()
        self.thread.wait()
        self.OFF = PS_off()
        print("pwr off")
        self.result = IV_meas()
        self.label4.setText("%.5f"%(self.result[0]))
        self.label5.setText("%.5f"%(self.result[1]))
        self.label6.setText("%.5f"%(self.result[2]))
        self.label7.setText("%.5f"%(self.result[3]))
        #with open('PS_log.txt', "a") as f:
        #    d2 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d2, "Power Supply OFF") + '\n')
        return 
    
    def update(self):
        self.label4.adjustSize()
        self.label5.adjustSize()
        self.label6.adjustSize()
        self.label7.adjustSize()

class MyFigureCanvas(FigureCanvas, FuncAnimation):
    def __init__(self):
        #super(MyFigureCanvas, self).__init__()
        self.volt1 = []
        self.volt2 = []
        self.curr1 = []
        self.curr2 = []
        self.x = [datetime.datetime.now()]

        fig = Figure(figsize=(8,5), dpi=100)
        self.ax1 = fig.add_subplot(111)
        self.ax1.set_xlabel('Time')
        self.ax1.set_ylabel('Volt1 (V)')
        self.line, = self.ax1.plot([],[], 'k-', label='Voltage 1')

        FigureCanvas.__init__(self, fig)
        #FuncAnimation(self, fig, self.animate, init_func = self.init, frames=frames1, blit=False)
        return

    #def init(self):
    #    self.line.set_data(x[:1], volt1[:1])
    #    self.line.axes.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S"))

    #cnt = 0
    #def animate(self, args):
    #    global cnt
    #    cnt +=1
    #    self.x.append(args[0])
    #    self.volt1.append(args[1])
    #    print('x', self.x)
    #    print('y', self.volt1)

     #   self.xdata = self.x[0:cnt]
     #   self.volt1_data = self.volt1[0:cnt]

     #   self.volt1min = np.min(self.volt1_data)
     #   self.volt1max = np.max(self.volt1_data)
     #   self.ax1.set_ylim(self.volt1min, self.volt1max)

      #  self.line.set_data(self.xdata, self.volt1_data)
      #  self.line.set_color('red')

      #  self.ax1.relim()
      #  self.ax1.autoscale()

    #def frames1(self):
    #    self.target_time = datetime.datetime.now(0
                



def window():
    app = QApplication(sys.argv)
    win = MyWindow()
    win.show()
    sys.exit(app.exec_())

window()

