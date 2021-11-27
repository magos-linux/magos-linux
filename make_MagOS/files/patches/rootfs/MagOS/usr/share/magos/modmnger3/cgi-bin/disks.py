#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os, re, subprocess, shutil

def getPhysical():
	fdisk = {}
	command = ('beesu LC_MESSAGES=C fdisk -l |grep /dev/sd')
	ret = os.popen( command ).read()
	for str in re.findall('Disk.* .*B', ret):
		fdisk[str.split()[1].strip(':')] = str.split()[2:4]
	return fdisk

def getLogical():
	arr = {}
	arrmnt = getmntArr()
	command = ('beesu LC_MESSAGES=C /sbin/blkid -s TYPE  -s LABEL |grep  "/dev/sd"')
	for key_val  in os.popen( command ).read().split('\n'):
		if len(key_val.split()) > 1:
			if len(key_val.split()) == 3:
				arr[key_val.split()[0].strip(':')] = [key_val.split()[1].replace('LABEL=', '').strip('"'), ]
				arr[key_val.split()[0].strip(':')].append (key_val.split()[2].replace('TYPE=', '').strip('"'))
			if len(key_val.split()) == 2: 
				arr[key_val.split()[0].strip(':')] = ['nolabel', ]
				arr[key_val.split()[0].strip(':')].append (key_val.split()[1].replace('TYPE=', '').strip('"'))	
			if key_val.split()[0].strip(':') in arrmnt:
				for a in arrmnt[key_val.split()[0].strip(':')] :
					arr[key_val.split()[0].strip(':')].append(a)
	for  key, val in list(arr.items()):
		if len(val) == 7 :
			dirls = os.listdir(val[6])
			if len(dirls) > 0:
				arr[key] = arr.get(key), dirls
			else:
				arr[key] = arr.get(key), ['disk empty',]
		else:
			add = [ '---', '---','---', '---', '---' ]
			arr[key] = val + add 
			if  val[1] != 'swap':
				arr[key] = arr.get(key), ['is not mounted',]
			else:
				arr[key] = arr.get(key), ['swap partition',]
	return arr


def getmntArr ():
	arrmnt = {}
	command2 = ( 'findmnt -lnC -o SOURCE,SIZE,USED,AVAIL,USE%,TARGET |grep sd' )
	for line  in os.popen( command2 ).read().split('\n'):
		if len(line.split()) > 5:
			arrmnt[line.split()[0] ] =  ( line.split()[1], line.split()[2], line.split()[3], line.split()[4], line.split()[5] ) 
	return arrmnt

if __name__ == '__main__':

	physical = getPhysical()
	logical =  getLogical()
	mnt = getmntArr()

	#print logical
	#print '-----------------------------------***'
	#print physical 
	#print '-----------------------------------***'
	#print mnt
	
	for key, val in list(physical.items()):
		print(key + ':    ' + val[0] + '  ' +val[1])
		for key1, val1 in list(logical.items()):
			if key1[:-1] == key:
				print(key1 + ':   LABEL=' + val1[0][0], 'FS=' + val1[0][1], 'SIZE='+ val1[0][2], 'USED=' + val1[0][3], 'FREE=' + val1[0][4], 'USED%=' + val1[0][5], 'MOUNT=' + val1[0][6])
				print('            ', val1[1])
		print('')
		


