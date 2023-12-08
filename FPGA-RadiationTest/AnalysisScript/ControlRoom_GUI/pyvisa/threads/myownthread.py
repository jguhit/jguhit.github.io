from PyQt5.QtGui import * 
from PyQt5.QtWidgets import * 
from PyQt5.QtCore import * 
import traceback, sys
import time 

class WorkerSignals(QObject):
    ps_off = pyqtSignal()
    ps_on = pyqtSignal()
    ps_init = pyqtSignal()
    results = pyqtSignal(float, float, float, float) 

class Worker(QRunnable): 
    def __init__(self, fn, *args, **kwargs):
        self.fn = fn 
        self.args = args 
        self.kwargs = kwargs 
        self.signals = WorkerSignals()

        
