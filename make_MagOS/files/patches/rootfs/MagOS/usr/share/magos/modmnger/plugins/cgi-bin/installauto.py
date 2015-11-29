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
submit_= _('Install MagOS auto').encode('UTF-8')
not_mouted = _('is not mounted').encode('UTF-8')
autoinstall_header = _('Auto install MagOS linux').encode('UTF-8')
autoinstall_help = _('Select disk and push INSTALL button to start installation.  Be especially careful, you loose all data in selected disk. ').encode('UTF-8')
help_=('Help!').encode('UTF-8')

def install(disk):
		dialog_text='install MagOS - OK!!!'
		command = ('beesu  xterm -e ./autoinstall.sh ' + disk + ' ')
		ret = subprocess.call(command, shell=True)
		if ret != 0:
			dialog_text = ('<br>sorry formating -  FAIL!!!, code:' + ret)
		return dialog_text

form = cgi.FieldStorage()
disk = form.getvalue('physical') or 'none'

if disk != 'none':
	result=install(disk) 

physical = disks.getPhysical()
logical =  disks.getLogical()
 
# make header
cfg.html_header()

print """<style>
#fat32_400 {
    width: 400px;
    height: 30px;
    background: #04E31A;
}

#fat32_250 {
	float: left;
    width: 250px;
    height: 30px;
    background: #04E31A;
}

#ext3_150 { 
	float: left;
    width: 150px;
    height: 30px;
    background: #7BCDE3;
}

#ext2_100 {
   float: left; 
    width: 100px;
    height: 30px;
    background: #DCDCDC;
}

#ext3_260 {
    float: left; 
    width: 260px;
    height: 30px;
    background: #7BCDE3;
}

#swap40 {
	float: left;
    width: 40px;
    height: 30px;
    background: #FF1111;
}
</style>

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
<div class="set"><table id="top" width="320"> <tr><td>
<form action="/cgi-bin/autoinstall.py">'''
print ' <button type="submit">' + update_ + '</button></form>'
print '</td><td>'
print '<form action="/cgi-bin/install_help.py"><button type="submit">' + help_ + '</button></form>'
print '</td></tr></table></div>'

print '<h2>' + select_disk + '</h2>'  
print '<form action="/cgi-bin/autoinstall.py" method="post" name=ds_form>'	
print '<table  id="disk-table" border="1" >'
print '<tr><td align="center">' + flag + '</td><td align="center">' +  device +  '</td><td align="center">' + size + '</td> </tr>'
for key, val in physical.items():
	print '<tr><td rowspan="2"><input type="radio"    name="physical"  value="' + key + '"></td><td><b>' + key + '</b></td><td> ' + val[0]  + ' ' + val[1] + '</td></tr>'
	print '<tr><td colspan="2">'
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

