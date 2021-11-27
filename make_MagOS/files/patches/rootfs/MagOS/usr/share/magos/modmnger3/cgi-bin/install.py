#!/usr/bin/python3
# -*- coding:utf-8 -*-
import  gettext,  cgi, cfg, os
from lib_mod_map import start_ws

#gettext.install('install-helper', './locale', str=True)
gettext.install('install-helper', localedir='./locale', codeset=None, names=None)
dialog_text = 'none'


# messages for gettext
install_header  = _('MagOS linux install helper')
install_help = _('This is a simple MagOS linux installator. You must select automatic or step by step mode. ')
autoinstall_link = _('Automatic installation')
stepbystep_link = _('Step by step  installation')
help_= _('Help!')
update_link= _('Update MagOS')
update = _('Update')
allowroot = _('Allow root actions')
denyroot = _('Deny root actions')

# анализ cgi запроса
form = cgi.FieldStorage()
wsaction = form.getvalue('wsaction') or 'none'
password = form.getvalue('pass') or 'pass'
if wsaction == 'start' or wsaction == 'stop':
    start_ws(wsaction, password)

def print_updateform ():
    print('<form>')
    print(' <input name="update_button" id="update_button" type="submit"')
    print(' value="%s" onclick="window.location.assign(document.URL)"></form>' % (update))

def print_getws ():
    print('<form action="/cgi-bin/install.py">')
    print('<input type="password" maxlength="25" size="20" name="pass" id="pass">')
    print('<input name="wsaction" type="hidden" id="wsaction" value="start">') 
    print('<input name="bt_getws" id="bt_getws" type="submit" value="%s">' % (allowroot))
    print('</form>')

def print_killws ():
    print('<input name="readmirrors" id="readmirrors" type="button" value="%s"' % (denyroot))
    print('onclick="denyRoot();">')

def print_help():
	print('<div class="set"><form action="/cgi-bin/install_help.py" method="post"  name="help">')
	print('<input type="hidden" name="back" value="/cgi-bin/install.py">')
	print('<button type="submit">' + help_ + '</button></form></div>')



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
  document.getElementById('base_table').innerHTML=event.data.slice(7) + '<br>';
  } else if  ( message.indexOf("alert:") == 0 ) {
  alert(event.data.split("::")[1]);
  window.location = window.location.href.split("?")[0];
  return false;
  };  
};

ws.onerror = function(error) {
  document.getElementById('status').innerHTML+='Websocket error:  ' + error.message + '<br>';
};

function denyRoot() {
	ws.send(\'py_killws::update\');
	window.location = window.location.href.split("?")[0];
	return false;
	};
</script> """)

# make html header
cfg.html_header()

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
print_help()
print('</div></div>')

print('<table id="base_table>')
print('<tr><td class="redbutton"><div class="set"><form action="/cgi-bin/autoinstall.py">')
print(' <button type="submit">' + autoinstall_link + '</button></form></div></td></tr>')
print('<tr><td class="greenbutton"><div class="set"><form action="/cgi-bin/firststep.py">')
print(' <button type="submit">' + stepbystep_link + '</button></form></div></td></tr>')
print('<tr><td class="bluebutton"><div class="set"><form action="/cgi-bin/update.py">')
print(' <button type="submit">' + update_link + '</button></form></div></td></tr>')
print('</table>')
	
#нижние кнопки и статусбар
print('<div class="wrap">')
print('<div class="bblockL">')
print('<div id="status" name="status" class="statusCL" >Pfsget started<br></div></div></div>')
wsscript()
print('</body></html>')












