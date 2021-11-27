#!/usr/bin/python3
# -*- coding:utf-8 -*-
import sys, os, re, cgi, lib_mod_map, cfg, gettext

gettext.install('mod_mnger', localedir='./locale', codeset=None, names=None)
n = 1 

# анализ cgi запроса
form = cgi.FieldStorage()
wsaction = form.getvalue('wsaction') or 'none'
password = form.getvalue('pass') or 'pass'
if wsaction == 'start' or wsaction == 'stop':
    lib_mod_map.start_ws(wsaction, password)

modmap = _('Modules map')
update = _('Update')
modfind = _('Find modules in repository')
allowroot = _('Allow root actions')
denyroot = _('Deny root actions')
updaterep = _('Update repository')
readmirrors = _('Edit mirrors')

def print_updateform ():
    print('<form>')
    print(' <input name="update_button" id="update_button" type="submit"')
    print(' value="%s" onclick="window.location.assign(document.URL)"></form>' % (update))

def print_getws ():
    print('<form action="/cgi-bin/pfsget.py">')
    print('<input type="password" maxlength="25" size="20" name="pass" id="pass">')
    print('<input name="wsaction" type="hidden" id="wsaction" value="start">') 
    print('<input name="bt_getws" id="bt_getws" type="submit" value="%s">' % (allowroot))
    print('</form>')

def print_findform ():
    print('<form name="getpfs_form" id="getpfs_form" >')
    print('<input name="getpfs" type="text" id="getpfs" >')
    print('<input type="submit" value="%s">' % (modfind))
    print('</form>')

def print_modmap ():
    print('<input name="goto_modmap" id="goto_modmap" type="submit" value="%s"' % (modmap))
    print('onclick="window.location.href = \'/cgi-bin/mod_map.py\';">')
    
def print_updateRep ():
    print('<input name="updaterep" id="updaterep" type="button" value="%s"' % (updaterep))
    print('onclick="ws.send(\'py_updateRep::update\');">')

def print_readMirrors ():
    print('<input name="readmirrors" id="readmirrors" type="button" value="%s"' % (readmirrors))
    print('onclick="ws.send(\'py_readMirrors::update\');">')

def print_killws ():
    print('<input name="readmirrors" id="readmirrors" type="button" value="%s"' % (denyroot))
    print('onclick="denyRoot();">')


def get_ip():
	command = ('./scripts/ip')
	ret = os.popen( command ).read()
	return os.popen( command ).read().split()[0]
	
def wsscript():
	print('<script>') 
	print('var ws = new WebSocket("ws://' + get_ip() + ':8001");')
	print('var denyroot = \'' + denyroot + '\';')
	print('var allowroot = \'' + allowroot + '\';')
	print( """ws.onclose = function(event) {
	document.getElementById('status').innerHTML+='Root прав нет<br>';
	document.getElementById('killwsB').className='hidden_button';
	document.getElementById('getwsB').className='show_button';
};

ws.onopen = function() {
  document.getElementById('killwsB').className='show_button';
  document.getElementById('getwsB').className='hidden_button';
  document.getElementById('status').innerHTML+="Root права предоставлены<br>";
};

ws.onmessage = function(event) {
  message = event.data
  if  ( message.indexOf("answer:") == 0 ) {
  document.getElementById('status').innerHTML+=event.data.split("::")[1] + '<br>';
  } else if  ( message.indexOf("table:") == 0 ) {
  document.getElementById('found_table').innerHTML=event.data.slice(7) + '<br>';
  } else if  ( message.indexOf("alert:") == 0 ) {
  alert(event.data.split("::")[1]);
  window.location = window.location.href.split("?")[0];
  return false;
  };  
};

ws.onerror = function(error) {
  document.getElementById('status').innerHTML+='Websocket error:  ' + error.message + '<br>';
};

document.forms.getpfs_form.onsubmit = function() {
  let message = this.getpfs.value;
  ws.send('py_getpfs::' + message);
  return false;
};

function radiocheck(action) {
	var checked;
	var checkload = document.getElementById('check_pfsload');
	var checkpwd = document.getElementById('check_pwd');
	var checkxterm = document.getElementById('check_xterm');
	var rad = document.getElementsByName('found_mods');
	if (checkload.checked) {
		var checked = 'load';
	};
	if (checkpwd.checked) {
		var checked = (checked + ',' + 'pwd');
	};
	if (checkxterm.checked) {
		var checked = (checked + ',' + 'xterm');
	};
	for (var i = 0; i < rad.length; i++) {
        if (rad[i].checked) {
			var confirmed = confirm('Download: ' + rad[i].value)
			if (confirmed) {
            ws.send('py_pfs' + action + '::' + rad[i].value + ',' + checked);
            }; 
        };
    };
};

function send_newrep() {
	let message = this.newrep.value;
	ws.send(\'py_addRep::\' + message);
	return false;
	};

function denyRoot() {
	ws.send(\'py_killws::update\');
	window.location = window.location.href.split("?")[0];
	return false;
	};
</script> """)

# make html header
cfg.html_header()
print("""
<style>
    body{
    cursor: pointer /* cursor like hand */
    }<script type="text/javascript">
$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
});
</style> """)

# javascript functions 
print("""
	<script type="text/javascript">
	function textBig( elmId ) {
	document.getElementById( elmId ).style.fontSize="110%";
	}
	function textNormal( elmId ) {
	document.getElementById( elmId ).style.fontSize="100%";
	}
	function action( elmId, action ) {
	document.getElementById( elmId ).value=action;
	}
 	</script> """)

# кнопки сверху
print('<div class="wrap">')
print('<div class="bblockL">')
print_updateform()
print('</div><div class="bblockL">')
print('<div id="getwsB" name="getwsB" class="show_button">')
print_getws()
print('</div>')
print('<div id="killwsB" name="killwsB" class="hidden_button">')
print_killws()
print('</div>')
print('</div><div class="bblockR">')
print_modmap()
print('</div></div>')

#таблица
print(
	'<div class="wrap">'
	'<div class="wrap-tr">'
	'<div class="bblockTH">Репозиторий</div>'
	'<div class="bblockTH">'
	)

print_findform() 
print(
	'</div>' 
	'<div class="bblockTH">Действия</div></div>'
	'<div class="wrap-tr">'
	'<div class="bblockB">'
	)
	
print_updateRep()
print_readMirrors()
print(	
	'</div>'
	'<div class="bblockC">'
	'<table width=100% class="mod_table" id="found_table" name="found_table"></table></div>'
	'<div class="bblockB">'
	'<input type="checkbox" name="check_pfsload" id="check_pfsload" value="pfsload" checked >Подключить после загрузки<br>'
	'<input type="checkbox" name="check_pwd" id="check_pwd" value="pwd">Загрузить в текущий каталог вместо "modules"<br>'
	'<input type="checkbox" name="check_xterm" id="check_xterm" value="xterm">Выполнить в терминале<br>'
	'<input type="button" value="install" onclick="radiocheck(\'Download\');" >'
	'</div></div></div>'
	)
	
#нижние кнопки и статусбар
print('<div class="wrap">')
print('<div class="bblockL">')
print('<div id="status" name="status" class="statusCL" >Pfsget started<br></div></div></div>')
wsscript()
print('</body></html>')




