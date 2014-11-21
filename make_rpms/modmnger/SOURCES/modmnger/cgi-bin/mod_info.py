#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, cgi, re, cfg, urllib, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# ошибки в окно, потом закомментить надо
import cgitb
cgitb.enable()

#for gettext
header = _('Info: ').encode('UTF-8') 
compress = _('compression:' ).encode('UTF-8')
doc = _('documentation').encode('UTF-8')
rpmlist = _('rpm packeges list').encode('UTF-8')
filelist = _('files list' ).encode('UTF-8')
modsize = _('module size').encode('UTF-8')
dirsize = _('extracting module size').encode('UTF-8')
Search = _('Search in lists').encode('UTF-8')
mark = _('enter search string ').encode('UTF-8')
		
# анализ запроса
form = cgi.FieldStorage()
modnameGET = form.getvalue('modnameGET') or 'none'	
path_modname = urllib.unquote(modnameGET)

#имя модуля без .xzm
p = re.compile('(^/.*/(.*)[.]xzm)')
a =  p.match(path_modname)
modname = a.group(2)

def getsize(path_modname, mountdir):
	mod_size = os.path.getsize(path_modname) / 1024
	dir_size = 0
	for dirpath, dirnames, filenames in os.walk(mountdir):
		for f in filenames:
			fp = os.path.join(dirpath, f)
			if os.path.islink(fp):
				pass 
			else:
				dir_size += os.path.getsize(fp) / 1024 
				
	percent = 100 - (mod_size * 100 / dir_size)
	return (percent, mod_size, dir_size)

def getlist(dir, ret):
	print ret
	for name in os.listdir(dir):
		path = os.path.join(dir, name)
		if os.path.islink(path):
			a = path.replace('/tmp/squashfs/'+ modname, '<i>link--></i>')
			print a + '<br>'
		else:
			if os.path.isfile(path):
				a = path.replace('/tmp/squashfs/'+ modname, '')
				print a + '<br>'
			else:
				try:
					getlist(path, '')
				except:
					a = path.replace('/tmp/squashfs/'+ modname, '<b>permission denided</b>-->')
					print a + '<br>'
	return ''

def getdoc(modname):
	a = '   '
	lang = os.environ['LANG'] 
	filename = '/tmp/squashfs/' + modname + '/usr/share/doc/modules/' + modname + '.' + lang 
	if os.path.exists(filename):
		pass
	else: 
		filename = '/tmp/squashfs/' + modname + '/usr/share/doc/modules/' + modname	
	
	try:
		f = open(filename, 'r')
		for strings  in f.readlines():
			a = a + strings + '<br>'
		f.close()
	except:
		 a ='no docs'
	
	return a
	

def getrpmlist(modname):
	filename = '/tmp/squashfs/' + modname + '/var/lib/rpm/modules/' + modname 
	a = 'rpm list: <br>'
	try:
		f = open(filename, 'r')
		for strings  in f.readlines():
			a = a + strings + '<br>'
		f.close()
	except: 
		a = 'no rpmlist'
		
	return a



# html head from html_header file
cfg.html_header()
cfg.hide_div()
print """
	<script type="text/javascript" src="/js/scroll2.js"></script>
	<script type="text/javascript" src="/js/highlight.js"></script>
	<script type="text/javascript">
	function search () {
	var searchTerm = $('#text').val();
	$('.td_info').unhighlight();
	if ( searchTerm ) {
		$('.td_info').highlight( searchTerm );
	}
	var firstTerm = $('.highlight').first();
	$.scrollTo( firstTerm, '800');
	};
	</script>"""


print '<table id="info_table" ><tr><td colspan="2"><h1 align="center">' 
print  header +  modname + '</h1></td></tr>'
size = getsize(path_modname,  '/tmp/squashfs/' + modname)
print '<tr><td colspan="2" class="td_info"> %s: %d KB<br> %s: %d KB<br> %s: %d %s </td></tr>' % ( modsize, size[1], dirsize, size[2], compress,  size[0], '%')
print '<tr><td colspan="2"><h3>' + doc + '</h3></tr></td>' 
print '<tr><td colspan="2" height="10%" class="td_info">'
print getdoc(modname)
print '</td></tr>'
print '<tr><td><h3>'+ Search +'</h3></td><td></td></tr>'
print '<tr><td  colspan="2" class="td_info"><br>'+ mark + ':<br>'
print '<input type="text" id="text" size="60" onchange="search()"  name="text">'
print '</td></tr>'
print '<tr class="list"><td><h3>%s </h3></td><td> <h3>%s</h3> </td></tr>' % (rpmlist, filelist)
print '<tr height="600px"><td id="rpm_list" class="td_info">'
print getrpmlist(modname)
print '</td><td id="file_list" class="td_info">'
print getlist('/tmp/squashfs/' + modname, filelist + ':<br>')
print '</td></tr>'
print '</table></div></body></html>'



