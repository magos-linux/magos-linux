#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, cgi, re, cfg, urllib, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# ошибки в окно, потом закомментить надо
import cgitb
cgitb.enable()

#for gettext
header = _('Finded: ').encode('UTF-8') 
layer_number = _('layer number ').encode('UTF-8')
module = _('module name ').encode('UTF-8')
bundle = _('module mount point ').encode('UTF-8')
submodule = _('pfs submodule ').encode('UTF-8')
path = _('path to file').encode('UTF-8')
changes = _('filename  finded in top layer - "changes" ').encode('UTF-8')
not_found = _('not found').encode('UTF-8')

# анализ запроса
form = cgi.FieldStorage()
finditGET = form.getvalue('findit') or 'none'	
findit = urllib.unquote(finditGET)

def findf(findit):
	command = ('beesu  pfsfind  ' + findit + ' --raw  \'${n} ${module} ${bundle} ${submodule} ${path}\'' )
	ret = os.popen( command ).read()
	findstr=[]
	for string in ret.split('\n'):		
		tpl = (string.split(' '))
		if len(tpl) == 5:
			findstr.append(tpl) 
	return findstr

# html head from html_header file
cfg.html_header()
cfg.hide_div()
findlist = findf(findit)
if len(findlist) != 0:
	print '<table id="find_table" border="1"><tr><td colspan="5"><h1 align="center">' 
	print  header + '</h1></td></tr><tr>'
	print '<td>' + layer_number + '</td><td>' + module + '</td><td>' + bundle  + '</td><td>' + submodule + '</td><td>' + path + '</td></tr>' 
	for string in  findlist:
		if int(string[0]) != 0:
			print '<tr><td>' + string[0] + '</td><td>' + string[1] + '</td><td>' + string[2] + '</td><td>' + string[3]  + '</td><td>' + string[4] + '</td></tr>'
		else:
			print '<tr><td>' + string[0] + '</td><td colspan="3" align="center">' + changes + '</td><td>' + string[4] + '</td></tr>'
	print '</table>'
else:
	print '<h2>' + findit + '   ' + not_found + '</h2>'
print '</body></html>'




