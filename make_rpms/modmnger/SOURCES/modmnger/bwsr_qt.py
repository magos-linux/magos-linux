#!/usr/bin/env python
import sys
from PyQt4 import QtCore, QtGui, QtWebKit
url = sys.argv[1]
if len(sys.argv) == 3:
	bwsr_type = sys.argv[2]
else: 
	bwsr_type = '--simple'


class Browser(QtGui.QMainWindow):

    def __init__(self):
        """
            Initialize the browser GUI and connect the events
        """

        QtGui.QMainWindow.__init__(self)
        self.resize(800,600)
        self.centralwidget = QtGui.QWidget(self)

        self.mainLayout = QtGui.QHBoxLayout(self.centralwidget)
        self.mainLayout.setSpacing(0)
        self.mainLayout.setMargin(1)

        self.frame = QtGui.QFrame(self.centralwidget)

        self.gridLayout = QtGui.QVBoxLayout(self.frame)
        self.gridLayout.setMargin(0)
        self.gridLayout.setSpacing(0)

        self.horizontalLayout = QtGui.QHBoxLayout()
        if  bwsr_type != '--simple':        
	   self.bt_back = QtGui.QPushButton(self.frame)
           self.bt_ahead = QtGui.QPushButton(self.frame)
	   self.bt_back.setIcon(QtGui.QIcon().fromTheme("go-previous"))
           self.bt_ahead.setIcon(QtGui.QIcon().fromTheme("go-next"))
           self.horizontalLayout.addWidget(self.bt_back)
           self.horizontalLayout.addWidget(self.bt_ahead)
           self.gridLayout.addLayout(self.horizontalLayout)

        self.html = QtWebKit.QWebView()
        self.gridLayout.addWidget(self.html)
        self.mainLayout.addWidget(self.frame)
        self.setCentralWidget(self.centralwidget)

        if bwsr_type != '--simple':
			self.connect(self.bt_back, QtCore.SIGNAL("clicked()"), self.html.back)
			self.connect(self.bt_ahead, QtCore.SIGNAL("clicked()"), self.html.forward)

        self.default_url = url
        self.browse()

    def browse(self):
        """
            Make a web browse on a specific url and show the page on the
            Webview widget.
        """

        url = self.default_url
        self.html.load(QtCore.QUrl(url))
        self.html.show()

if __name__ == "__main__":

    app = QtGui.QApplication(sys.argv)
    main = Browser()
    main.show()
    sys.exit(app.exec_())
