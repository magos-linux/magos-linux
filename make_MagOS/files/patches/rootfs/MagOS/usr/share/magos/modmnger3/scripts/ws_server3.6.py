#!/usr/bin/env python3
#-*- coding:utf-8 -*-
import subprocess, sys, os, lib_ws
import asyncio
import websockets

HOST='0.0.0.0'
PORT=8001

def unlock():
	try: 
		os.remove('/tmp/pfsgui_lock')
		os.remove('/tmp/pfsgui_stop')
	except:
		pass
		
def lock():		
	try: 
		os.remove('/tmp/pfsgui_stop')
		open('/tmp/pfsgui_lock', 'tw').close()
	except:
		pass

def runit(script, args):
	if script.split('_')[0] == 'py':
		if script == 'py_activate':
			a = lib_ws.activate(args)
			return  ('alert', a )
		elif script == 'py_deactivate':
			a = lib_ws.deactivate(args)
			return ('alert', a )
		elif script == 'py_mv2':
			a = lib_ws.mv2(args)
			return ('alert', a )
		elif script == 'py_modinfo':
			a = lib_ws.modinfo(args)
			return ('table', a )
		elif script == 'py_delmod':
			a = lib_ws.delmod(args)
			return ( 'answer', a )
		elif script == 'py_findit':
			a = lib_ws.findit(args)
			return ('table', a )
		elif script == 'py_getpfs':
			a = lib_ws.getpfs(args)
			return ('table', a )
		elif script == 'py_pfsDownload':
			a = lib_ws.pfsDownload(args)
			return ('table', a )
		elif script == 'py_updateRep':
			a = lib_ws.updateRep()
			return ('table', a )
		elif script == 'py_readMirrors':
			a = lib_ws.readMirrors()
			return ('table', a )
		elif script == 'py_switchRep':
			lib_ws.switchRep(args)
			a = lib_ws.readMirrors()
			return ('table', a )
		elif script == 'py_addRep':
			lib_ws.addRep(args)
			a = lib_ws.readMirrors()
			return ('table', a )	
		elif script == 'py_delRep':
			lib_ws.delRep(args)
			a = lib_ws.readMirrors()
			return ('table', a )	
		elif script == 'py_killws':
			return	'exit'

connected = set()
async def handler(websocket, path):
	connected.add(websocket)
	try:
		await asyncio.wait([ws.send('answer::websocket connected') for ws in connected])
		await asyncio.sleep(5)
	finally:
		connected.remove(websocket)	
	async for message in websocket:
		print('<%s' % (message))
		lock()
		msg_split = message.split( '::' )
		if msg_split[0] in [ 'py_modinfo', 'py_findit', 'py_getpfs', 'py_pfsDownload', 'py_updateRep' ]:
			await websocket.send('table::' + lib_ws.waiting() )
		ret = runit(msg_split[0], msg_split[1])
		if ret == 'exit':
		    sys.exit()
		await websocket.send(ret[0] + '::' + ret[1])
		unlock()	
		
print('waiting clients. Host: ' + HOST + ', port: ' + str(PORT))  
start_server = websockets.serve(handler, HOST, PORT)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
