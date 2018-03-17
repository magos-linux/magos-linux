#!/bin/bash
write2file()
{
  [ -f "$1" -o ! -d "$(dirname $1)" ] && return
  cat >"$1" <<EOF
#!/usr/bin/python
# -*- coding:utf-8 -*-
import os,  sys, tempfile, shutil

def unsq_list(arch):
	command = ('unsquashfs -ll ' + arch + ' |sed \'1,4d\'')
	for line in os.popen( command ).read().split('\n'):
		if len(line) != 0:
			items=line.split()
			if len(items) == 8 :
				print  items[0], '1', items[1].split('/')[0], items[1].split('/')[1], items[2], items[3].split('-')[1] + '-' + items[3].split('-')[2] + '-' + items[3].split('-')[0], items[4], items[5].replace('squashfs-root/', ' ') + ' -> ' + items[7]  
			if len(items) == 6 :
				print  items[0], '1', items[1].split('/')[0], items[1].split('/')[1], items[2], items[3].split('-')[1] + '-' + items[3].split('-')[2] + '-' + items[3].split('-')[0], items[4], items[5].replace('squashfs-root/', ' ')

def copyout(arch, filename, dest):
	tmpdir = tempfile.mkdtemp()
	command = ('unsquashfs -f -d ' +  tmpdir + " " +  arch +   ' -e /' + filename )
	os.popen(command)
	shutil.copy2(tmpdir + '/' + filename, dest )
	shutil.rmtree(tmpdir, ignore_errors=True)

if sys.argv[1] == 'list':
	unsq_list( sys.argv[2] )
if sys.argv[1] == 'copyout':
	copyout( sys.argv[2], sys.argv[3], sys.argv[4] )
EOF
  chmod 755 "$1"
}

PFP=/etc/mc/mc.ext
[ -f $PFP ] || exit 0
grep -q xzm $PFP || sed -i /"view lzma$"/s'|$|'\\n\\n'# xzm'\\n'regex/\\.xzm$'\\n\\t'Open=%cd %p/xzm://|' $PFP
PFP=/etc/mc/filehighlight.ini
grep -q xzm $PFP || sed -i s/lzma/'lzma;xzm'/ $PFP
write2file /usr/lib/mc/extfs.d/xzm
write2file /usr/lib64/mc/extfs.d/xzm
