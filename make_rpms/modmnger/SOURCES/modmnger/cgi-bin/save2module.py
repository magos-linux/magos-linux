#!/usr/bin/python
# -*- coding:utf-8 -*-
import os, re, cgi, subprocess, cfg, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# messages for gettext
ok = _('apply').encode('UTF-8')
proversion = _('extended settings').encode('UTF-8')
lightversion = _('light settings').encode('UTF-8')
disabled = _('save to module mode disabled&nbsp:-(').encode('UTF-8')
helptext = _('please reboot your system with "chages=xzm" cmdline par, or try extended settings').encode('UTF-8')
header = _('Edit this file to add and remove files and dirs').encode('UTF-8')
modulename = _('module name').encode('UTF-8')
nothing = _('sorry, nothing to toggle').encode('UTF-8')
not_exist = _('#save all changes').encode('UTF-8')
settings = _('save changes to xzm module ').encode('UTF-8')
static = _('<strong>static</strong> - <i>do non freeze system</i>').encode('UTF-8')
dynamic = _('<strong>dynamic</strong> - <i>freeze system</i>').encode('UTF-8')
freez_disabled = _('save to xzm mode toggled to static').encode('UTF-8')
freez_enabled = _('save to xzm mode toggled to dynamic').encode('UTF-8')
first_time = _('Warning: there is no modules in dynamic and static dirs, \
			 but mode is enabled and you can not toggle save2module mode to static').encode('UTF-8')
title_dyn = _('module with system savings will moved to dynamic dir').encode('UTF-8')
title_stat = _('module with system savings will moved to static dir').encode('UTF-8')
wrong = _('Ooops, somthing wrong!!!').encode('UTF-8')
warning = _('Warning!!!').encode('UTF-8')
savelist_saved = _('/.savelist saved').encode('UTF-8')


def getState():
	ret = os.popen('./lib_s2m.sh').read()
	return ret

def xzm_def(new, now):
	dialog_text =  nothing
	if new != now :
		ret = subprocess.call('beesu "./lib_s2m.sh --toggle"', shell=True)
		if ret == 0:
			if new == 'static':
				dialog_text =  freez_disabled 
			else:
				dialog_text =  freez_enabled
		else:
			dialog_text = wrong
			
	if new == 'dynamic' :
		lines = savelist.split("\r\n") 
		try: 	
			f = open('/.savelist' ,'w')
			f.writelines("%s\n" % i for i in lines)
			f.close()
			dialog_text =  savelist_saved + '<br>' + dialog_text 
		except:
			subprocess.call('beesu "./lib_s2m.sh --mksavelist"', shell=True)
			f = open('/.savelist' ,'w')
			f.writelines("%s\n" % i for i in lines)
			f.close()
			dialog_text =   savelist_saved  + '<br>' + dialog_text
	return dialog_text
	
def makeform(mod_dir, modname):
	print '<form action="/cgi-bin/save2module.py" method="post" name=s2m_form>'	
	print '<table class="s2m_table">'
	print '<tr><td colspan="2">	<a href="/cgi-bin/save2module-pro.py">' + proversion + '</a></td></tr>'
	print '<tr><td colspan="2"><h1 align="center">' + settings + '</h1></td></tr>'
	print '<tr><td colspan="2">'
	print '<strong>', modulename +':<p>', modname, '</p></strong>'
	if mod_dir == 'no_saves':
		print '<p class="warning">'
		print first_time + '</p>'
	print '</td></tr>'
	print '<tr><td title="' + title_stat + '"><div class="set"><input'  
	if mod_dir == 'static' :
		print 'checked'
	print 'name="state" type="radio" id="radio1" value="static"><label for="radio1">' +  static + '</label></div>'
	print '</td><td title="'  + title_dyn + '"><div class="set"><input'
	if mod_dir == 'dynamic' or  mod_dir == 'no_saves':
		print 'checked'
	print 'name="state" type="radio" id="radio2" value="dynamic"><label for="radio2">' + dynamic + '</label></div>'
	print '</td><tr><td colspan="2"><h3>', header, '</h3>'
        	
	print '<textarea name="savelist" cols=70 rows=10>'
	try:
		f = open('/.savelist', 'r')
		text = ''
		for string  in f.readlines():
			text = text + string
		print text.replace('\n\n', '\n')
		f.close()
	except: 
		print not_exist

	print '</textarea><br>'
	print '<input name="submit" type="submit" value=' + ok + '></td></tr></table></form>' 
	print '</body></html>'
	
def makeform_min():
	print '<table class="s2m_table_disabled" ><tr><td> \
			<a href="/cgi-bin/save2module-pro.py">' + proversion + '</a></td></tr>'
	print '<tr><td><p class="disabled">' + disabled + '</p>'
	print '<p class="warning">' + helptext + '</p></td></table>'
	
# анализ запроса
form = cgi.FieldStorage()
savelist = form.getvalue('savelist') or  '#MagOS \n#savelist' 
state = form.getvalue('state') or 'none'
s2m_name = form.getvalue('s2m_name') or 'none'

dialog_text = 'none'
if state != 'none':
	s2m = getState().split()
	dialog_text = xzm_def(state, s2m[2])

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
if state != 'none':
		print '<div id="dialog" title="'+ warning +'">'
		print dialog_text + '</div>'

s2m = getState().split()

if s2m[0] == 'cmd_enabled':
	makeform(s2m[2], s2m[3])
else:
	makeform_min()


