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



# messages for gettext
title_base = _('Base MagOS modules, activating in startup. Do not move this modules if you do not know what to do.')
title_modules = _('Modules activating in startup, from MagOS dir')
title_optional = _('Modules activating in startup, from MagOS dir. only if enabled by  load= cmdline par')  
title_data_modules = _('Modules activating in startup, from MagOS-Data dir.')
title_data_optional = _('Modules activating in startup, from MagOS-Data dir. only if enabled by  load= cmdline par')  
title_copy2ram = _('Modules activated from RAM')
title_another = _('Modules activated from another dirs')  
no_data_modules = _('no Data-optional dir')
no_data_optional = _('no Data-modules dir')
another = _('modules activated from another dirs')
no_cache = _('No copy2ram cache')
another = _('Another modules')
update = _('Update') #
empty = _('Empty')
pfsfind = _('Find file in modules')
modfind = _('Find modules in repository')
allowroot = _('Allow root actions')
denyroot = _('Deny root actions')

def print_updateform ():
    print('<form>')
    print(' <input name="update_button" id="update_button" type="submit"')
    print(' value="%s" onclick="window.location.assign(document.URL)"></form>' % (update))

def print_getws ():
    print('<form action="/cgi-bin/mod_map.py">')
    print('<input type="password" maxlength="25" size="20" name="pass" id="pass">')
    print('<input name="wsaction" type="hidden" id="wsaction" value="start" >')
    print('<input name="bt_getws" id="bt_getws" type="submit" value="%s">' % (allowroot))
    print('</form>')

def print_findform ():
    print('<form name="findit_form" id="findit_form" >')
    print('<input name="findit" type="text" id="findit" >')
    print('<input type="submit" value="%s">' % (pfsfind))
    print('</form>')

def print_modform ():
    print('<input name="goto_pfsget" id="goto_pfsget" type="submit" value="%s"' % (modfind))
    print('onclick="window.location.href = \'/cgi-bin/pfsget.py\';">')
    
def print_killws ():
    print('<input name="readmirrors" id="readmirrors" type="button" value="%s"' % (denyroot))
    print('onclick="denyRoot();">')   
 	
# функция создает форму с активным модулем
def printULgreen ( num, a, fullname ):
	global n, modArr
	n = n + 1
	ID = a.replace( '-', '_').replace( '.', '__').replace(' ','__') + str(n)
	liID = ('liID_' + ID)
	inputID = ('inputID_' + ID)
	print(' <tr')
	if n%2==0:
		print('class="tr_grey"')
	print('><td> ')
	print('<div id="%s" onclick="ws.send(\'py_deactivate::%s\')" ' % (liID, fullname[3]))
	print('onmouseover="textBig(\'%s\')" onmouseout="textNormal(\'%s\') "' % (liID, liID))
	print('oncontextmenu="alert(\'%s/%s\');return false">'  % (fullname[1], fullname[3]))
	print('<font color="green">%s &nbsp;&nbsp;&nbsp;%s </font></div></td>' % (num, a))
	print('<td colspan="3" class="td_actions" onclick="ws.send(\'py_modinfo::%s/%s\')">' % (fullname[1], fullname[3]))  
	print('<img src="/images/info.svg" alt="info"></td></tr>') 
	del modArr[num]

#Функця создает форму с деактивированным модулем
def printULgrey ( b,  fullname, mv2  ):
	global n
	n = n + 1 
	ID = b.replace( '-', '__').replace( '.', '_').replace(' ','__') + str(n)
	liID = ('liID_' + ID)
	inputID = ('inputID_' + ID)
	print('<tr')
	if n%2==0:
		print('class="tr_grey"')
	print('><td> ')
	print('<div id="%s" onclick="ws.send(\'py_activate::%s/%s\')" ' % (liID,fullname[1], fullname[3] ))
	print('onmouseover="textBig(\'%s\')" onmouseout="textNormal(\'%s\')" ' % (liID, liID))
	print('oncontextmenu="alert(\'%s/%s\');return false">' % (fullname[1], fullname[3]))
	print('<font color="grey">', ' ---&nbsp;&nbsp;&nbsp;%s</font></div>' % (b))
	if mv2 != 'none':
	    print('<td class="td_actions" onclick="ws.send(\'py_mv2::%s/%s\')">' % (fullname[1], fullname[3]))
	    print('<img src="/images/move.svg" alt="%s"> </td>' % (mv2))	
	    print('<td class="td_actions" onclick="delmod(\'%s/%s\')">' % (fullname[1], fullname[3]))
	    print('<img src="/images/delete.svg" alt="delete"></td>')
	else:
		print('<td class="td_actions"></td>')
		print('<td class="td_actions"></td>')
	print('<td class="td_actions" onclick="ws.send(\'py_modinfo::%s/%s\')">' % (fullname[1], fullname[3]))
	print('<img src="/images/info.svg" alt="info"></td></tr>')


