#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, cgi, re, cfg, urllib, gettext
gettext.install('mod_mnger', './locale', unicode=True)

# ошибки в окно, потом закомментить надо
import cgitb
cgitb.enable()

#for gettext
header = _('Info: ').encode('UTF-8') 
doc = _('additional info ').encode('UTF-8') 
compress = _('compression:' ).encode('UTF-8')
filelist = _('files list' ).encode('UTF-8')
modsize = _('module size').encode('UTF-8')
dirsize = _('extracting module size').encode('UTF-8')
Search = _('Search in lists').encode('UTF-8')
mark = _('enter search string ').encode('UTF-8')
packages = _('packages ').encode('UTF-8')
depends = _('dependenses ').encode('UTF-8')
algorithm = _('compression algorithm ').encode('UTF-8')



		
# анализ запроса
form = cgi.FieldStorage()
modnameGET = form.getvalue('modnameGET') or 'none'	
modname = urllib.unquote(modnameGET)

#имя модуля без .xzm
#p = re.compile('(^/.*/(.*)[.]pfs)')
#a =  p.match(path_modname)
#modname = a.group(2)

def getarr(info):
	arr = {}
	for key_val in info:
		if len(key_val.split(': ')) == 2:		
			arr[key_val.split(': ')[0].replace(' ', '_')] = key_val.split(': ')[1]
	return arr
 
def getlist(modname):
	command = ('unsquashfs -l  ' + modname )
	ret = os.popen( command ).read()
	flist = []
	for string  in ret.split('\n'):
	        flist.append( string.replace('squashfs-root', ''))
	return flist

def getinfo(modname):
	command = ('beesu  pfsinfo --stat  ' + modname  )
	ret = os.popen(command).read()
	info = []
	for string  in ret.split('\n'):
	        info.append( string )
	return info

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

flist = getlist(modname)
info = getinfo(modname)
keyarr = getarr(info)

print '<table id="info_table" ><tr><td colspan="2"><h1 align="center">' 
print  header +  modname + '</h1></td></tr>'
print '<tr><td  class="td_info"> %s: %s  <br> %s: %s <br> %s: %s  <br> %s: %s  </td>' % ( algorithm,  keyarr['Compression_algorithm'],  modsize, keyarr['Module_size'], dirsize, keyarr['Uncompressed_size'], compress,  keyarr['Compression_ratio'] )
print '<td  class="td_info"> %s: <br>%s <br> %s: <br> %s  </td></tr>' % ( packages, keyarr['Packages'], depends, keyarr['Dependenses'] )
print '<tr><td colspan="2"><h3>' + doc + '</h3></tr></td>' 
print '<tr><td colspan="2" height="10%" class="td_info">'
begin = 'no'
for a in info:
	if begin == 'yes':
		print a + '<br>'
	if len(a) == 0:
	    begin = 'yes'
print '</td></tr>'
print '<tr><td><h3>'+ Search +'</h3></td><td></td></tr>'
print '<tr><td  colspan="2" class="td_info"><br>'+ mark + ':<br>'
print '<input type="text" id="text" size="60" onchange="search()"  name="text">'
print '</td></tr>'
print '<tr class="list"><td colspan="2"><h3>%s </h3></td></tr>' % (filelist)
print '<tr height="600px"><td colspan="2" id="file_list" class="td_info">'
begin = 'no'
for a in flist:
	if begin == 'yes':
		print a + '<br>'
	if len(a) == 0:
	    begin = 'yes'
print '</td></tr>'
print '</table></div></body></html>'



