#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os, sys

def config(index):
	cfg = {
	'css': '/css/default.css',
	'header': 'Modules manager',
	'repository': 'auto',
	'mountpoint': '/media/repo',
	'modtype': ('xzm', 'rom', 'rwm', 'enc', 'pfs')
		
	}

	if os.path.isfile('/etc/initvars'):
		init = 'uird'
	else:
		init = 'initrd'
		
	if os.path.exists('/etc/initvars'):
		f = open('/etc/initvars', 'r') 
		a = []
		for string in f.readlines():
			a.append(string)
		f.close()
		initvars = {}
		for item in a:
			item =  item.replace('\n', '').replace(' ','')
			if len(item) > 4:
				initvars[item.split('=')[0]] =  item.split('=')[1]
			
#	if cfg['repository'] == 'auto':
#		try:
#			f = open(initvars['SYSMNT'] + '/layer-base/0/VERSION', 'r')
#		except:
#			f = open('/mnt/livemedia/MagOS/VERSION', 'r')

#		for string in f.readlines():
#			version =  string.split()[0]
#			cfg['repository'] = 'ftp://magos.sibsau.ru/modules/' + str(version)
		
	if index == 'all':
		return cfg
	else:
		return cfg[index]	
		
def html_header():
	a = config('all')
	print("""
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru-ru" lang="ru-ru" >
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>%s</title>
<link type="text/css" href="%s" rel="stylesheet" />
</head><body>""" % ( a['header'], a['css'] ))
	
if __name__ == '__main__':
	test = ''
	if type(config(sys.argv[1])) == type(test):
		print(config(sys.argv[1]))
	else:
		for a in config(sys.argv[1]):
			print(a, 'end= ')
