#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, re, cgi, lib_mod_map, cfg, gettext

gettext.install('mod_mnger', './locale', unicode=True)

dialog_text = 'none'
n = 1 

# анализ cgi запроса
form = cgi.FieldStorage()
modname = form.getvalue('modname') or 'none' 
action = form.getvalue('action') or 'none'
findit = form.getvalue('findit') or 'none'

if modname == 'none':
    pass
elif modname == 'finditplease':
    lib_mod_map.pfsfind( findit )
else:
	if action == 'activate':
		dialog_text = lib_mod_map.activate( modname )
	elif action == 'deactivate':
		dialog_text = lib_mod_map.deactivate( modname )
	elif action == 'delete':
		dialog_text = lib_mod_map.delmod( modname )
	elif action == 'move':
		dialog_text = lib_mod_map.mv2( modname )
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
pfsfind = _('Find file in modules').encode('UTF-8')

def print_updateform ():
    print '<form action="/cgi-bin/mod_map.py">'
    print '<input type="submit" value="' + update + '"></form>'


def print_findform ():
    print '<form action="/cgi-bin/mod_map.py" >'
    print '<input name="modname" type="hidden" id="modname" value="finditplease" >'
    print '<input name="findit" type="text" id="findit" >'
    print '<input type="submit" value="' + pfsfind  + '">'
    print '</form>'
 
	
	
# функция создает форму с активным модулем
def printULgreen ( num, a, fullname ):
	global n, modArr
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
	print 'onmouseover="textBig(\'' + liID + '\')" onmouseout="textNormal(\'' + liID + '\') "'
	print 'oncontextmenu="alert(\'' + fullname[1] + '/' + fullname[3] + '\');return false">'
	print '<font color="green">', num + ' &nbsp;&nbsp;&nbsp;' + a , '</font></div></td>'
	print '<td colspan="3" class="td_actions" onclick="action(\'' + inputID + '\', \'modInfo\'); ', submitCommand, '"><img src="/images/info.svg" alt="info"></td></tr>'
	del modArr[num]

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
	print 'onmouseover="textBig(\'' + liID + '\')" onmouseout="textNormal(\'' + liID + '\')" '
	print 'oncontextmenu="alert(\'' + fullname[1] + '/' + fullname[3] + '\');return false">'
	print '<font color="grey">', ' ---&nbsp;&nbsp;&nbsp;',  b, '</font></div>'
	if mv2 != 'none':
	    print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'' + mv2 + '\'); ', submitCommand, '"><img src="/images/move.svg" alt="' + mv2 + '"> </td>'	
	    print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'delete\'); ', submitCommand, '"><img src="/images/delete.svg" alt="delete"></td>'
	else:
		print '<td class="td_actions"></td>'
		print '<td class="td_actions"></td>'
	print '<td class="td_actions" onclick="action(\'' + inputID + '\', \'modInfo\'); ', submitCommand, '"><img src="/images/info.svg" alt="info"></td></tr>'


# Создает таблицу для одного каталога
def printTable(pathDir, header,  title,  mv2):
	global tables, qmod
	print '<table id="' + header + '" class="mod_table"><tr>'
	print '<td class="table_header" colspan="4" title="' + title + '">' + header + '</td></tr>'
	modGreen = lib_mod_map.getModGreen(modArr, pathDir)
	modGrey = lib_mod_map.getModGrey(modGreen, pathDir)
	def addFrame ():
		global qmod, tables
		if qmod == 15:
			qmod = -2
			print '</table></td>'
			if tables == 4 or tables == 8 or tables == 12:
				print '</tr><tr>'
			print '<td  width="25%" valign="top"><table id="' + header +'_' + str(tables) + '" class="mod_table">'
			tables = tables + 1
			qmod=qmod + 1
			
	if not len(modGreen) == len(modGrey) == 0:
		l = modGreen.keys() 
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
			print '<tr><td><p class="disabled"  >' + empty + '</p></td></tr>'
						
		
	print '</table>'

#получаем список активированных модулей
modArr = lib_mod_map.getModArr()
folders = lib_mod_map.getFolders(modArr)
# make html header
cfg.html_header()
cfg.hide_div()

qmod = 0 
tables=0
# make html body
print """
<style>
    body{
    cursor: pointer /* cursor like hand */
    }<script type="text/javascript">
$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
});

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
	
	$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
});

 	</script> """


# всплывающее окошко
if dialog_text != 'none':
	print '<div id="dialog" title="' + action + '">'
	print dialog_text + '</div>'

#рисуем таблицы
print '<table width="100%"><tr ><td>'
print_updateform()
print '</td><td align="right">'
print_findform()
print '</td></tr></table>'


print '<table id="big_mod_table" border="1"><tr>'
for frame in folders:
	if os.path.isdir(frame):
		if tables == 4 or tables == 8 or tables == 12:
			print '</tr><tr>'
		print '<td  width="25%" valign="top" >'
		if '/modules' in frame:
			mv2='move'
		elif '/optional' in frame:
			mv2='move'
		else:
			mv2 = 'none'
		tables = tables + 1
		qmod = 0
		printTable(frame,  frame, frame ,  mv2 )
		print '</td>'
		
if not len(modArr) == 0:
	print '<td valign="top" width="25%" >'
	print '<table id="another_table" class="mod_table"><tr>'
	print '<td class="table_header" colspan="4" title="' + title_another + '">'+ another + '</td></tr>'
	for key, val in modArr.items():
		fullname = ('value="',  val[1], '/', val[0], '">')
		printULgreen( key, val[0], fullname)
	print '</table></td>'
print '</table>'
print '</div></body></html>'
