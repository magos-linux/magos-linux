#!/usr/bin/python3
# -*- coding:utf-8 -*-

import gettext,  cgi, subprocess
import cfg, disks
gettext.install('install-helper', localedir='./locale', codeset=None, names=None)

# file system filters for boot and MagOS dirs
boot_filter=('vfat', 'ntfs', 'ext3', 'linux-native', 'ext2', 'ext4', 'btrfs')
magos_filter=('vfat', 'ntfs', 'ext3', 'linux-native', 'ext2', 'ext4', 'btrfs')
efi_filter=('vfat', 'fat32', 'fat16')

dialog_text = 'none'

# messages for gettext
step2 =  _('Step 2.')
update_ = _('Update')
next_ = _('Next...')
submit_ =_('Copy MagOS files to destination disks')
prev_ = _('Prev...')
magos_header = _('Please select disk to MagOS dir')
magos_data_header = _('Please select disk to MagOS-Data dir')
boot_header = _('Please select disk to boot dir')
efi_header = _('Please select disk to EFI dir')
flag = _('flag')
device = _('device')
size = _('size')
free_size = _('free size')
mount_point = _('mount point')
not_mounted = _('is not mounted yet')
submit_2= _('Copy MagOS linux catalogues to disks')
action =_('Copy MagOS catalogues')
step2_help=_('Selecting disks for  MagOS linux dirs. Catalogues MagOS, MagOS-Data and boot can be located on the same or on different media. Folder MagOS-Data is not required such in MagOS.iso it is not. Directory boot can also be excluded if you use a different boot loader. MagOS catalog contains the main files. MagOS need it anyway.')
help_= _('Help!')
copy_OK = _('Copy MagOS dirs - OK')
copy_fail = _('Copy MagOS dirs - FAIL!!!')
do_not_copy = _('Do not copy')


def magos_install ():
		dialog_text = ( copy_OK )
		command = ('beesu  xterm -e ./magos-install.sh  -m ' + magos + ' -d ' + magos_data   + ' -b  ' + boot  + ' -e' + efi + ' ' )
		ret = subprocess.call(command, shell=True)
		try:
			f = open('/tmp/errorcode', 'r')
			text = copy_fail
			for string  in f.readlines():
				text = text + '  ' + string
			dialog_text = (  str(text.replace('\n', '')) )
			f.close()
		except: 
			dialog_text=copy_OK
		if ret != 0:
			dialog_text = ( dialog_text + '<br>Oooops, somebody killed xterm :(' )
		return dialog_text
		
form = cgi.FieldStorage()
magos = form.getvalue('magos') or  'none' 
boot = form.getvalue('boot') or 'none'
magos_data = form.getvalue('magos-data') or 'none'
efi = form.getvalue('efi') or 'none' 
	
if magos != 'none' or boot != 'none' or magos_data != 'none':
	dialog_text=magos_install() 

#physical = disks.getPhysical()
logical = disks.getLogical()

# make html header
cfg.html_header()
cfg.hide_div()
print('<link type="text/css" href="/css/install-helper.css"   rel="stylesheet" />')

print("""
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
""")
if dialog_text != 'none':
	print('<div id="dialog" title="' + action + '">')
	print(dialog_text + '</div>')

if  dialog_text != 'none' and  dialog_text == copy_OK :
	print("""<script>
    setTimeout( 'location="/cgi-bin/thirdstep.py";', 3000 );
    </script>""")


print('<h1>' + step2 + '</h1><p>' + step2_help + '</p>')
print('<div class="set"><table class="top" > <tr><td>')
print('<form action="/cgi-bin/secondstep.py">')
print(' <button type="submit">' + update_ + '</button></form>')
print('</td><td>')
print('<form action="/cgi-bin/firststep.py"><button type="submit">' + prev_ + '</button></form>')
print('</td><td>')
print('<form action="/cgi-bin/thirdstep.py"><button type="submit">' + next_ + '</button> </form>')
print('</td><td>')
print('<form action="/cgi-bin/install_help.py#step2" method="post">')
print('<input type="hidden" name="back" value="/cgi-bin/secondstep.py">')
print('<button type="submit">' + help_ + '</button></form>')
print('</td></tr></table></div>')

print('<form action="/cgi-bin/secondstep.py" method="post" name=copy_form>')
print('<h3>' + magos_header + '</h3>')

	
print('<table  id="magos-table"  class="bordered-table"   class="bordered_table" >')
print('<tr><td  class="bordered_td">' + flag + '</td><td  class="bordered_td">' +  device +  '</td><td  class="bordered_td">' + size + '</td>') 
print('<td  class="bordered_td">' + free_size + '<td  class="bordered_td">' + mount_point + '</td></td> </tr>')

for key, val in list(logical.items()):
	if val[0][1] in magos_filter != '0':
		print('<tr  title="dirList: ')
		for f in val[1]: 	
			print(f + ' ')
		print('">')	
		print('<td  class="bordered_td"><input type="radio" name=magos id="' + key.replace('/', '-') + '" value="' + key + '"')
		if  val[0][0] == 'MAGOS' and val[0][6] != '/memory/data/from/0':
			print(' checked ')
		print('></td>')
		print('<td  class="bordered_td">' + key + '</td><td  class="bordered_td">' + val[0][2] + '</td><td  class="bordered_td">' + val[0][4] + '</td><td  class="bordered_td">') 
		if val[0][6] != '/dev': 
			print(val[0][6])
		else: 
			print(not_mounted)
			
		print('</td></tr>')
