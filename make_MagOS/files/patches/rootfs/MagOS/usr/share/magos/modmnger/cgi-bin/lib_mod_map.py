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
	for val in modArr.values():
		folders.append(val[1])
	for item in folders:
		dirlist.append(item) 
		dirlist.append(item.replace( 'modules', 'optional') ) 
	dirlist = list(set(dirlist))
	dirlist.sort()
	return dirlist	

def getModGreen(modArr, dirPath):
	green_arr = {}
	for key, val in modArr.items():
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
	for val in green_arr.values():
		green_list.append(val)
	grey_list = list( set(dirLs) - set(green_list) )  
	return grey_list 
		
def activate (modname):
	command = ('beesu pfsload "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '<br>activation - OK!!!')
	else:
		dialog_text = (modname + '<br>activation FAIL!!!')
	return dialog_text
 	
def deactivate (modname):
	command = ('beesu pfsunload "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '<br>deactivation - OK!!!')
	else:
		dialog_text = (modname + '<br>deactivation FAIL!!!')
	return dialog_text

	 
def mv2 (modname):
	dialog_text = (modname + '<br>rename - OK!!!')
	if '/modules/' in modname:
		dest=modname.replace('/modules/', '/optional/')
	elif '/optional/' in modname:
		dest=modname.replace( '/optional/', '/modules/')
	try:
		shutil.move(modname.replace(' ', '\ '), dest)
	except:
		command = ('beesu  mv -f "' + modname.replace(' ', '\ ') + ' ' + dest + '"')
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
	command = ('./mod_info  "%s" ')  %  modname.replace(' ', '\ ') 
	#print command
	subprocess.Popen(command, shell=True)
	
def  pfsfind (findit):
	command = ('./pfs_find  "%s" ')  %  findit 
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


