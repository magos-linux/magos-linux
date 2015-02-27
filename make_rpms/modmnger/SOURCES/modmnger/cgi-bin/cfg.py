#!/usr/bin/python
# -*- coding:utf-8 -*-
import os, sys

def config(index):
	cfg = {
	'base_path': 'auto',
	'mod_path': 'auto',
	'opt_path': 'auto',
	'data_mod_path': 'auto',
	'data_opt_path': 'auto',
	'copy2ram': 'auto',
	'css': '/css/default.css',
	'jquery_css': '/css/smoothness/jquery-ui-1.8.20.custom.css',
	'jquery': '/js/jquery.js',
	'jquery_ui': '/js/jquery-ui-1.8.20.custom.min.js',
	'repository': 'auto',
	'mountpoint': '/media/repo',
	'modtype': ('xzm', 'rom', 'rwm', 'enc', 'psf')
		
	}

	if os.path.isfile('/memory/cmdline'):
	  init = 'uird'
	else:
	  init = 'initrd'
		
	if os.path.exists('/mnt/live/etc/modules'):
		f = open('/mnt/live/etc/modules', 'r') 
		a = []
		for string in f.readlines():
			a.append(string)
		f.close()
		arr = {}
		for item in a:
			item =  item.replace('\n', '').replace(' ','')
			if len(item) > 4:
				arr[item.split('=')[0]] =  item.split('=')[1]
		
	if cfg['base_path'] == 'auto':
	  if init == 'uird':
	    cfg['base_path'] = '/memory/layer-base/0/base'
	  else:
	    cfg['base_path'] = '/mnt/livemedia/MagOS/base'
	  
	
	if cfg['mod_path'] == 'auto':
	  if init == 'uird':
	    cfg['mod_path'] = '/memory/layer-base/0/modules'
	  else:
	    try: 
	      cfg['mod_path'] = (arr['MAGOSMODS'] + '/modules').replace('//','/')
	    except: 
	      cfg['mod_path'] = '/mnt/livemedia/MagOS/modules'
	  if not os.path.isdir(cfg['mod_path']):
	    cfg['mod_path'] = 'no_modules'
		
	
	if cfg['opt_path'] == 'auto':
	  if init == 'uird':
	    cfg['opt_path'] = '/memory/layer-base/0/optional'
	  else:
	    try:
	      cfg['opt_path'] = (arr['MAGOSMODS'] + '/optional').replace('//','/')
	    except:
	      cfg['opt_path'] = '/mnt/livemedia/MagOS/optional'
	  if not os.path.isdir(cfg['opt_path']):
	      cfg['opt_path'] = 'no_opt'
		
			
	if cfg['data_mod_path'] == 'auto':
	  if init == 'uird':
	    cfg['data_mod_path'] = '/memory/layer-base/1/modules'
	  else:
	    try:
	      cfg['data_mod_path'] = (arr['MAGOSDATAMODS'] + '/modules').replace('//','/')
	    except:
	      cfg['data_mod_path'] = '/mnt/livemedia/MagOS-Data/modules'
	  if not os.path.isdir(cfg['data_mod_path']):
	    cfg['data_mod_path'] = 'no_data_modules'
			
	if cfg['data_opt_path'] == 'auto':
	  if init == 'uird':
	    cfg['data_opt_path'] = '/memory/layer-base/1/optional'
	  else:
	    try:
	      cfg['data_opt_path'] = (arr['MAGOSDATAMODS'] + '/optional').replace('//','/')
	    except:
	      cfg['data_opt_path'] = '/mnt/livemedia/MagOS-Data/optional'
	  if not os.path.isdir(cfg['data_opt_path']):
	      cfg['data_opt_path'] = 'no_data_optional'
				
	if cfg['copy2ram'] == 'auto':
	  if init == 'uird':
	    cfg['copy2ram'] = '/memory/copy2ram'
	  else:
	    try:
	      cfg['copy2ram'] = arr['CACHE'].replace('//','/')
	    except:
	      cfg['copy2ram'] = ''
			
	if cfg['repository'] == 'auto':
	    try:
	      f = open('/memory/layer-base/0/VERSION', 'r')
	    except:
	      f = open('/mnt/livemedia/MagOS/VERSION', 'r')
		
	    for string in f.readlines():
	        version =  string.split()[0]
	        cfg['repository'] = 'ftp://magos.sibsau.ru/modules/' + str(version)
		
	if index == 'all':
		return cfg
	else:
		return cfg[index]	
		
def html_header():
	a = config('all')
	print"""
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru-ru" lang="ru-ru" >
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<script type="text/javascript" src=" %s "></script>
<link type="text/css" href="%s" rel="stylesheet" />
<script type="text/javascript" src="%s"></script>
<title>MagOS modules manager</title>
<link type="text/css" href="%s" rel="stylesheet" />
<script type="text/javascript" >
$(function(){
	$("#dialog").dialog();
	});
</script>
</head><body>""" % ( a['jquery'], a['jquery_css'], a['jquery_ui'], a['css'])
	

def hide_div():
	print """
	<script type="text/javascript">
	function flash() {
		$('#loader').animate({opacity:0}, 3000);
		$('#loader').animate({opacity:1}, 1000);
		//$('#loader').text('Please wait...');
		};
	
	$(window).load(function() {
		$('#loader').hide();
		clearInterval(deltime);
		$('#body').show();
		$('#body').animate({opacity:0}, 0);
		$('#body').animate({opacity:1}, 1000);
		var iframe = $('#mainframe', parent.document.body);
		iframe.height($(document).height());
		});
	</script>

	<div id="loader"><table height="100" width="100%"><tr><td align="center">
	<h1> Please wait... </h1>
	<!--<img  src="/images/preload.gif" alt="Загрузка" />-->
	</td></tr></table></div>
	<div id="body">
	<script type="text/javascript">
	$('#body').hide();
	$('#loader').animate({opacity:0}, 3000);
	$('#loader').animate({opacity:1}, 1000);
	var deltime = setInterval('flash()', 5000)
	</script>
	"""

if __name__ == '__main__':
	test = ''
	if type(config(sys.argv[1])) == type(test):
		print config(sys.argv[1])
	else:
		for a in config(sys.argv[1]):
			print a,
