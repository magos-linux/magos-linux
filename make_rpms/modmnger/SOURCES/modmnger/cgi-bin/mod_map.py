#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, re, cgi, lib_mod_map, cfg, gettext

gettext.install('mod_mnger', './locale', unicode=True)

allEnabled = []
dialog_text = 'none'
n = 1 

# Определяем пути, см cfg.py
paths = cfg.config('all')
base = paths['base_path']
modules = paths['mod_path']
optional = paths['opt_path']
data_modules = paths['data_mod_path']
data_optional = paths['data_opt_path']
copy2ram = paths['copy2ram']

# анализ cgi запроса
form = cgi.FieldStorage()
modname = form.getvalue('modname') or 'none' 
action = form.getvalue('action') or 'none'

if modname == 'none':
	pass
else:
	if action == 'activate':
		dialog_text = lib_mod_map.activate( modname )
	elif action == 'deactivate':
		dialog_text = lib_mod_map.deactivate( modname )
	elif action == 'delete':
		dialog_text = lib_mod_map.delmod( modname )
	elif action == 'move2optional':
		dialog_text = lib_mod_map.mv2( modname, optional )
	elif action == 'move2modules':
		dialog_text = lib_mod_map.mv2( modname, modules )
	elif action == 'move2data_optional':
		dialog_text = lib_mod_map.mv2( modname, data_optional )
	elif action == 'move2data_modules':
		dialog_text = lib_mod_map.mv2( modname, data_modules )		
	elif action == 'install': # actions for open.py	
		if data_modules != 'no_data_modules':
			dialog_text = lib_mod_map.install( modname, data_modules )
		else:
			dialog_text = lib_mod_map.install( modname, modules )
	elif action == 'cp2modules':
		dialog_text = lib_mod_map.cp2( modname, modules )
	elif action == 'cp2data_modules':
		dialog_text = lib_mod_map.cp2( modname, data_modules )
	elif action == 'cp2optional':
		dialog_text = lib_mod_map.cp2( modname, optional )
	elif action == 'cp2data_optional':
		dialog_text = lib_mod_map.cp2( modname, data_optional )
		
	else:
		lib_mod_map.modinfo( modname )

# messages for gettext
title_base = _('Base MagOS modules, activating in startup. Do not move this modules if you do not know what to do.').encode('UTF-8')
title_modules = _('Modules activating in startup, from MagOS dir').encode('UTF-8')
title_optional = _('Modules activating in startup, from MagOS dir. only if enabled by  load= cmdline par').encode('UTF-8')  
title_data_modules = _('Modules activating in startup, from MagOS-Data dir.').encode('UTF-8')
title_data_optional = _('Modules activating in startup, from MagOS-Data dir. only if enabled by  load= cmdline par').encode('UTF-8')  
title_copy2ram = _('Modules activated from RAM').encode('UTF-8')
title_another = _('Modules activated from another dirs').encode('UTF-8')  
no_data_modules = _('no Data-optional dir').encode('UTF-8')
no_data_optional = _('no Data-modules dir').encode('UTF-8')
another = _('modules activated from another dirs').encode('UTF-8')
no_cache = _('No copy2ram cache').encode('UTF-8')
another = _('Another modules').encode('UTF-8')
update = _('Update').encode('UTF-8')
empty = _('Empty').encode('UTF-8')

