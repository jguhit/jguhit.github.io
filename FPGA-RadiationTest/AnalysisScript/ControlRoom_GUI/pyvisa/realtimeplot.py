# coding=utf-8

import numpy as np
import matplotlib
# Make sure that we are using QT5
matplotlib.use('Qt5Agg')
from matplotlib.figure import Figure
from matplotlib.animation import TimedAnimation, FuncAnimation
from matplotlib.lines import Line2D
from PyQt5 import QtGui, QtWidgets, QtCore
import time

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar


class CustomFigCanvas(FigureCanvas, FuncAnimation):

    def __init__(self):

        # The data
        self.xdata = []
        self.ydata = []
        self.end = float()
        self.start = float()

        # The window
        self.fig = Figure()
        self.ax = self.fig.add_subplot(111)
        self.line, = self.ax.plot([], [], lw=2)
        self.ax.grid()
        # ax1 settings
        self.ax.set_xlabel('time')
        self.ax.set_ylabel('raw data')

        FigureCanvas.__init__(self, self.fig)
        FuncAnimation.__init__(self, self.fig, self.Update, self.data_gen,  blit=False,
                               interval=40, repeat=False, init_func=self.init)
        FigureCanvas.setSizePolicy(self, QtWidgets.QSizePolicy.Expanding,
                                   QtWidgets.QSizePolicy.Expanding)

    def data_gen(self):

        self.cnt = 0
        self.t = 0
        while self.cnt < 1000:
            print(self.cnt)
            self.cnt += 1
            self.t += 0.1
            self.y = np.sin(2 * np.pi * self.t) * np.exp(-self.t / 10.)
            yield self.t, self.y

    def init(self):
        self.ax.set_ylim(-1.1, 1.1)
        self.ax.set_xlim(0, 10)
        del self.xdata[:]
        del self.ydata[:]
        self.line.set_data(self.xdata, self.ydata)
        return self.line,

    def Update(self, data):
        # update the data
        self.end = time.time()
        print(self.end - self.start)
        t, y = data
        self.xdata.append(t)
        self.ydata.append(y)
        xmin, xmax = self.ax.get_xlim()

        if t >= xmax:
            self.ax.set_xlim(xmin, 2 * xmax)
            self.ax.figure.canvas.draw()
            self.line.set_data(self.xdata, self.ydata)
        self.start = time.time()
        print('---------')
        return self.line,


class MplCanvasWrapper(QtWidgets.QDialog):

    def __init__(self, parent=None):
        QtWidgets.QDialog.__init__(self, parent)
        self.canvas = CustomFigCanvas()
        self.vbl = QtWidgets.QVBoxLayout()
        self.ntb = NavigationToolbar(self.canvas, parent)
        self.btnStart = QtWidgets.QPushButton()
        self.btnStart.setText('开始')
        self.btnPause = QtWidgets.QPushButton()
        self.btnPause.setText('结束')

        self.vbl.addWidget(self.ntb)
        self.vbl.addWidget(self.canvas)
        self.vbl.addWidget(self.btnStart)
        self.vbl.addWidget(self.btnPause)

        self.setLayout(self.vbl)

        self.btnStart.clicked.connect(self.startPlot)
        self.btnPause.clicked.connect(self.pausePlot)

        self.dataX = []
        self.dataY = []

    def startPlot(self):
        pass

    def pausePlot(self):
        pass


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    test_widget = MplCanvasWrapper()
    test_widget.show()
    sys.exit(app.exec_())
