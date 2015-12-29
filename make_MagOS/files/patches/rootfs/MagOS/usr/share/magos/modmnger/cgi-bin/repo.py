#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys, os, re, cgi, lib_mod_map, cfg, gettext
gettext.install('mod_mnger', './locale', unicode=True)

import cgitb
cgitb.enable()

# for gettext
mount = _('Mount').encode('UTF-8') 
umount = _('Unmount ftp').encode('UTF-8') 
Repository = _('Repository:').encode('UTF-8')
Search = _('Search:').encode('UTF-8')
title = _('Repository filelist, click link to choose action').encode('UTF-8')
allready_mounted = _('Repository allready mounted, <br> mountpoint is:').encode('UTF-8')
mount_ftp  = _('Mouting ftp server:').encode('UTF-8')
update = _('Server last update:').encode('UTF-8')

repository = cfg.config('repository')
mountpoint = cfg.config('mountpoint') + '/'
modType = cfg.config('modtype')
dialog_text = ['none',]
n = 1

# анализ cgi запроса
form = cgi.FieldStorage()
url = form.getvalue('url') or 'none' 
action = form.getvalue('action') or 'none'


def getList(pathDir):
	dirlist = os.listdir(pathDir)
	dirLs = []
	for file in dirlist:
		for modtype in modType:
			dirLs += re.findall('^.*.' + modtype + '$', file)
		dirLs.sort()
	return  dirLs


def getFname(pathDir):
	Fname = []
	for a in os.listdir(pathDir):
		if a[-4:] == '.pkl':
			Fname.append(a)
	if len(Fname) != 1:
			return 'none'
	else:
			return (mountpoint +'/' + Fname[0], '%s-%s-%s' % (Fname[0][:4], Fname[0][4:6], Fname[0][6:8]))

def makeList(pathDir):
	dirList = {}
	for subdir in lib_mod_map.getSubdirs(pathDir, 'include_root'):
		sizeList = {}
		dirLs = getList(subdir)
		if not len(dirLs) == 0:
			for b in dirLs:
				size = os.path.getsize(subdir + '/' + b) / 1024
				sizeList[b] = size
				dirList[subdir.replace(pathDir, '')] = sizeList
	return dirList



def printUL ( b,  fullname, size):
	global n
	n = n + 1 
	ID = b.replace( '-', '__').replace( '.', '_').replace(' ','__') + str(n)
	liID = ('liID_' + ID)
	formID = ('formID_' + ID)
	inputID = ('inputID_' + ID)
	submitCommand = (formID + '.submit();')
	print '<tr'
	if n%2==0:
		print 'class="tr_grey"'
	print '><td> '
	print '<form action="/cgi-bin/open.py" method="post" name=\'' + formID + '\'>'
	print '<input name="modname" type="hidden" value="'  + fullname + '"'
	print '<input name="action" type="hidden" value="none"  id=\'' + inputID + '\'></form>'
	print '<div id="' + liID + '" onclick="', submitCommand, 'action(\'' + inputID + '\','  '\'activate\')"'
	print 'onmouseover="textBig(\'' + liID + '\')" onmouseout="textNormal(\'' + liID + '\')">'
	print  b + '</div>'
	print '<td align="right">'
	if size <= 1024:
		print str(size) + 'Kb'
	else:
		print str(size / 1024) + 'Mb' 
	print '</td></tr>'

 
def printTable(pathDir, header,  title): 
	Fname = getFname(pathDir)
	if Fname != 'none':
		import  pickle
		Pkl = open(Fname[0], 'rb')
		fullList = pickle.load(Pkl)
		Pkl.close()
		date = Fname[1]
	else:
		date = 'none'
		fullList = makeList(pathDir)

	print '<table id="' + header + '" class="repo_table" ><tr>'
	print '<td class="table_header"  title="' + title + '"><br>' + header + '</td></tr>'
	if  date != 'none':
		print '<tr><td align="right"><i>' + update + '</i><strong>  ' + date + '</strong></td></tr>'
	print '</table>'
	for subdir, modlist in fullList.items():
		print '<table class="repo_table">'
		print '<tr><td align="left" colspan=2>'
		print '<strong>/' +  subdir + '</strong></td></tr>'
		for mod, size in modlist.items():
				fullname = (pathDir  + '/' + subdir  + '/' + mod).replace('//', '/')
				printUL( mod, fullname, size)
	print '</table>'
 
  
