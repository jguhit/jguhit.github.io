from PyQt5.QtCore import QThread, QObject, pyqtSignal, pyqtSlot
import time 

class Worker(QObject):
    finished = pyqtSignal()


