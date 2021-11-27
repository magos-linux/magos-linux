#!/usr/bin/env python3
#-*- coding:utf-8 -*-
import subprocess, sys, os, websockets, asyncio
from datetime import datetime
from time import sleep
URL = 'http://127.0.0.1:8000/cgi-bin/mod_map.py'
WS = "ws://127.0.0.1:8001"
bwser = 'xdg-open'
#bwser = './scripts/bwsr_gtk3.py'
timeout = 300

if len(sys.argv) > 1:
	bwser = sys.argv[1]
if len(sys.argv) > 2:
	URL = sys.argv[2]

def timer(): 
	while not os.path.exists('/tmp/pfsgui_stop'):
		if not os.path.exists('/tmp/pfsgui_lock'):
			open('/tmp/pfsgui_stop', 'tw').close()
		sleep(timeout)

async def killws():
	async with websockets.connect(WS) as websocket:
		await websocket.send('py_killws::update')
	
try:
	os.remove('/tmp/pfsgui_stop')
except:
	pass
	
path = os.popen( 'realpath ./scripts/server.py' ).read()
httpSrv =  subprocess.Popen(path, shell=True)

startBwsr = ( bwser + ' ' + URL )
start_time = datetime.now()
ret = subprocess.call(startBwsr, shell=True)
time = (datetime.now() - start_time)

if time.seconds < 3:
	timer()

httpSrv.kill()
asyncio.get_event_loop().run_until_complete(killws())
