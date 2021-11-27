#!/usr/bin/python3
#-*- coding:utf-8 -*-
import subprocess, sys, os, lib_ws
from websocket_server import WebsocketServer

PORT=8001
host='0.0.0.0'
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
			send_msg('alert', a )
			return
		elif script == 'py_deactivate':
			a = lib_ws.deactivate(args)
			send_msg('alert', a )
			return
		elif script == 'py_mv2':
			a = lib_ws.mv2(args)
			send_msg('alert', a )
			return
		elif script == 'py_modinfo':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.modinfo(args)
			send_msg('table', a )
			return
		elif script == 'py_delmod':
			a = lib_ws.delmod(args)
			send_msg( 'answer', a )
			return
		elif script == 'py_findit':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.findit(args)
			send_msg('table', a )
			return
		elif script == 'py_getpfs':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.getpfs(args)
			send_msg('table', a )
			return
		elif script == 'py_pfsDownload':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.pfsDownload(args)
			send_msg('table', a )
			return
		elif script == 'py_updateRep':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.updateRep()
			send_msg('table', a )
			return
		elif script == 'py_readMirrors':
			send_msg( 'table', lib_ws.waiting() )
			a = lib_ws.readMirrors()
			send_msg('table', a )
			return
		elif script == 'py_switchRep':
			send_msg( 'table', lib_ws.waiting() )
			lib_ws.switchRep(args)
			a = lib_ws.readMirrors()
			send_msg('table', a )
			return
		elif script == 'py_addRep':
			send_msg( 'table', lib_ws.waiting() )
			lib_ws.addRep(args)
			a = lib_ws.readMirrors()
			send_msg('table', a )
			return	
		elif script == 'py_delRep':
			send_msg( 'table', lib_ws.waiting() )
			lib_ws.delRep(args)
			a = lib_ws.readMirrors()
			send_msg('table', a )
			return	
		elif script == 'py_killws':
			unlock()
			server.server_close()
			server.shutdown()
			sys.exit()
			return 

# Called for every client connecting (after handshake)
def new_client(client, server):
	print("New client connected and was given id %d" % client['id'])
	send_msg('answer', 'websocket server started')

# Called for every client disconnecting
def client_left(client, server):
	print("Client(%d) disconnected" % client['id'])

# Called when a client sends a message
def message_received(client, server, message):
	print('<%s' % (message))
	lock()
	msg_split = message.split( '::' )
	runit(msg_split[0], msg_split[1])
	
def send_msg(var, val):
	server.send_message_to_all(var + '::' + val)
	unlock()

unlock()
server = WebsocketServer(PORT, host)
server.set_fn_new_client(new_client)
server.set_fn_client_left(client_left)
server.set_fn_message_received(message_received)
server.run_forever()


