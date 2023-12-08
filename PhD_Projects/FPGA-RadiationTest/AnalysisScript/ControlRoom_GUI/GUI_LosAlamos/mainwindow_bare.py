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
from matplotlib.backends.backend_qt5agg import FigureCanvas
import matplotlib as mpl 
import matplotlib.figure as mpl_fig 
import matplotlib.animation as anim 
import numpy as np
import threading 
import traceback

class WorkerSignals(QObject):
    finished = pyqtSignal()
    error = pyqtSignal(tuple)
    result = pyqtSignal(object)  
    data = pyqtSignal(float, float, float, float) 

class Worker(QRunnable):
    '''
    Worker Thread
    '''
    
    def __init__(self, fn, *args, **kwargs):
        super(Worker, self).__init__()
        self.fn = fn
        self.args = args 
        self.kwargs = kwargs
        self.signals = WorkerSignals()
        self.m_stop = False 

        #Add callback 
        self.kwargs['data_callback'] = self.signals.data

    @pyqtSlot()
    def run(self):
        '''
        My code goes into this function
        '''
        try:
            result = self.fn(*self.args, **self.kwargs)
        except: 
            traceback.print_exc()
            exctype, value = sys.exc_info()[:2]
            self.signals.error.emit((exctype, value, traceback.format_exc()))
        else: 
            self.signals.result.emit(result) #returns results of processing
            while not self.m_stop:
                
        
        finally:
            self.signals.finished.emit() #done

        #print("Thread Start")
        #time.sleep(5)
        #print("Thread complete")
    
    def stop(self):
        self.m_stop = True 