# Создает таблицу для одного каталога
def printTable(pathDir, header,  title,  mv2):
	global tables, qmod
	print('<h4 title="%s">%s</h4>' % (title, header))
	print('<table id="%s" class="mod_table">' % (header))
	modGreen = lib_mod_map.getModGreen(modArr, pathDir)
	modGrey = lib_mod_map.getModGrey(modGreen, pathDir)
	def addFrame ():
		global qmod, tables
		if qmod == 15:
			qmod = -2
			print('</table></td>')
			if tables == 4 or tables == 8 or tables == 12:
				print('</tr><tr>')
			print('<td  width="%s" valign="top"><table id="%s_%s" class="mod_table">' % ('25', header, str(tables)))
			tables = tables + 1
			qmod=qmod + 1
			
	if not len(modGreen) == len(modGrey) == 0:
		l = list(modGreen.keys()) 
		l = list(l) 
		l.sort()
		for key in l:
			addFrame ()
			qmod=qmod + 1
			fullname = ('value="', pathDir,'/', modGreen[key], '">')
			printULgreen ( key, modGreen[key], fullname )
		for b in modGrey:
			addFrame ()
			fullname = ('value="', pathDir,'/', b, '">')
			printULgrey( b, fullname,  mv2 )
	else:
		if len(os.listdir(pathDir)) == 0:
			print('<tr><td><p class="disabled"  >' + empty + '</p></td></tr>')
						
		
	print('</table>')


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
  document.getElementById('big_mod_table').innerHTML=event.data.slice(7) + '<br>';
  document.getElementById('update_button').value='Back to map';
  document.getElementById('big_mod_table').border='0';
  } else if  ( message.indexOf("alert:") == 0 ) {
  alert(event.data.split("::")[1]);
  window.location = window.location.href.split("?")[0];
  return false;
  };  
};

ws.onerror = function(error) {
  document.getElementById('status').innerHTML+='Websocket error:  ' + error.message + '<br>';
};

document.forms.findit_form.onsubmit = function() {
	let message = this.findit.value;
	ws.send('py_findit::' + message);
	return false;
};

</script> """)

#получаем список активированных модулей
modArr = lib_mod_map.getModArr()
folders = lib_mod_map.getFolders(modArr)
# make html header
cfg.html_header()
qmod = 0 
tables=0
# make html body
print("""
<style>
    body{
    cursor: pointer /* cursor like hand */
    }<script type="text/javascript">
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
		
	function denyRoot() {
	ws.send(\'py_killws::update\');
	window.location = window.location.href.split("?")[0];
	return false;
	};
	
	function delmod( module ) {
	var confirmed = confirm('remove:  ' + module + '?');
	if (confirmed) {
	ws.send('py_delmod::' + module);
	};
	};

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
print_modform()
print('</div></div>')



print('<div class="wrap" id="big_mod_table">')
print('<div class="wrap-tr">')
for frame in folders:
	if os.path.isdir(frame):
		if tables == 4 or tables == 8 or tables == 12:
			print('</div><div class="wrap-tr">')
		print('<div class="bblock25">')
		if '/modules' in frame:
			mv2='move'
		elif '/optional' in frame:
			mv2='move'
		else:
			mv2 = 'none'
		tables = tables + 1
		qmod = 0
		printTable(frame,  frame, frame ,  mv2 )
		print('</div>')
		
print('</div></div>')


print('<div class="wrap">')
print('<div class="bblockL">')
print('<div id="status" name="status" class="statusCL">Modmanger started<br></div></div>')
print('<div class="bblockR">')
print_findform()
print('</div></div>')
wsscript()
print('</body></html>')