# функция создает форму с активным модулем
def printULgreen ( a, fullname ):
	global n
	n = n + 1 
	ID = a.replace( '-', '_').replace( '.', '__').replace(' ','__') + str(n)
	liID = ('liID_' + ID)
	formID = ('formID_' + ID)
	inputID = ('inputID_' + ID)
	submitCommand = (formID + '.submit();')
	print ' <tr'
	if n%2==0:
		print 'class="tr_grey"'
	print '><td> '
	print '<form action="/cgi-bin/mod_map.py" method="post" name=\'' + formID + '\'>'
	print '<input name="modname" type="hidden"' ;	print  "".join(fullname)
	print '<input name="action" type="hidden" value="deactivate"  id=\'' + inputID + '\'></form>'
	print '<div id="' + liID + '" onclick="', submitCommand, 'action(\'' + inputID + '\','  '\'deactivate\')"'
	print 'onmouseover="textBig(\'' + liID + '\')" onmouseout="textNormal(\'' + liID + '\')">'
	print '<font color="green">', a, '</font></div></td>'
	print '<td colspan="3" class="td_actions" onclick="action(\'' + inputID + '\', \'modInfo\'); ', submitCommand, '"><img src="/images/info.svg" alt="info"></td></tr>'
	allEnabled.append(a)

#Функця создает форму с деактивированным модулем
def printULgrey ( b,  fullname, mv2  ):
	global n
	n = n + 1 
	ID = b.replace( '-', '__').replace( '.', '_').replace(' ','__') + str(n)
	liID = ('liID_' + ID)
	formID = ('formID_' + ID)
	inputID = ('inputID_' + ID)
	submitCommand = (formID + '.submit();')
	print '<tr'
	if n%2==0:
		print 'class="tr_grey"'
	print '><td> '
	print '<form action="/cgi-bin/mod_map.py" method="post" name=\'' + formID + '\'>'
	print '<input name="modname" type="hidden"' ;	print  "".join(fullname)
	print '<input name="action" type="hidden" value="activate"  id=\'' + inputID + '\'></form>'
	print '<div id="' + liID + '" onclick="', submitCommand, 'action(\'' + inputID + '\','  '\'activate\')"'
	print 'onmouseover="textBig(\'' + liID + '\')" onmouseout="textNormal(\'' + liID + '\')">'
	print '<font color="grey">', b, '</font></div>'
	if mv2 != 'none':
	    print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'' + mv2 + '\'); ', submitCommand, '"><img src="/images/move.svg" alt="' + mv2 + '"> </td>'	
	    print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'delete\'); ', submitCommand, '"><img src="/images/delete.svg" alt="delete"></td>'
	else:
		print '<td class="td_actions"></td>'
		print '<td class="td_actions"></td>'
	print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'modInfo\'); ', submitCommand, '"><img src="/images/info.svg" alt="info"></td></tr>'

# функция создает заголовок для подкаталога
def printSubdirHeader(subdir, subdirType, mv2, pathDir):
	global n
	n = n + 1 
	if subdirType == 'green':
		print '<tr'
		if n%2==0:
			print 'class="tr_grey"'
		print '><td align="left" colspan="4">'
		print '<font color="green" ><strong>' +  subdir.replace(pathDir, '') + ':</strong></font></td></tr>'
	else:
		ID = subdir.replace( '-', '__').replace( '.', '__').replace('/','__').replace(' ','__')
		liID = ('liID_' + ID)
		formID = ('formID_' + ID)
		inputID = ('inputID_' + ID)
		submitCommand = (formID + '.submit();')
		fullname = ('value="',  subdir, '">')
		print ' <tr'
		if n%2==0:
			print 'class="tr_grey"'
		print '><td align="left" > '
		print '<form action="/cgi-bin/mod_map.py" method="post" name=\'' + formID + '\'>'
		print '<input name="modname" type="hidden"' ;	print  "".join(fullname)
		print '<input name="action" type="hidden" value="' + mv2 + '" id=\'' + inputID + '\'></form>'
		print '<div id="' + liID + '">'
		print '<strong><font color="grey">', subdir.replace(pathDir, '') + ':'  
		print '</font></strong></div></td><td class="td_actions"></td>'
		print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'' + mv2 + '\'); ', submitCommand, '"><img src="/images/move.svg" alt="' + mv2 + '"> </td>'	
		print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'delete\'); ', submitCommand, '"><img src="/images/delete.svg" alt="delete"></td>'
		print  '</tr>'
	

