#!/usr/bin/python
# -*- coding:utf-8 -*-

import gettext,  cgi, subprocess
import cfg, disks, os
gettext.install('install-helper', './locale', unicode=True)

dialog_text = 'none'

# messages for gettext
update_ = _('Update').encode('UTF-8')
submit_ =_('Copy MagOS files to destination disks').encode('UTF-8')
prev_ = _('Prev...').encode('UTF-8')
flag = _('flag').encode('UTF-8')
device = _('device').encode('UTF-8')
mount_point = _('mount point').encode('UTF-8')
not_mounted = _('is not mounted yet').encode('UTF-8')
help_= _('Help!').encode('UTF-8')
sync_OK = _('Sync MagOS  - OK').encode('UTF-8')
sync_fail = _('Sync MagOS dirs - FAIL!!!').encode('UTF-8')
update_header = _('Update MagOS').encode('UTF-8')
update_help = _('This tool update already installed MagOS to booting version. For example you can update MagOS in flash drives to version installed in harddrive. To update current installation from intrernet you must use netboot').encode('UTF-8')
no_magos= _('MagOS instalations is not found, may be disk is not mount. ').encode('UTF-8')
submit_ = _('Update MagOS').encode('UTF-8')
action = _('Updating').encode('UTF-8')
current = _('Current version').encode('UTF-8')
ver = _('MagOS version').encode('UTF-8')

def magos_update ( ):
		dialog_text = ''
		for MagOSdir in magoslist:
			command = ('beesu  xterm -e ./magos-install.sh  -m ' + MagOSdir + ' ' )
			ret = subprocess.call(command, shell=True)
			try:
				f = open('/tmp/errorcode', 'r')
				text = sync_fail
				for string  in f.readlines():
					text = text + '  ' + string
				dialog_text = (  dialog_text + '   ' + str(text.replace('\n', '')) )
				f.close()
			except: 
				dialog_text= dialog_text + '<br>' + MagOSdir + '<br>' + sync_OK + '<br>'
			if ret != 0:
				dialog_text = ( dialog_text + ' <br>Oooops, somebody killed xterm :(' )
		return dialog_text
		
def getMagosDevs():
	magos_mount_points = []
	for key, val in logical.items():  
			if val[0][6] != '/dev' and  val[0][6] != '/mnt/livemedia' and os.path.isfile( val[0][6] + '/MagOS/VERSION'):
				file_ver = open(  val[0][6] +'/MagOS/VERSION', 'r' )
				version = str(file_ver.read().replace('\n', '') )
				file_ver.close() 
				magos_mount_points.append( [key, val[0][6], version] )
	return magos_mount_points 

form = cgi.FieldStorage()
magos = form.getvalue('magos-mount') or  'none' 
magoslist=[]

if type(magos) == type(magoslist):
	magoslist = magos
else:
	 magoslist = [ magos, ]

if magos != 'none' :
	dialog_text=magos_update() 

#physical = disks.getPhysical()
logical = disks.getLogical()
magos_devs = getMagosDevs()

file_ver = open( '/mnt/livemedia/MagOS/VERSION', 'r' )
version = str(file_ver.read().replace('\n', '') )
file_ver.close()

# make html header
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
	print '<div id="dialog"  title="' + action + '">'
	print dialog_text + '</div>'

print '<h1>' + update_header + '</h1><p>' + update_help + '</p>'
print '<div class="set"><table class="top" > <tr><td>'
print '<form action="/cgi-bin/update.py">'
print ' <button type="submit">' + update_ + '</button></form>'
print '</td><td>'
print '<form action="/cgi-bin/install.py"><button type="submit">' + prev_ + '</button></form>'
print '</td><td>'
print '<form action="/cgi-bin/install_help.py#update" method="post">'
print '<input type="hidden" name="back" value="/cgi-bin/update.py">'
print '<button type="submit">' + help_ + '</button></form>'
print '</td></tr></table></div>'


if len(magos_devs) != 0:
	print '<form action="/cgi-bin/update.py" method="post" >'
	print '<h3>' + current  + ':    ' + version + '</h3>'
	print '<table  class="bordered-table">' 
	print '<tr><td class="bordered_td">' + flag + '</td><td class="bordered_td">' +  device +  '</td><td class="bordered_td">' + mount_point + '</td><td class="bordered_td">' + ver + '</td></tr>'
	for dev in magos_devs:
		print  '<tr><td class="bordered_td"><input type="checkbox" name="magos-mount"  id="' + dev[0].replace('/', '-') + '" value="' + dev[1] + '"></td>'
		print '<td class="bordered_td">' + dev[0] + '</td><td class="bordered_td">' + dev[1] + '</td><td class="bordered_td">' + dev[2] + '</td></tr>' 
	print '</table><br>'
	
	print '<input type="submit"  name="submit"    value="' + submit_ + '"></form>'
else:
	print '<p>' + no_magos + '</p>'

print '</body></html>'
