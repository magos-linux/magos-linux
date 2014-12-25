#!/usr/bin/python
# -*- coding:utf-8 -*-
import  gettext,  cgi, subprocess
import cfg, disks

gettext.install('install-helper', './locale', unicode=True)
dialog_text = 'none'

# messages for gettext
flag = _('flag').encode('UTF-8')
device = _('disk device').encode('UTF-8')
size = _('size').encode('UTF-8')
select_disk = _('Please select disk to install MagOS:').encode('UTF-8')
none= _('Nothing to do').encode('UTF-8')
update_= _('Update').encode('UTF-8')
submit_= _('Install MagOS').encode('UTF-8')
not_mouted = _('is not mounted').encode('UTF-8')
autoinstall_header = _('Auto install MagOS linux').encode('UTF-8')
autoinstall_help = _('Select disk and push INSTALL button to start installation. Be especially careful, you loose all data in selected disk. ').encode('UTF-8')
help_= _('Help!').encode('UTF-8')
prev_ = _('Prev...').encode('UTF-8')
install_OK =  _('install MagOS - OK!!!').encode('UTF-8')
install_fail = _('Sorry, install MagOS - FAIL!!!').encode('UTF-8')
action =_('MagOS instalation').encode('UTF-8')

def install(disk):
		dialog_text=install_OK
		command = ('beesu  xterm -e  ./autoinstall.sh ' + disk + ' ')
		ret = subprocess.call(command, shell=True)
		try:
			text = install_fail
			f = open('/tmp/errorcode', 'r')
			for string  in f.readlines():
				text = text + '  ' + string
			dialog_text = (  str(text.replace('\n', '')) )
			f.close()
		except: 
			dialog_text=install_OK
		if ret != 0:
			dialog_text = ( dialog_text + '<br>Oooops, somebody killed xterm :(' )
		return dialog_text

		
form = cgi.FieldStorage()
disk = form.getvalue('physical') or 'none'

if disk != 'none':
	dialog_text=install(disk) 

physical = disks.getPhysical()
logical =  disks.getLogical()
 
# make header
cfg.html_header()
cfg.hide_div()
print '<link type="text/css" href="/css/install-helper.css"   rel="stylesheet" />'

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

if dialog_text != 'none':
	print '<div id="dialog" title="' + action + '">'
	print dialog_text + '</div>'

print '<h1>' + autoinstall_header + '</h1><p>' + autoinstall_help + '</p>'
print '''
<div class="set"><table class="top" width="500"> <tr><td>
<form action="/cgi-bin/autoinstall.py">'''
print ' <button type="submit">' + update_ + '</button></form>'
print '</td><td>'
print '<td><form action="/cgi-bin/install.py"><button type="submit">' + prev_ + '</button></form></td>'
print '<td><form action="/cgi-bin/install_help.py#autoinstall" method="post">'
print '<input type="hidden" name="back" value="/cgi-bin/autoinstall.py">'
print '<button type="submit">' + help_ + '</button></form></div>'
print '</td></tr></table></div>'

print '<h2>' + select_disk + '</h2>'  
print '<form action="/cgi-bin/autoinstall.py" method="post" name=ds_form>'	
print '<table  class="bordered-table">'
print '<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  device +  '</td><td class="bordered_td">' + size + '</td> </tr>'
for key, val in physical.items():
	print '<tr><td rowspan="2" class="bordered_td"><input type="radio"    name="physical"  value="' + key + '"></td><td class="bordered_td"><b>' + key + '</b></td><td class="bordered_td"> ' + val[0]  + ' ' + val[1] + '</td></tr>'
	print '<tr><td colspan="2" class="bordered_td">'
	for key1, val1 in logical.items():
			if key1[:-1] == key:
				print '<i>' + key1 + ':</i>  ' + val1[0][0] + ';   ' + val1[0][1]  
				print '<div title="dirList:             '
				for f in val1[1]: 	
					print f + ', '
				print '">mount: '  
				if val1[0][6] != '/dev': 
					print  val1[0][6]
				else: 
					print  not_mouted
				print  '</div><br>'
	print '</td></tr>'
print '</table>'
 
print '<input type="submit"  name="submit"    value="' + submit_ +'">'
print '</form>'

print '</body></html>'

