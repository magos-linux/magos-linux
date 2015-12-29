#!/usr/bin/python
# -*- coding:utf-8 -*-
import os, cgi, subprocess, cfg, lib_mod_map, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# ошибки в окно, потом закомментить надо
import cgitb
cgitb.enable()

# messages for gettext
settings = _('save changes to xzm module, extended settings ').encode('UTF-8') 
cmdline = _('enabling save to module mode in kernel cmdline:').encode('UTF-8')
enabled = _('enabled').encode('UTF-8')
disabled = _('disabled').encode('UTF-8')
delete = _('delete /.savetomodule').encode('UTF-8')
edit = _('create /.savetomodule or change module name').encode('UTF-8')
file_exist = _('file /.savetomodule already exist').encode('UTF-8')
not_exist = _('file /.savetomodule is not exist yet').encode('UTF-8')
select_name = _('ener name for module').encode('UTF-8')
mod_toggle = _('static/dynamic toggle:').encode('UTF-8')
del_mod = _('delete saving module for this machine').encode('UTF-8')
ok = _('apply').encode('UTF-8')
savetomodule = _('file /.savetomodule settings:').encode('UTF-8')
lightversion = _('ligth settings').encode('UTF-8')
header = _('Edit this file to add and remove files and dirs').encode('UTF-8')
modulename = _('module name for this machine is').encode('UTF-8')
savelist_notexist = _('#save all changes').encode('UTF-8')
static = _('<strong>static</strong> - <i>do non freeze system</i>').encode('UTF-8')
dynamic = _('<strong>dynamic</strong> - <i>freeze system</i>').encode('UTF-8')
warning = _('Warning!!!').encode('UTF-8')
first_time = _('It is not for newbie, be carefull').encode('UTF-8')
second_time = ''
no_module = _('There is no saving modules yet').encode('UTF-8')
freeze_disabled  = _('module moved to static directory').encode('UTF-8')
freeze_enabled = _('module moved to dynamic dirrectory').encode('UTF-8')
error_freeze_toggle = _('toggle static to dynamic -  failed ').encode('UTF-8')
no_need_toggle 	= _('nothing to toggle').encode('UTF-8')
savelist_saved = _('/.savelist file saved').encode('UTF-8')
mod_info = _('module info').encode('UTF-8')
savetomodule_edited = _('/.savetomodule file created or edited').encode('UTF-8')

def getState():
	ret = os.popen('./lib_s2m.sh').read()
	return ret 

def table_header():
	print '<form action="/cgi-bin/save2module-pro.py" method="post" name="s2m_pro_form">'
	print '<table class="s2m_table" border="1">'
	print '<tr><td colspan="2">	<a href="/cgi-bin/save2module.py">' + lightversion + '</a></td></tr>'
	print '<tr><td colspan="2"><h2 align="center">' + settings + '</h2>'
	print '<input name="dialog_test"  type="hidden" value="second" </td></tr>'
		
def table_cmdline(state):
	print '<tr><td class="item">' + cmdline + '</td><td>'
	if state == 'cmd_enabled': 
		print '<p>' + enabled + '</p>'
	else:
		print '<p>' + disabled + '</p>'
	print '</td></tr>'
		
def table_savetomodule(state, modname):
	print '<tr><td rowspan="2"  class="item">' + savetomodule + '</td><td>'
	if state == 'f_enabled':
		print '<p>' + file_exist  
	else:
		print '<p>' + not_exist
	print '</p><p>' + modulename + ': <br><i> ' + modname + '<i></p></td></tr>'
	print '<tr><td>'
	print '<p>' + select_name + ': </p>'
	print '<div class="set">'
	print '<input name="f_name" type="text" id="input1" size="40" value="' + modname +  ' " ><br><br>'
	print '<input name="f_action" type="radio" id="radio1" value="delete"><label for="radio1">' +  delete + '</label>'
	print '<input name="f_action" type="radio" id="radio2" value="edit"><label for="radio2">' + edit + '</label></div></td>'
	
