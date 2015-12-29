#!/usr/bin/python
# -*- coding:utf-8 -*-
import os,  cfg, cgi, lib_mod_map, urllib, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# ошибки в окно, потом закомментить надо
import cgitb
cgitb.enable()

# Определяем пути, см cfg.py
paths = cfg.config('all')
base = paths['base_path']
modules = paths['mod_path']
optional = paths['opt_path']
data_modules = paths['data_mod_path']
data_optional = paths['data_opt_path']

# for gettext
title_activate = _('Activating module right here').encode('UTF-8')
title_install = _('Copy module to modules directory and activate it').encode('UTF-8')
activate = _('Activate').encode('UTF-8')
install = _('Install').encode('UTF-8')
cp2modules = _('Copy to MagOS/modules').encode('UTF-8')
cp2data_modules = _('Copy to MagOS-Data/modules').encode('UTF-8')
cp2optional = _('Copy to MagOS/optional').encode('UTF-8')
cp2data_optional = _('Copy to MagOS-Data/optional').encode('UTF-8')
modinfo = _('Module info').encode('UTF-8')

# анализ запроса
form = cgi.FieldStorage()
modnameGET = form.getvalue('modnameGET') or 'none'
action = form.getvalue('action') or 'none'
modname = form.getvalue('modname') or 'none'

if modnameGET != 'none':
	modname = urllib.unquote(modnameGET)
	
if action != 'none':
	lib_mod_map.modinfo( modname )

def makeTD(modname,  action, title ,action_uri, picture, tdclass):
	print '<td class="'+ tdclass + '" title="' + title + '">'
	print '<form action="' + action_uri +'" method="post" name="' + action + '_form">'
	print '<input name="modname" type="hidden" value="' + modname + '">'
	print '<input name="action" type="hidden" value="' + action + '"  id="' + action + '_action" ></form>'
	print '<div id="' + action + '_div" onclick="' + action + '_form.submit(); action( \''+ action + '_action\',  \'' + action + '\')"'
	print 'onmouseover="textBig(\'' + action +'_div\')" onmouseout="textNormal(\'' + action + '_div\')">'
	print '<font color="green">' + picture +  '</font></div></td>'	    
	    

# make header
cfg.html_header()
cfg.hide_div()

print """
<script type="text/javascript">
	function textBig( elmId ) {
	document.getElementById( elmId ).style.fontSize="130%";
	}
	function textNormal( elmId ) {
	document.getElementById( elmId ).style.fontSize="100%";
	}
	
	function action( elmId, action ) {
	document.getElementById( elmId ).value=action;
	$('#loader').show();
	var iframe = $('#mainframe', parent.document.body);
	iframe.height(500);
	$('#body').hide();
	$('#loader').animate({opacity:0}, 3000);
	$('#loader').animate({opacity:1}, 1000);
	var deltime = setInterval('flash()', 5000)
	}
 
 	$(function(){
	$("#dialog").dialog();
	});
	
</script> 
"""
print '<table> <tr class="tr_button"><td colspan="2"><h2>' + modname + '</h2></td></tr>'
 
print '<tr>'
makeTD(modname,  'activate',  title_activate, '/cgi-bin/mod_map.py', activate, 'td_button')
makeTD(modname,  'install', title_install, '/cgi-bin/mod_map.py', install, 'td_button')
print '</tr><tr>'
if data_modules == 'no_data_modules':
	makeTD(modname,  'cp2modules', '', '/cgi-bin/mod_map.py', cp2modules, 'td_button_colspan" colspan="2')
else:
	makeTD(modname,  'cp2data_modules', '', '/cgi-bin/mod_map.py', cp2data_modules, 'td_button_colspan" colspan="2')
print '</tr><tr>'
if data_optional == 'no_data_optional':
	makeTD(modname,  'cp2optional', '', '/cgi-bin/mod_map.py', cp2optional, 'td_button_colspan" colspan="2')
else:
	makeTD(modname,  'cp2data_optional', '', '/cgi-bin/mod_map.py', cp2data_optional, 'td_button_colspan" colspan="2')
print '</tr><tr>'	
makeTD(modname,  'modinfo', '', '/cgi-bin/open.py', modinfo, 'td_button_colspan" colspan="2')
print '</tr></table></div></body></html>'  

