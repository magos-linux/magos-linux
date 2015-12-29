#!/usr/bin/env python
import gtk
import webkit
import sys
 
view = webkit.WebView()

sw = gtk.ScrolledWindow()
sw.add(view)


win = gtk.Window(gtk.WINDOW_TOPLEVEL)
win.add(sw)
win.show_all()
win.set_geometry_hints(sw, min_width=500, min_height=300,  base_width=-1, base_height=-1, width_inc=-1, height_inc=-1, min_aspect=-1.0, max_aspect=-1.0)
win.connect('destroy',quit)
view.open(sys.argv[1])
gtk.main()

