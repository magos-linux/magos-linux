#!/usr/bin/python3

def search_getpfs(findmod):
	import os 
	command = ('pfsget -g -s  ' + findmod)  
	ret = os.popen( command ).read()
	flist = []
	for key_val in ret.split('\n'):
		if len(key_val.split(':>>')) == 2:
				flist.append( [ key_val.split(':>>')[0],  key_val.split(':>>')[1] ] )
	return flist 


def download_getpfs(mod, flags):
	command = ('./getpfs/getpfs -g -s  ' + findmod)

def modsLi(findmod):
	flist = search_getpfs(findmod)
	fli = ''
	for a in flist:
		fli = fli + '<li>' + a[0] + ' ' +  a[1] + '</li>' + '\n'
	return fli

def getpfs(findmod):
	tab = (
	'<tr><td colspan="3">Заголовок</td></tr>' 
	'<tr><td width=15%></td><td>'
	'<ul>' + modsLi(findmod) + '</ul>'
	'</td><td width=20%></td><tr>'
	)
	return tab


ans = getpfs('DEVX')

print(ans)