# Создает таблицу для одного каталога
def printTable(pathDir, header,  title,  mv2): 
	print '<table id="' + header + '" class="mod_table"><tr>'
	print '<td class="table_header" colspan="4" title="' + title + '">' + header + '</td></tr>'
	modGreen = lib_mod_map.getModGreen(modArr, pathDir)
	modGrey = lib_mod_map.getModGrey(modGreen, pathDir)
	if not len(modGreen) == len(modGrey) == 0:
		for a in modGreen:
			fullname = ('value="', pathDir,'/', a, '">')
			printULgreen ( a, fullname )
		for b in modGrey:
			fullname = ('value="', pathDir,'/', b, '">')
			printULgrey( b, fullname,  mv2 )
	else:
		if len(os.listdir(pathDir)) == 0:
			print '<tr><td><p class="disabled"  >' + empty + '</p></td></tr>'
						
		
	print '</table>'
	for subdir in lib_mod_map.getSubdirs(pathDir, 'not_include_root'):
		subdirType = lib_mod_map.testSubdirs(lib_mod_map.getSubdirs(subdir, 'include_root'), modArr)
		if not  subdirType == 'none':
			print '<table class="subdir_table" >'
			printSubdirHeader( subdir,  subdirType, mv2, pathDir)
			modGreen = lib_mod_map.getModGreen(modArr, subdir)
			for a in modGreen:
				fullname = ('value="', subdir,'/', a, '">')
				printULgreen ( a,  fullname )
			for b in lib_mod_map.getModGrey(modGreen, subdir):
				fullname = ('value="', subdir ,'/', b, '">')
				printULgrey( b, fullname,  'none' )
			print '</table>'

#получаем список активированных модулей
modArr = lib_mod_map.getModArr()

# make html header
cfg.html_header()
cfg.hide_div()

# make html body
print """
<style>
    body{
    cursor: pointer /* cursor like hand */
    }
</style> """

# javascript functions 
print """
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
 	</script> """


# всплывающее окошко
if dialog_text != 'none':
	print '<div id="dialog" title="' + action + '">'
	print dialog_text + '</div>'

#рисуем таблицы
print '<table id="big_mod_table" border="1">'
print '<tr><td colspan="4"><a href="/cgi-bin/mod_map.py">'+ update+ '</a></td></tr>'
print '<tr>'

print '<td  width="25%" valign="top" rowspan="2">'
printTable(base,  'Base',  title_base,  'none')
print '</td>'

print '<td width="25%" valign="top">'
printTable(modules,  'Modules',  title_modules,  'move2optional')
print '</td>'

print '<td width="25%" valign="top">'
printTable(optional,  'Optional',  title_optional,  'move2modules')
print '</td>'

print '<td  width="25%" valign="top" >'
if os.path.isdir(copy2ram) and (copy2ram + 'base').replace('/', '') != base.replace('/', '') :
	printTable(copy2ram,  'Copy2ram',  title_copy2ram,  'none')
else:
	print '<p class="disabled">' + no_cache + '</p>'
print '</td></tr>'

print '<tr>'
print '<td width="25%" valign="top">'
if data_modules != 'no_data_modules':
	printTable(data_modules,  'Data-modules',  title_data_modules,  'move2data_optional')
else:
	print '<p class="disabled">' + no_data_modules + '</p>'
print '</td>'
print '<td width="25%" valign="top">'
if data_optional != 'no_data_optional':
	printTable(data_optional,  'Data-optional',  title_data_optional,  'move2data_modules')
else:
	print '<p class="disabled">' + no_data_optional + '</p>'
print '</td>'

print '<td valign="top" width="25%" >'
print '<table id="another_table" class="mod_table"><tr>'
print '<td class="table_header" colspan="4" title="' + title_another + '">'+ another + '</td></tr>'
for a in (set(modArr) - set(allEnabled)):
	fullname = ('value="', a, '">')
	printULgreen( a, fullname)
print '</table>'
print '</td></tr>'
print '</table>'
print '</div></body></html>'
