#!/usr/bin/python
import os, re, subprocess, shutil,  glob, cfg

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
	command = ('./lib_s2m.sh --get-mods ')
	ret = os.popen( command ).read()
	arr = {}
	for key_val in ret.split('\n'):
	    if len(key_val.split('////')) == 2:		
			arr[key_val.split('////')[0]] = key_val.split('////')[1]
	return arr


def getModGreen(modArr, dirPath):
	green_list = []
	for key, val in modArr.items():
	    if val == dirPath:
		green_list.append(key)
		green_list.sort()
	return green_list

	
def getModGrey(green_list, dirPath):
	dirlist = os.listdir(dirPath)
	grey_list = []
	dirLs = []
	for file in dirlist:
		for modtype in cfg.config('modtype'):
			dirLs += re.findall('^.*.'+ modtype + '$', file)
	for a in (set(dirLs) - set(green_list)):  
		grey_list.append(a)
		grey_list.sort()
	return grey_list 
		

def getSubdirs (dir, root):
	if root == 'include_root':
		listDirs = [dir,]
	else:
		listDirs = []
	for name in os.listdir(dir):
		path = os.path.join(dir, name)
		if os.path.isdir(path):
			try:
				wc = len(os.listdir(path))
			except:
				wc = 0
			if not wc == 0 :
				listDirs.append(path)
				listDirs += getSubdirs(path, 'not_include')
	return listDirs

def testSubdirs(dir, modArr):
	xzmList = []
	exitcode = 'none'
	for a in dir:
		for modtype in cfg.config('modtype'):
			names = glob.glob(a + '/*.' + modtype)
			for name in names:
				xzmList.append(name)
			
	if not len(xzmList) == 0:
			exitcode = 'grey'
	a = []
	for key, value in modArr.items():
		a.append(value + '/' + key)
		for mod in xzmList:
			for file in a:
				if mod  == file:
					exitcode = 'green'
					break
		if exitcode == 'green':
			break
	return exitcode
		
def activate (modname):
	command = ('beesu activate "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '<br>activation - OK!!!')
	else:
		dialog_text = (modname + '<br>activation FAIL!!!')
	return dialog_text
 	
def deactivate (modname):
	command = ('beesu deactivate "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '<br>deactivation - OK!!!')
	else:
		dialog_text = (modname + '<br>deactivation FAIL!!!')
	return dialog_text

	 
def mv2 (modname, destDir):
	dialog_text = (modname + '<br>rename - OK!!!')
	try:
		shutil.move(modname.replace(' ', '\ '), destDir)
	except:
		command = ('beesu  mv -f "' + modname.replace(' ', '\ ') + ' ' + destDir + '/"')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = (modname + '<br>rename FAIL!!!')
	
	return dialog_text
	
def cp2 (modname, destDir):
	dialog_text = (modname + '<br>copy - OK!!!')
	try:
		shutil.copy(modname, destDir)
	except:
		command = ('beesu  cp "' + modname.replace(' ', '\ ') + ' ' + destDir + '/"')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = (modname + '<br>copy -  FAIL!!!')
	
	return dialog_text

def install (modname, destDir):
	dialog_text = (modname + '<br>install -  OK!!!')
	cp2(modname, destDir)
	try:
		activate( os.path.join (destDir, os.path.basename(modname)))
	except:
		dialog_text = (modname + '<br>install -  FAIL!!!')
	
	return dialog_text


def modinfo (modname):
	command = ('beesu  ./mod_info  "%s" ')  %  modname.replace(' ', '\ ') 
	#print command
	subprocess.Popen(command, shell=True)
	
def ftpmount (url, action):
	mountpoint = cfg.config('mountpoint')
	if action == 'mount':
		if os.path.isdir(mountpoint):
			command = ('beesu  "curlftpfs   -o allow_other  %s    %s"')  %  (url, mountpoint)
		else:
			command = ('beesu  "mkdir   -p %s &&  curlftpfs  -o allow_other  %s   %s"') % (mountpoint, url, mountpoint)
		try:		
			ret = subprocess.call(command, shell=True)
		except:
			ret = 2
		if ret == 0:
			dialog_text = (url + '<br>mount - OK')
			code = 0
		else:
			dialog_text = (url + '<br>mount - FAIL!!!')
			code = 1
	else:
		command = ('beesu  "umount  %s && rm -rf  %s"') % (mountpoint, mountpoint)
		try:
			ret = subprocess.call(command, shell=True)
		except:
			ret = 2
		if ret == 0:
			dialog_text = (url + '<br>unmount - OK')
			code = 0
		else:
			dialog_text = (url + '<br>unmount - FAIL!!!')
			code = 1
	
	return  [ dialog_text, code ]


def delmod (modname):
	command = ('beesu  rm -rf "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '<br>delete - OK')
	else:
		dialog_text = (modname + '<br>delete - FAIL!!!')
			
	return dialog_text

 	
if __name__ == '__main__':
	print 'it is a library for mod_mnger.py'