class MyWindow(QMainWindow): 
    def __init__(self): 
        super(MyWindow, self).__init__()
        self.setGeometry(300,300,550,400)
        self.setWindowTitle("GUI")
        self.threadpool = QThreadPool()
        #DataLoop = threading.Thread(name = 'DataLoop', target = dataSendLoop, daemon= True, args = (self.addData_callbackFunc, ))
        #DataLoop.start()
        self.initUI()
        return 
    
    def initUI(self):
        #self.volt1 = []
        #self.volt2 = []
        #self.curr1 = []
        #self.curr2 = []
        #labels
        self.label = QtWidgets.QLabel(self)
        self.label.setText("Voltage1 (V):")
        self.label.setGeometry(100, 100, 150, 40)
        self.label1 = QtWidgets.QLabel(self)
        self.label1.setText("Voltage2 (V):")
        self.label1.setGeometry(100, 130, 150, 40)
        self.label2 = QtWidgets.QLabel(self)
        self.label2.setText("Current1 (A):")
        self.label2.setGeometry(100, 160, 150, 40)
        self.label3 = QtWidgets.QLabel(self)
        self.label3.setText("Current2 (A):")
        self.label3.setGeometry(100, 190, 150, 40)
        
        #labels that needs to read IV data
        self.label4 = QtWidgets.QLabel(self)
        self.label4.setText("-")
        self.label4.setGeometry(300, 100, 150, 40)
        self.label5 = QtWidgets.QLabel(self)
        self.label5.setText("-")
        self.label5.setGeometry(300, 130, 150, 40)
        self.label6 = QtWidgets.QLabel(self)
        self.label6.setText("-")
        self.label6.setGeometry(300, 160, 150, 40)
        self.label7 = QtWidgets.QLabel(self)
        self.label7.setText("-")
        self.label7.setGeometry(300, 190, 150, 40)

        #pushbutton ps
        self.b1 = QtWidgets.QPushButton(self)
        self.b1.setText("Init Power Supply")
        self.b1.setGeometry(180,40,200,40)
        self.b1.clicked.connect(self.gpib)
        self.b2 = QtWidgets.QPushButton(self)
        self.b2.setText("ON")
        self.b2.setGeometry(100,250,150,40)
        self.b2.clicked.connect(self.dummy)
        #self.b2.clicked.connect(self.pwr_on)
        self.b3 = QtWidgets.QPushButton(self)
        self.b3.setText("OFF")
        self.b3.setGeometry(300,250,150,40)
        #self.b3.clicked.connect(self.dummy2)
        self.b3.clicked.connect(self.pwr_off)

    def gpib(self, addr): # dont know if it works yet 
        self.gpib_inst = comm('6')
        print("Power supply connected to GPIB")
        #with open('PS_log.txt', "a") as f:
        #    d = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" % (d, "Power Supply Connected to GPIB") + '\n')
        #    f.close()

    def pwr_on(self, data_callback):
        self.ON = PS_on()
        print("power supply on")
        buttonoff = self.b3.clicked.connect(self.pwr_off)
        while True:
            self.data = IV_meas()
            print("Volt1: " + str(self.data[0][0]))
            print("Volt2: " + str(self.data[1][0]))
            print("Curr1: " + str(self.data[2][0]))
            print("Curr2: " + str(self.data[3][0]))
            time.sleep(0.1)
            data_callback.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
            self.label4.setText("%.5f"%(self.data[0][0]))
            self.label5.setText("%.5f"%(self.data[1][0]))
            self.label6.setText("%.5f"%(self.data[2][0]))
            self.label7.setText("%.5f"%(self.data[3][0]))
        
        #self.result = IV_meas()
        #self.label4.setText("%.5f"%(self.result[0][0]))
        #self.label5.setText("%.5f"%(self.result[1][0]))
        #self.label6.setText("%.5f"%(self.result[2][0]))
        #self.label7.setText("%.5f"%(self.result[3][0]))
        #with open('PS_log.txt', "a") as f:
        #    d1 = datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S")
        #    f.write("%s %s" %(d1, "Power Supply ON") + '\n')
        #    f.write("%s %s %s" % (d1, "Volt1 (V): ", str(self.result[0][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Volt2 (V): ", str(self.result[1][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr1 (A): ", str(self.result[2][0])) + '\n')
        #    f.write("%s %s %s" % (d1, "Curr2 (A): ", str(self.result[3][0])) + '\n')

    def pwr_off(self):
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
    
    def print_output(self, s):
        print("Data: ", s) 

    def thread_complete(self):
        print("Thread Complete")

    def data_fn(self, f1, f2, f3, f4):
        print("%.5f%% f1" % f1)
        print("%.5f%% f2" % f2)
        print("%.5f%% f3" % f3)
        print("%.5f%% f4" % f4)

    #def IV_meas(self, data_callback):
    #    self.data = IV_meas()
    #    print("Volt1: " + str(self.data[0][0]))
    #    print("Volt2: " + str(self.data[1][0]))
    #    print("Curr1: " + str(self.data[2][0]))
    #    print("Curr2: " + str(self.data[3][0]))
    #    data_callback.emit(self.data[0][0], self.data[1][0], self.data[2][0], self.data[3][0])
    #    self.label4.setText("%.5f"%(self.data[0][0]))
    #    self.label5.setText("%.5f"%(self.data[1][0]))
    #    self.label6.setText("%.5f"%(self.data[2][0]))
    #    self.label7.setText("%.5f"%(self.data[3][0]))
        return 
    
    def update(self):
        self.label4.adjustSize()
        self.label5.adjustSize()
        self.label6.adjustSize()
        self.label7.adjustSize()

    def dummy(self):
        worker = Worker(self.pwr_on) #Pass pwr_on function to be turned on 
        worker.signals.result.connect(self.print_output)
        worker.signals.finished.connect(self.thread_complete)    
        worker.signals.data.connect(self.data_fn)

        # Execute 
        self.threadpool.start(worker)
    
    #def addData_callbackFunc(self, val1, val2, val3, val4):
        #print("This function is called inside power on")
        #print("Volt1: "+ str(val1))
        #print("Volt2: " + str(val2))
        #print("Curr1: " + str(val3))
        #print("Curr2: " + str(val4))
        #self.volt1.append(float(val1))
        #self.volt2.append(float(val2))
        #self.curr1.append(float(val3))
        #self.curr2.append(float(val4))
        #for i in range(len(self.volt1)):
            #print(self.volt1[i])
            #self.label4.setText("%.8f"%(self.volt1[i]))
            #self.label5.setText("%.8f"%(self.volt2[i]))
            #self.label6.setText("%.8f"%(self.curr1[i]))
            #self.label7.setText("%.8f"%(self.curr2[i]))
        #return #val1, val2, val3, val4


#class Communicate(QObject):
#    data_signal = pyqtSignal(float, float, float, float)

#def dataSendLoop(addData_callbackFunc):
#   mySrc = Communicate()
#   mySrc.data_signal.connect(addData_callbackFunc)

#   while True: 
#       volt1, volt2, curr1, curr2 = IV_meas()
#       volt1 = volt1[0]
#       volt2 = volt2[0]
#       curr1 = curr1[0]
#       curr2 = curr2[0]
#       time.sleep(0.1)
#       mySrc.data_signal.emit(volt1, volt2, curr1, curr2)

def window():
    app = QApplication(sys.argv)
    win = MyWindow()
    win.show()
    sys.exit(app.exec_())

window()

