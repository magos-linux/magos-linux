#!/usr/bin/python3
# -*- coding:utf-8 -*-

import  gettext, os, cgi,  subprocess
import cfg, disks

boot_filter=('vfat', 'ntfs', 'ext3', 'linux-native', 'ext2', 'ext4', 'btrfs')

gettext.install('install-helper', localedir='./locale', codeset=None, names=None)
dialog_text = 'none'

# messages for gettext
step3= _('Step 3.')
flag = _('flag')
update_= _('Update')
next_= _('Next...')
submit_= _('Install bootloader')
prev_ = _('Prev...')
help_= _('Help!')
step3_help = _('Last step, bootloader installation. Please select bootloader and disk for bootloader installation.')
loader_header =  _('Bootloader selecting ')
script = _('Script ')
comment = _('Comment ')
loader_ = _('Loader')
device = _('device')
mount_point = _('mount point')
no_boot = _('There is no MagOS bootloaders in mounted disks. Try to mount disk manualy, or retry Step 2')
submit_3 = _('Install bootloader')
disk_header =_('Select disk')
action = _('Bootloader install')
finished =_('Bootoader installed')
not_finished =_('Sorry, bootoader is not installed')
comment1  =_('standard bootloader')
 
def getBootDevs():
	boot_mount_points = []
	boot_mount_points.append( [ 'none', 'none' ] )
	for key, val in list(logical.items()):
		if val[0][1] in boot_filter != '0':  
			if os.path.isfile( val[0][6] + '/boot/magos/Install.bat'):
				boot_mount_points.append( [key, val[0][6]] )
	return boot_mount_points


def bootloader_install():
	dialog_text = ( finished )
	try:
		f = open( '/tmp/errorcode' , 'w')
		f.write('error')
		f.close()
	except:
		pass 
	command = ('beesu  xterm -e \' ' + boot_mount  + loader + '  && rm -f /tmp/errorcode \' '  )
	ret = subprocess.call(command, shell=True)
	if os.path.isfile('/tmp/errorcode'):
		dialog_text = ( not_finished )
	if ret != 0:
		dialog_text = ('<br>Oooops, somebody killed xterm :(,  code:' + ' ' + str(ret))
	return  dialog_text

form = cgi.FieldStorage()
boot_mount = form.getvalue('boot-mount') or  'none' 
loader = form.getvalue('loader') or 'none'

dialog_text='none'
if boot_mount != 'none' and  loader != 'none':
	dialog_text=bootloader_install() 

logical = disks.getLogical()
boot_devs = getBootDevs()

# make header
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

# всплывающее окошко
if dialog_text != 'none':
	print('<div id="dialog" title="' + action + '">')
	print(dialog_text + '</div>')

print('<h1>' + step3 + '</h1><p>' + step3_help + '</p>')
print('''
<div class="set"><table class="top" > <tr><td>
<form action="/cgi-bin/thirdstep.py">''')
print(' <button type="submit">' + update_ + '</button></form>')
print('</td><td>')
print('<form action="/cgi-bin/secondstep.py"><button type="submit">' + prev_ + '</button></form>')
print('</td><td>')
print('<form action="/cgi-bin/install_help.py#step3" method="post">')
print('<input type="hidden" name="back" value="/cgi-bin/thirdstep.py">')
print('<button type="submit">' + help_ + '</button></form>')
print('</td></tr></table></div>')

print('<form action="/cgi-bin/thirdstep.py" method="post" name=loader_form>')
print('<h3>' + loader_header + '</h3>')
	
print('<table   class="bordered-table">')
print('<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  loader_ +  '</td><td class="bordered_td">' + script + '</td>') 
print('<td class="bordered_td"> MBR <td class="bordered_td">' + comment  + '</td></td> </tr>')
print('<tr><td class="bordered_td"><input type="radio" checked name=loader id="syslinux" value="/boot/magos/Install.bat"></td>')
print('<td class="bordered_td">syslinux</td><td class="bordered_td">.../boot/magos/Install.bat</td><td class="bordered_td">Yes</td><td class="bordered_td">' + comment1 +'</td></tr>')
print('</table>')

if len(boot_devs[0][0]) != 0:
	print('<h3>' + disk_header + '</h3>')
	print('<table  class="bordered-table">') 
	print('<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  device +  '</td><td class="bordered_td">' + mount_point + '</td></tr>')
	for dev in boot_devs:
		if dev[0] != 'none':
			print('<tr><td class="bordered_td"><input type="radio" name="boot-mount" id="' + dev[0].replace('/', '-') + '" value="' + dev[1] + '"></td>')
			print('<td class="bordered_td">' + dev[0] + '</td><td class="bordered_td">' + dev[1] + '</td></tr>') 
	print('</table>')
	print('<input type="submit"  name="submit"    value="' + submit_3 + '"></form>')
	

print('</body></html>')

