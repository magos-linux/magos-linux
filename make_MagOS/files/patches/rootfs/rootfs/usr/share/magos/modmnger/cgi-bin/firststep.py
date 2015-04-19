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
step1 = _('Step 1.').encode('UTF-8')
select_disk = _('Please select disk to format:').encode('UTF-8')
select_type = _('Please select partitions:').encode('UTF-8')
gparted = _('Use gparted').encode('UTF-8')
none= _('Nothing to do').encode('UTF-8')
title_type5= _('Standard fat32  flash drive for simple MagOS  installation.').encode('UTF-8')
title_type6= _('For NTFS flash drive, is not recomended to install MagOS.').encode('UTF-8')
title_type2= _('ext3 for MagOS installation, and fat32 or ntfs (if more then 4GB) for data. MagOS will invisible from windows').encode('UTF-8')
title_type3= _('Recomended partitions for install MagOS in hdd').encode('UTF-8')
title_type4= _('Recomended partitions for install MagOS in virtualbox, or for linux only flash drive').encode('UTF-8')
update_= _('Update').encode('UTF-8')
next_= _('Next...').encode('UTF-8')
submit_= _('Format').encode('UTF-8')
gparted_start = _('Start gparted').encode('UTF-8')
prev_ = _('Prev...').encode('UTF-8')
if_you = _('If  you need  another partitions, you may  ').encode('UTF-8')
step1_help = _(' Preparing disks  for installation Magos. If your drive is already formatted, you can skip this step. If formatting is necessary  select the drive in the top table and the method of formating in the bottom, then click "Format". Be especially careful. Full information under "Help" button.  ').encode('UTF-8')
help_= _('Help!').encode('UTF-8')
not_mouted = _('is not mounted').encode('UTF-8')
format_ok = _('partitions created!!!').encode('UTF-8')
format_fail= _('partitions create fail, code:').encode('UTF-8')
action =_('Create partitions').encode('UTF-8')

def formating(disk, format_type):
		command = ('beesu  xterm -e ./parted.sh  ' + disk + ' ' + format_type + ' ')
		ret = subprocess.call(command, shell=True)
		try:
			f = open('/tmp/errorcode', 'r')
			text = format_fail
			for string  in f.readlines():
				text = text + '  ' + string
			dialog_text = (  str(text.replace('\n', '')) )
			f.close()
		except: 
			dialog_text=format_ok
		if ret != 0:
			dialog_text = ( dialog_text + '<br>Oooops, somebody killed xterm :(' )
		return dialog_text
		
def gparted_exec():
	command = ('gparted')
	ret=subprocess.call(command, shell=True)
	dialog_text = 'Gparted finished'
	return dialog_text

form = cgi.FieldStorage()
gparted = form.getvalue('gparted') or  'none' 
disk = form.getvalue('physical') or 'none'
format_type = form.getvalue('format-type') or 'none'
 
if gparted == 'start':
	dialog_text=gparted_exec()
	
if gparted == 'none' and disk != 'none' and format_type != 'none':
	dialog_text=formating(disk, format_type) 

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
 
if  dialog_text != 'none' and  dialog_text == format_ok :
	print """<script>
    setTimeout( 'location="/cgi-bin/secondstep.py";', 3000 );
    </script>"""


print '<h1>' + step1 + '</h1><p>' + step1_help + '</p>'
print '''
<div class="set"><table class="top" > <tr><td>
<form action="/cgi-bin/firststep.py">'''
print ' <button type="submit">' + update_ + '</button></form></td>'
print '<td><form action="/cgi-bin/install.py"><button type="submit">' + prev_ + '</button></form></td>'
print '<td><form action="/cgi-bin/secondstep.py">'
print '<button type="submit">' + next_ + '</button> </form>'
print '</td><td>'
print '<form action="/cgi-bin/install_help.py#step1" method="post">'
print '<input type="hidden" name="back" value="/cgi-bin/firststep.py">'
print '<button type="submit">' + help_ + '</button></form>'
print '</td></tr></table></div>'

print '<h2>' + select_disk + '</h2>'  
print '<form action="/cgi-bin/firststep.py" method="post" name=ds_form>'	
print '<table  class="bordered-table" >'
print '<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  device +  '</td><td class="bordered_td">' + size + '</td> </tr>'
for key, val in physical.items():
	print '<tr><td class="bordered_td" rowspan="2"><input type="radio"    name="physical"  value="' + key + '"></td><td class="bordered_td"><b>' + key + '</b></td><td class="bordered_td" > ' + val[0]  + ' ' + val[1] + '</td></tr>'
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

print '<h2>' + select_type + '</h2>' 
print '<table  class="bordered-table" >'
print '<tr align="center" title="' + title_type5 + '"><td class="bordered_td"><input type="radio"    name="format-type"  value="type5"></td><td align="left" ><div id="fat32_400">fat-32</div></td></tr>'
print '<tr align="center" title="' + title_type6 + '"><td class="bordered_td"><input type="radio"    name="format-type"  value="type6"></td><td align="left" ><div id="ntfs_400">ntfs</div></td></tr>'
print '<tr align="center" title="' + title_type4 + '"><td class="bordered_td"><input type="radio"    name="format-type"  value="type4"></td><td align="left" ><div id="ext3_400">ext3</div></td></tr>'
print '<tr align="center" title="' + title_type2 + '"><td class="bordered_td"><input type="radio"    name="format-type"  value="type2"></td><td align="left" ><div id="fat32_250">fat-32 / ntfs</div><div id="ext3_150">ext 3</div></td></tr>'
print '<tr align="center" title="' + title_type3 + '"><td class="bordered_td"><input type="radio"    name="format-type"  value="type3"></td><td align="left" ><div id="ext2_100">ext 2</div><div id="swap40">swap</div><div id="ext3_260">ext 3</div></td></tr></table>'
print '</td></tr></table>' 
print '<input type="submit"  name="submit"    value="' + submit_ +'">'
print '</form>'


print '<br>' + if_you
print '<form action="/cgi-bin/firststep.py">'
print '<input type="hidden" value="start" name="gparted">'

print '<div class="set"><button type="submit">' + gparted_start + '</button><div></form>'

print '</body></html>'
