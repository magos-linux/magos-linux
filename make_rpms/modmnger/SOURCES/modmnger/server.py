#!/usr/bin/python
# -*- coding:utf-8 -*-
import BaseHTTPServer, CGIHTTPServer, os
server_address = ("", 8000)
baseCGIdir = '/cgi-bin'

def getSubdirs (dir):
	listDirs = []
	for name in os.listdir(dir):
		path = os.path.join(dir, name)
		if os.path.isdir(path):
			wc = len(os.listdir(path))
			if not wc == 0 :
				listDirs.append(path[1:])
				listDirs += getSubdirs(path)
	return listDirs

server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
handler.cgi_directories = getSubdirs('.'+ baseCGIdir)
handler.cgi_directories.append(baseCGIdir)  
handler.cgi_directories.sort()
print 'cgi_directories:',  handler.cgi_directories

httpd = server(server_address, handler)
httpd.serve_forever()
