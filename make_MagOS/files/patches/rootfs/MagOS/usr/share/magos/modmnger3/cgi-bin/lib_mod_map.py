#!/usr/bin/python3
import os, re, subprocess, shutil,  glob, cfg 
from time import sleep

def getPlugins(dir):
	items = []
	plugList = []
	for file in sorted(os.listdir(dir)):
		path_file = os.path.join(dir, file)
		if os.path.isfile(path_file):
			plugList += re.findall('^.*.plugin$', path_file)
	for plugin in plugList:
		f = open(plugin, 'r')
		arr = {}
		for string in f.readlines():
			arr[string.split('=')[0].strip()] =  string.split('=')[1].replace('\n', '').strip()
		f.close()
		items.append(arr)
	return items

def getModArr():
	command = ('aufs-n --hidetop --raw \'${n}////${bname_source}////$dname_source \' ')
	ret = os.popen( command ).read()
	arr = {}
	for key_val in ret.split('\n'):
		if len(key_val.split('////')) == 3:
			if key_val.split('////')[1] != 'tmpfs':
				arr[key_val.split('////')[0]] = (key_val.split('////')[1].replace('[', '').replace(']', ''),key_val.split('////')[2].replace('[', '').replace(']', ''))
	return arr

def getFolders(modArr):
	folders = []
	dirlist = []
	for val in list(modArr.values()):
		folders.append(val[1])
	for item in folders:
		dirlist.append(item)
		dirlist.append(item.replace( 'modules', 'optional') )
	dirlist = list(set(dirlist))
	dirlist.sort()
	return dirlist

def getModGreen(modArr, dirPath):
	green_arr = {}
	for key, val in list(modArr.items()):
		if val[1] == dirPath:
			green_arr[key] = val[0]
	return green_arr

def getModGrey(green_arr, dirPath):
	dirlist = os.listdir(dirPath)
	grey_list = []
	green_list = []
	dirLs = []
	for file in dirlist:
		for modtype in cfg.config('modtype'):
			dirLs += re.findall('^.*.'+ modtype + '$', file)
			list(dirLs)
	for val in list(green_arr.values()):
		green_list.append(val)
	grey_list = list( set(dirLs) - set(green_list) )
	return grey_list

def start_ws (action, password):
	if action == 'start':
		command = ("%s %s | %s %s" % ('echo', password, 'su -c', './scripts/ws_server.py' )) 
		subprocess.Popen(command, shell=True)
		excode = 1
		n = 0
		while not n == 10: 
			excode = subprocess.call(['pgrep', 'ws_server.py'], shell=False)
			if excode == 0:
				break
			n = n + 1
			sleep(0.5)

		
		
		
