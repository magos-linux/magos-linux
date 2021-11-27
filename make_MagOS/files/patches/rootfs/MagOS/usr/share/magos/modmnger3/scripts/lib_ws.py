#!/usr/bin/python3
import os, re, sys, subprocess, shutil,  glob, cfg 
#from time import sleep

def activate (modname):
	command = ('pfsload "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '  activation - OK!!!')
	else:
		dialog_text = (modname + '  activation FAIL!!!')
	return dialog_text

def deactivate (modname):
	command = ('pfsunload "' + modname.replace(' ', '\ ') + '"')
	ret = subprocess.call(command, shell=True)
	if ret == 0:
		dialog_text = (modname + '  deactivation - OK!!!')
	else:
		dialog_text = (modname + '  deactivation FAIL!!!')
	return dialog_text


def mv2 (modname):
	dialog_text = (modname + '  rename - OK!!!')
	if '/modules/' in modname:
		dest=modname.replace('/modules/', '/optional/')
	elif '/optional/' in modname:
		dest=modname.replace( '/optional/', '/modules/')
	try:
		shutil.move(modname.replace(' ', '\ '), dest)
	except:
		command = ('mv -f "' + modname.replace(' ', '\ ') + ' ' + dest + '"')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = (modname + '  rename FAIL!!!')
	return dialog_text

def cp2 (modname, destDir):
	dialog_text = (modname + '  copy - OK!!!')
	try:
		shutil.copy(modname, destDir)
	except:
		command = ('cp "' + modname.replace(' ', '\ ') + ' ' + destDir + '/"')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = (modname + '<br>copy -  FAIL!!!')

	return dialog_text

def delmod (modname):
	dialog_text = (modname + '  remove - OK!!!')
	try:
		os.remove(modname)
	except:	
		command = ('rm -rf "' + modname.replace(' ', '\ ') + '"')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = (modname + '  delete - FAIL')
	return dialog_text


def modinfo (modname):
	import sys, os, re, cfg, gettext
	gettext.install('mod_mnger', localedir='./locale', codeset=None, names=None)
	#for gettext
	header = _('Info: ') 
	doc = _('additional info: ') 
	compress = _('compression' )
	filelist = _('files list' )
	modsize = _('module size')
	dirsize = _('extracting module size')
	packages = _('packages ')
	depends = _('dependenses ')
	algorithm = _('compression algorithm ')

	def getarr(info):
		arr = {}
		for key_val in info:
			if len(key_val.split(': ')) == 2:		
				arr[key_val.split(': ')[0].replace(' ', '_')] = key_val.split(': ')[1]
		return arr
 
	def getlist(modname):
		command = ('unsquashfs -l  ' + modname )
		ret = os.popen( command ).read()
		flist = []
		for string  in ret.split('\n'):
				flist.append( string.replace('squashfs-root', ''))
		return flist

	def getinfo(modname):
		command = ('pfsinfo --stat  ' + modname  )
		ret = os.popen(command).read()
		info = []
		for string  in ret.split('\n'):
				info.append( string )
		return info

	flist = getlist(modname)
	info = getinfo(modname)
	keyarr = getarr(info)
	str1 = '<tr><td  class="td_info"> %s - %s  <br> %s - %s <br> %s - %s  <br> %s - %s  </td>' % ( algorithm,  keyarr['Compression_algorithm'],  modsize, keyarr['Module_size'], dirsize, keyarr['Uncompressed_size'], compress,  keyarr['Compression_ratio'] )
	str2 = '<td  class="td_info"> %s - <br>%s <br> %s - <br> %s  </td></tr>' % ( packages, keyarr['Modules'], depends, keyarr['Dependenses'] )

	table_part = (
	'<table>'
	'<tr><td colspan="2"><h1 align="center">' 
	' ' + header +  modname + '</h1></td></tr>'
	' ' + str1 + ' '
	' ' + str2 + ' '
	'<tr><td colspan="2"><h3>' + doc + '</h3></tr></td>' 
	'<tr><td colspan="2" height="10%" class="td_info">'
	)
	begin = 'no'
	info_part = ''
	for a in info:
		if begin == 'yes':
			info_part = info_part + a + '<br>'
		if len(a) == 0:
			begin = 'yes'
	fheader_part = (
	'</td></tr>'
	'<tr class="list"><td colspan="2"><h3>' + filelist + ' </h3></td></tr>'
	'<tr height="600px"><td colspan="2" id="file_list" class="td_info">'
	)
	begin = 'no'
	flist_part = ''
	for a in flist:
		if begin == 'yes':
			flist_part = flist_part + a + '<br>'
		if len(a) == 0:
			begin = 'yes'
	end_part = '</td></tr></table>'
	return table_part + ' ' + info_part + ' ' + fheader_part + ' ' + flist_part + ' ' + end_part
	

def findit(findit):
	import gettext
	gettext.install('mod_mnger', localedir='./locale', codeset=None, names=None)
	header = _('Found ') 
	layer_number = _('layer number ')
	module = _('module name ')
	bundle = _('module mount point ')
	submodule = _('pfs submodule ')
	path = _('path to file')
	changes = _('filename  finded in top layer - "changes" ')
	not_found = _('not found')
	
	command = ('pfsfind  ' + findit + ' --raw  \'${n} ${module} ${bundle} ${submodule} ${path}\'' )
	ret = os.popen( command ).read()
	findstr=[]
	for string in ret.split('\n'):		
		tpl = (string.split(' '))
		if len(tpl) == 5:
			findstr.append(tpl) 
	if len(findstr) != 0:
		ret_b = ''
		ret_a = ( 
		'<tr><td colspan="5"><h1 align="center">' + header + '</h1></td></tr><tr>' + '\n'
		'<td class="td_info" >' + layer_number + '</td><td class="td_info">' + module + '</td><td class="td_info">' + bundle  + '</td>' + '\n'
		'<td class="td_info">' + submodule + '</td><td class="td_info">' + path + '</td class="td_info"></tr>' + '\n'
		)
		for string in  findstr:
			if int(string[0]) != 0:
				ret_b = ret_b + '<tr><td>' + string[0] + '</td><td>' + string[1] + '</td><td>' + string[2] + '</td><td>' + string[3]  + '</td><td>' + string[4] + '</td></tr>'
			else:
				ret_b = ret_b + '<tr><td>' + string[0] + '</td><td colspan="3" align="center">' + changes + '</td><td>' + string[4] + '</td></tr>'
	else:
		ret_a = '<h2>' + findit + '   ' + not_found + '</h2>'
	return '<table class="mod_table">' + ret_a + '\n' + ret_b + '</table>'
	
def getpfs(findmod):
	def search_getpfs(findmod):
		command = ('pfsget -g -s  ' + findmod)  
		ret = os.popen( command ).read()
		flist = []
		for key_val in ret.split('\n'):
			if len(key_val.split(':>>')) == 2:
				flist.append( [ key_val.split(':>>')[0],  key_val.split(':>> ')[1] ] )
		return flist 

	def modsTr(findmod):
		flist = search_getpfs(findmod)
		ftr = ''
		checked = ''
		color_class=''
		n = 0
		for a in flist:
			n = n + 1
			if a[0] == 'new':
				color_text = '<font color="green">'
				checked = 'checked'
			elif a[0] == 'old':
				color_text = '<font color="grey">'
			else:
				color_text = '<font color="red">'
			if len(a[1]) < 2:
				continue 
			if n%2==0:
				color_class = 'class="tr_grey"'
			ftr = ( 
			' ' + ftr + '<tr ' + color_class + ' ><td><a href="' + a[1] + '">' + color_text + a[1] + '</font></a></td>' + '\n' 
			'<td><input type="radio" name="found_mods" id="(found_mods" value="' + a[1] + '"' + checked + '>' + '\n'
			'</td></tr>' + '\n'
			)
			checked = ''
			color_class=''
		return ftr

	return modsTr(findmod)
	
def waiting():
	waiting = (
	'<div align="center" class="overlay-loader">'
	'<div class="loader">'
	'	<div></div>'
	'	<div></div>'
	'	<div></div>'
	'	<div></div>'
	'	<div></div>'
	'	<div></div>'
	'	<div></div>'
	'</div>'
	'</div>'
	)
	return waiting 

def pfsDownload(actions):
	argslist = actions.split(',')
	xterm = ''
	retvar = 'Выполнено: <br>'
	pfsgetargs = ''
	if 'load' in argslist:
		pfsgetargs = pfsgetargs + ' -l ' 
	if not 'pwd' in argslist:
		pfsgetargs = pfsgetargs + ' -i '
	if 'xterm' in argslist:
		xterm = 'xterm -e '
		retvar = 'Завершено!!! <br>'
	else:
		pfsgetargs = pfsgetargs + ' -f '
	command = ( xterm + 'pfsget ' + pfsgetargs + ' ' + argslist[0])
	ret = os.popen( command ).read()
	for key_val in ret.split('\n'):
		retvar = retvar + key_val + '<br>'
	return retvar

def updateRep():
	retvar = ''
	command = ( 'pfsget -u ')
	ret = os.popen( command ).read()
	for key_val in ret.split('\n'):
		retvar = retvar + key_val + '<br>'
	return retvar

def switchRep(rep):
	editRep(rep, 'switch')

def delRep(rep):
	editRep(rep, 'del')

def addRep(rep):
	editRep(rep, 'add')


def editRep(rep, action):
	command = ('. pfs ;echo $mirror_list')
	mirrorlist = os.popen( command ).read().replace( '\n', '' )
	if os.path.exists( str(mirrorlist) ):
		fr = open(mirrorlist, 'r') 
		old = []
		for string in fr.readlines():
			if len(string) > 3:
				old.append(string)
		fr.close()
		if action == 'switch' or action == 'del':
			fw = open(mirrorlist, 'w')
			for string in old:
				if rep in string:
					if action == 'del':
						pass
					else: 
						if string.replace(' ', '')[0] == '#':
							fw.write(rep + '\n')
						else:
							fw.write('#' + rep + '\n')
				else:
					fw.write(string.replace(' ', ''))
		elif action == 'add':
			fw = open(mirrorlist, 'a')
			fw.write(rep + '\n')
		fw.close()

def readMirrors():
	n = 1
	checkboxes = []
	color_class = ''
	command = ('. pfs ;echo $mirror_list')
	mirrorlist = os.popen( command ).read().replace( '\n', '' )
	if os.path.exists( str(mirrorlist) ):
		retvar = '<table><tr><th colspan=3>' + mirrorlist  + ':</th></tr>' + '\n'
		f = open(mirrorlist, 'r') 
		a = []
		for string in f.readlines():
			if len(string) > 3:
				a.append(string)
		f.close()
		for item in a:
			n = n + 1
			item =  item.replace('\n', '').replace(' ','')
			if n%2==0:
				color_class = 'class="tr_grey"'
			if item[0] == '#':
				mirror = item.replace('#', '')
				retvar = (
				' ' + retvar + '<tr ' + color_class + ' ><td>' + mirror + '</td>' + '\n'
				'<td><input type="button" id="but_' + str(n) + '" value="Enable"' + '\n'
				' onclick="ws.send(\'py_switchRep::'  + mirror + '\')" ></td>'
				'<td><input type="button" id="delbut_' + str(n) + '" value="Delete"' + '\n'
				' onclick="ws.send(\'py_delRep::'  + mirror + '\')" ></td>'
				'</tr>' + '\n'
				)
			else: 
				retvar = ( 
				' ' + retvar + '<tr ' + color_class + ' ><td>' + item + '</td>' + '\n'
				'<td><input type="button" id="but_' + str(n) + '" value="Disable" ' + '\n'
				'  onclick="ws.send(\'py_switchRep::'  + item + '\')" ></td><td></td></tr>' + '\n'
				)
			color_class = ''
	new_mirror = (
		'<tr><th colspan=3>Добавить репозиторий:</th></tr>' + '\n'
		'<tr><td>' + '\n'
		'<input  type="text" size="50" value="http://" name="newrep" id="newrep"></td><td>' + '\n' 
		'<input type="button" onclick="send_newrep()" value="Send" ></td><td></td></tr></table>' + '\n'
	)
	return retvar + new_mirror 
		
		
def install(disk):
		dialog_text=install_OK
		command = ('xterm -e  ./scripts/autoinstall.sh ' + disk + ' ')
		ret = subprocess.call(command, shell=True)
		try:
			text = install_fail
			f = open('/tmp/errorcode', 'r')
			for string  in f.readlines():
				text = text + '  ' + string
			dialog_text = (  str(text.replace('\n', '')) )
			f.close()
		except: 
			dialog_text=install_OK
		if ret != 0:
			dialog_text = ( dialog_text + '<br>Oooops, somebody killed xterm :(' )
		return dialog_text		

def get_disks():
	from disks import getPhysical
	from disks import getLocals
	physical = getPhysical()
	logical = getLogical()
	retvar = ''
	for key, val in list(physical.items()):
		retlist = []
		retlist.append('<tr><td rowspan="2" class="bordered_td"><input type="radio" name="physical"  value="' + key + '">')
		retlist.append('</td><td class="bordered_td"><b>' + key + '</b></td>')
		retlist.append('<td class="bordered_td"> ' + val[0]  + ' ' + val[1] + '</td></tr>')
		retlist.append('<tr><td colspan="2" class="bordered_td">')
		for key1, val1 in list(logical.items()):
				if key1[:-1] == key:
					retlist.append('<i>' + key1 + ':</i>  ' + val1[0][0] + ';   ' + val1[0][1])  
					retlist.append('<div title="dirList:             ')
					for f in val1[1]: 	
						retlist.append(f + ', ')
					retlist.append('">mount: ')  
					if val1[0][6] != '/dev': 
						retlist.append(val1[0][6])
					else: 
						retlist.append(not_mouted)
					retlist.append('</div><br>')
		retlist.append('</td></tr>')
	retvar = print('\n'.join(retlist))
	return retvar

if __name__ == '__main__':
	print('it is a library for mod_mnger.py')