print('<tr><td  class="bordered_td"><input type="radio" name=magos id="magos_none" value="none"></td><td colspan="4" align="center">' + do_not_copy +'</td></tr>')
print('</table>')


print('<h3>' + magos_data_header + '</h3>')
print('<table  id="magos-data-table"   class="bordered-table" >')
print('<tr><td  class="bordered_td">' + flag + '</td><td  class="bordered_td">' +  device +  '</td><td  class="bordered_td">' + size + '</td>') 
print('<td  class="bordered_td">' + free_size + '<td  class="bordered_td">' + mount_point + '</td></td> </tr>')

data_checked = 'no'
for key, val in list(logical.items()):
	if val[0][1] != 'swap':
		print('<tr  title="dirList: ')
		for f in val[1]: 	
			print(f + ' ')
		print('">')	
		print('<td  class="bordered_td"><input type="radio" name="magos-data" id="' + key.replace('/', '-') + '" value="' + key + '"')
		if  val[0][0] == 'MAGOS-DATA' and  val[0][6] != '/memory/data/from/1':
			print(' checked ')
			data_checked = 'yes'
		if  val[0][0] == 'MAGOS' and  val[0][6] != '/memory/data/from/0'  and  data_checked != 'yes':
			print(' checked ')
		print('></td>')
		print('<td  class="bordered_td">' + key + '</td><td  class="bordered_td">' + val[0][2] + '</td><td  class="bordered_td">' + val[0][4] + '</td><td  class="bordered_td">') 
		if val[0][6] != '/dev': 
			print(val[0][6])
		else: 
			print(not_mounted)
			
		print('</td></tr>')
print('<tr><td  class="bordered_td"><input type="radio" name=magos-data  id="magos_data_none" value="none"></td><td colspan="4"  align="center">' + do_not_copy +'</td></tr>')
print('</table>')

print('<h3>' + boot_header + '</h3>')
print('<table  id="boot-table"   class="bordered-table" >')
print('<tr><td  class="bordered_td">' + flag + '</td><td  class="bordered_td">' +  device +  '</td><td  class="bordered_td">' + size + '</td>') 
print('<td  class="bordered_td">' + free_size + '<td  class="bordered_td">' + mount_point + '</td></td> </tr>')

for key, val in list(logical.items()):
	if val[0][1] in boot_filter != '0':
		print('<tr  title="dirList: ')
		for f in val[1]: 	
			print(f + ' ')
		print('">')	
		print('<td  class="bordered_td"><input type="radio" name="boot" id="' + key.replace('/', '-') + '" value="' + key + '"')
		if  val[0][0] == 'MAGOS' and val[0][6] != '/memory/data/from/0':
			print(' checked ')
		print('></td>')
		print('<td  class="bordered_td">' + key + '</td><td  class="bordered_td">' + val[0][2] + '</td><td  class="bordered_td">' + val[0][4] + '</td><td  class="bordered_td">') 
		if val[0][6] != '/dev': 
			print(val[0][6])
		else: 
			print(not_mounted)
			
		print('</td></tr>')
print('<tr><td  class="bordered_td"><input type="radio" name=boot id="boot_none" value="none"></td><td colspan="4"  align="center">' + do_not_copy +'</td></tr>')
print('</table>')

print('<h3>' + efi_header + '</h3>')
print('<table  id="efi-table"   class="bordered-table" >')
print('<tr><td  class="bordered_td">' + flag + '</td><td  class="bordered_td">' +  device +  '</td><td  class="bordered_td">' + size + '</td>') 
print('<td  class="bordered_td">' + free_size + '<td  class="bordered_td">' + mount_point + '</td></td> </tr>')

for key, val in list(logical.items()):
	if val[0][1] in efi_filter != '0':
		print('<tr  title="dirList: ')
		for f in val[1]: 	
			print(f + ' ')
		print('">')	
		print('<td  class="bordered_td"><input type="radio" name="efi" id="' + key.replace('/', '-') + '" value="' + key + '"')
		if  val[0][0] == 'EFI' or val[0][0] == 'MAGOS':
			print(' checked ')
		print('></td>')
		print('<td  class="bordered_td">' + key + '</td><td  class="bordered_td">' + val[0][2] + '</td><td  class="bordered_td">' + val[0][4] + '</td><td  class="bordered_td">') 
		if val[0][6] != '/dev': 
			print(val[0][6])
		else: 
			print(not_mounted)
			
		print('</td></tr>')
print('<tr><td  class="bordered_td"><input type="radio" name=efi id="efi_none" value="none"></td><td colspan="4"  align="center">' + do_not_copy +'</td></tr>')
print('</table>')



print('<br><br>')
print('<input type="submit"  name="submit"    value="' + submit_2 + '"></form>')
print('</body></html>')


