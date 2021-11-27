#!/usr/bin/env python3

import gi, sys
from gi.repository import Gtk,WebKit

#def goback(button):
#   view.go_back()

#def navrequest(thisview, frame, networkRequest):
#   address = networkRequest.get_uri()
#   if not "debian.org" in address:
#   md = Gtk.MessageDialog(win,0,Gtk.MessageType.INFO, Gtk.ButtonsType.CLOSE, "Not allowed to leave the site!")

#      md.run()
#      md.destroy()
#      view.open("http://www.debian.org")

view = WebKit.WebView()
#view.connect("navigation-requested", navrequest)

sw = Gtk.ScrolledWindow()
sw.add(view)

#button = Gtk.Button("Back")
#button.connect("clicked", goback)

#vbox = Gtk.VBox()
#vbox.pack_start(button, False, False, 0)
#vbox.add(sw)

win = Gtk.Window()
win.set_size_request(800, 600)
win.connect("destroy", Gtk.main_quit)
win.set_title("Linux Voice browser")
win.add(sw)
win.show_all()

view.open(sys.argv[1])
Gtk.main()