def table_save_mods(state):
	print '<tr><td  class="item">'
	print  '<p>' + mod_toggle + '</p></td>'
	if state == 'no_saves':
		print  '<td><p class="warning">' + no_module + '</p></td></tr>'
	else:
		print '</td>'
		print '<td><div class="set"><input'  
		if state == 'static' :
			print 'checked'
		print 'name="mod_action" type="radio" id="radio3" value="static"><label for="radio3">' +  static + '</label>'
		print '<input'
		if state == 'dynamic' :
			print 'checked'
		print 'name="mod_action" type="radio" id="radio4" value="dynamic"><label for="radio4">' + dynamic + '</label></div><br>'
		print '<div class="set"><input'
		print 'name="mod_action" type="radio" id="radio5" value="del_mod"><label for="radio5">' + del_mod + '</label></div>'
		print '<div class="set"><input'
		print 'name="mod_action" type="radio" id="radio6" value="mod_info"><label for="radio6">' + mod_info + '</label></div>'
	print '</td></tr>'

def textarea():
	print '<tr><td colspan="2"><h3>', header, '</h3>'
	print '<textarea name="savelist" cols=70 rows=10>'
	try:
		f = open('/.savelist', 'r')
		text = ''
		for string  in f.readlines():
			text = text + string
		print text.replace('\n\n', '\n')
		f.close()
	except: 
		print savelist_notexist
	print '</textarea><br>'

def tail():	
	print '<input name="submit" type="submit" value=' + ok + '></td></tr></table></form>' 
	print '</body></html>'


#actions	
def file_actions(f_name, f_action):
	global dialog_text 
	if f_name == 'none':
		pass
	elif f_action == 'delete':
		dialog_text = lib_mod_map.delmod('/.savetomodule') 
	elif f_action == 'edit':
		try: 	
				f = open('/.savetomodule' ,'w')
		except:
				subprocess.call('beesu "./lib_s2m.sh --mksavetomodule"', shell=True)
				f = open('/.savetomodule' ,'w')
		f.writelines(f_name)
		f.close()
		dialog_text =   dialog_text  + '<br>' + savetomodule_edited
	
	return dialog_text
				

def mod_actions(mod_action, now, f_name):
	if mod_action == 'none':
		pass
	else:
		global dialog_text
		if mod_action == 'del_mod' :
			dialog_text = dialog_text + '<br>' + lib_mod_map.delmod(f_name)
		elif mod_action == 'mod_info' :
			lib_mod_map.modinfo( f_name )
			dialog_text = ''
		elif mod_action != now :
			ret = subprocess.call('beesu "./lib_s2m.sh --toggle"', shell=True)
			if ret == 0:
				if mod_action == 'static':
					dialog_text =  dialog_text + '<br>' + freeze_disabled 
				else:
					dialog_text =  dialog_text + '<br>' + freeze_enabled
			else:
				dialog_text = dialog_text + '<br>' + error_freeze_toggle
		else:
			dialog_text = dialog_text + '<br>' + no_need_toggle 	
	
		return dialog_text


def savelist_action(savelist):
	if savelist == 'none':
		pass
	else:
		global dialog_text 
		lines = savelist.split("\r\n")
		try: 	
				f = open('/.savelist' ,'w')
		except:
				subprocess.call('beesu "./lib_s2m.sh --mksavelist"', shell=True)
				f = open('/.savelist' ,'w')
		f.writelines("%s\n" % i for i in lines)
		f.close()
		dialog_text =   dialog_text  + '<br>' +  savelist_saved
	
	return dialog_text	 

# анализ запроса
form = cgi.FieldStorage()
dialog_test = form.getvalue('dialog_test') or 'first_time'
f_name = form.getvalue('f_name') or  'none'
f_action = form.getvalue('f_action') or  'none'
mod_action = form.getvalue('mod_action') or  'none'
savelist = form.getvalue('savelist') or  '#MagOS \n#savelist'

if dialog_test == 'first_time':
	dialog_text = first_time
else:
	dialog_text = second_time
	s2m = getState().split()
	file_actions(f_name.strip(), f_action)
	mod_actions(mod_action, s2m[2] ,  f_name.strip() )
	savelist_action(savelist)


s2m = getState().split()
# make header
cfg.html_header()

print """
<script type="text/javascript">
$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
});

$(window).load(function() {
    var iframe = $('#mainframe', parent.document.body);
	iframe.height($(document).outerHeight(true) ); 
});

$(function(){
	$("#dialog").dialog();
	});
</script>	
"""
print '<div id="dialog" title="'+ warning +'">'
print dialog_text + '</div>'

table_header()
table_cmdline(s2m[0])
table_savetomodule(s2m[1], s2m[3])
table_save_mods(s2m[2])
textarea()
tail()

