#!/usr/bin/python
# -*- coding:utf-8 -*-
import os, re, subprocess, shutil

def getPhysical():
	fdisk = {}
	command = ('beesu fdisk -l')
	ret = os.popen( command ).read()
	for str in re.findall('Disk.* .*B', ret):
		fdisk[str.split()[1].strip(':')] = str.split()[2:4]
	return fdisk

def getLogical():
	arr = {}
	command = ('beesu blkid -s TYPE  -s LABEL |grep  "/dev/sd"')
	for key_val  in os.popen( command ).read().split('\n'):
		if len(key_val.split()) == 3:
			command = ( 'df -h  ' +  key_val.split()[0].strip(':'))
			df = os.popen( command ).read().split('\n')[1].split()[1:6]
			arr[key_val.split()[0].strip(':')] = [key_val.split()[1].replace('LABEL=', '').strip('"'), ]
			arr[key_val.split()[0].strip(':')].append (key_val.split()[2].replace('TYPE=', '').strip('"'))
			for a in df:
				arr[key_val.split()[0].strip(':')].append(a)
		if len(key_val.split()) == 2: 
			command = ( 'df -h  ' +  key_val.split()[0].strip(':'))
			df = os.popen( command ).read().split('\n')[1].split()[1:6]
			arr[key_val.split()[0].strip(':')] = ['nolabel', ]
			arr[key_val.split()[0].strip(':')].append (key_val.split()[1].replace('TYPE=', '').strip('"'))	
			for a in df:
				arr[key_val.split()[0].strip(':')].append(a)
			
	
	
	for  key, val in arr.items():
		if val[6] != '/dev':
			dirls = os.listdir(val[6])
			if len(dirls) > 0:
				arr[key] = arr.get(key), dirls
			else:
				arr[key] = arr.get(key), ['disk empty',]
		else:
			val[2] = '---'
			val[3] = '---'
			val[4] = '---'
			val[5] = '---'
			val[6] = '---'
			if  val[0] != 'swap':
				arr[key] = arr.get(key), ['is not mounted',]
			else:
				arr[key] = arr.get(key), ['swap partition',]
	return arr

	

if __name__ == '__main__':

	physical = getPhysical()
	logical =  getLogical()

	print logical
	print '-----------------------------------***'
	print physical 
	
	#for key, val in physical.items():
	#	print 'disk:' + key + '  ' + val[0] + '  ' +val[1]
	#	for key1, val1 in logical.items():
	#		if key1[:-1] == key:
	#			print key1 + ':   ', val1[0] 
	#			print 'dirList: '
	#			for f in val1[1]: 	print f