def mountform ():
	url = repository
	if dialog_text[0] != 'none':
		print '<div id="dialog" title="' + action + '">'
		print dialog_text[0] + '</div>'
	print '<form action="/cgi-bin/repo.py" method="post" id="repo_form" name="repo_form">'	
	print '<div class="set">'
	print '<h3>' + mount_ftp + '</h3>'   
	print '<input name="url" type="text" id="ftp_url" value="' + url + ' "size="60"><br>'
	print '<input type="hidden" name="action" value="mount">'
	print '<input type="button" onclick="formSubmit()"  value="' + mount + '">'
	print '</form></div>'
	print """
		<script type="text/javascript">
		var iframe = $('#mainframe', parent.document.body);
		iframe.height(500);
		</script>"""

def modlistform():
	print '<table class="head_table" width="100%"  ><tr>'
	print '<td width="80%" height="80"><strong>' + allready_mounted + mountpoint + '</strong></td>'
	print '<td align="right"><form id="umount" action="/cgi-bin/repo.py" method="post">'
	print '<div class="set">'
	print '<input type="hidden" name="action" value="umount">'
	print '<input type="submit" value="' + umount + '">'
	print '</div></form></td></tr>'
	print '<tr><td><strong>' + Search + '</strong>'
	print '<input type="text" id="text" size="60" onchange="search()" name="text"></td>'
	print '<td></td></tr>'
	print '<table class="repo_table">'
	printTable(mountpoint,  Repository,  title)
	print '</td></tr'
	print '</table></div>'	
	if dialog_text[0] != 'none':
		print '<div id="dialog" title="' + action + '">'
		print dialog_text[0] + '</div>'
	

cfg.html_header()
cfg.hide_div()

print """
	<style>
    body{
    cursor: pointer /* cursor like hand */
    }
    </style> 
	
	<script type="text/javascript" src="/js/scroll2.js"></script>
	<script type="text/javascript" src="/js/highlight.js"></script>
	<script type="text/javascript">
	
	$(function(){
	$("input:text, input:submit").button();
	$("div.set").buttonset();
	});

	$(function(){
	var availableTags = ["ftp://sibsau.magos-linux.ru", "ftp://mirror.yandex.ru", "ftp://192.168.2.31", "ftp://127.0.0.1"];
	$("#ftp_url").autocomplete({
		source: availableTags
	});
	});

	function textBig( elmId ) {
	document.getElementById( elmId ).style.fontSize="110%";
	}
	function textNormal( elmId ) {
	document.getElementById( elmId ).style.fontSize="100%";
	}
	function action( elmId, action ) {
	document.getElementById( elmId ).value=action;
	}
	$(function(){
	$("#dialog").dialog();
	});
	
	function formSubmit() {
		$('#body').animate({opacity:0}, 1000);
		$('#loader').show();
		$('#loader').animate({opacity:0}, 3000);
		$('#loader').animate({opacity:1}, 1000);
		$('#body').hide()
		var deltime = setInterval('flash()', 5000)
		$('#repo_form').submit();
		};
		
	function search () {
	var searchTerm = $('#text').val();
	$('.repo_table').unhighlight();
	if ( searchTerm ) {
		$('.repo_table').highlight( searchTerm );
	}
	var firstTerm = $('.highlight').first();
	$(parent.window).scrollTo( firstTerm, '800');
	};
	</script>
	"""

if action != 'umount' and os.path.ismount(mountpoint):
	modlistform()
elif action == 'mount' and not os.path.ismount(mountpoint):
	dialog_text = lib_mod_map.ftpmount(url, 'mount')
	if dialog_text[1] == 0: 
		modlistform()
	else:
		mountform()
elif action == 'umount':
	dialog_text = lib_mod_map.ftpmount(' ', 'umount')
	if dialog_text[1] == 0: 
		mountform()
	else:
		modlistform()
else:
	mountform()
	
print '</body></html>' 	
