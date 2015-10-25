#!/bin/sh
if [ -h usr/share/zoneinfo/posix ] ;then
   rm -f usr/share/zoneinfo/posix
   mkdir usr/share/zoneinfo.posix
   ls usr/share/zoneinfo | while read a ;do
      ln -sf ../$a usr/share/zoneinfo.posix/$a
   done
   mv usr/share/zoneinfo.posix usr/share/zoneinfo/posix
fi

rm -f usr/share/icons/rosa/16x16/places/folder-images.svg
ln -sf ../../22x22/places/folder-images.svg usr/share/icons/rosa/16x16/places/folder-images.svg

rm -f usr/share/icons/rosa/48x48/mimetypes/application-x-zip.icon \
usr/share/icons/rosa/48x48/mimetypes/gnome-mime-application-x-zip.icon \
usr/share/icons/rosa/48x48/mimetypes/gnome-mime-application-zip.icon \
usr/share/icons/rosa/48x48/mimetypes/image-x-svg+xml.icon \
usr/share/icons/rosa/48x48/mimetypes/package-x-generic.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-credits.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-csharp.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-c++src.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-csrc.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-css.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-generic.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-generic-template.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-gtkrc.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-install.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-java.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-javascript.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-java-source.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-lua.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-perl.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-python.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-readme.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-ruby.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-script.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-source.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-sql.icon \
usr/share/icons/rosa/48x48/mimetypes/text-x-vala.icon \
usr/share/icons/rosa/48x48/mimetypes/tgz.icon \
usr/share/icons/rosa/48x48/mimetypes/txt2.icon \
usr/share/icons/rosa/48x48/mimetypes/txt.icon \
usr/share/icons/rosa/48x48/mimetypes/unknown.icon \
usr/share/icons/rosa/48x48/mimetypes/vcalendar.icon \
usr/share/icons/rosa/48x48/mimetypes/vcard.icon \
usr/share/icons/rosa/48x48/mimetypes/video.icon \
usr/share/icons/rosa/48x48/mimetypes/video-x-generic.icon \
usr/share/icons/rosa/48x48/mimetypes/vnd.oasis.opendocument.drawing.icon \
usr/share/icons/rosa/48x48/mimetypes/wordprocessing.icon \
usr/share/icons/rosa/48x48/mimetypes/www.icon \
usr/share/icons/rosa/48x48/mimetypes/x-office-address-book.icon \
usr/share/icons/rosa/48x48/mimetypes/x-office-calendar.icon \
usr/share/icons/rosa/48x48/mimetypes/x-office-document.icon \
usr/share/icons/rosa/48x48/mimetypes/x-office-drawing.icon \
usr/share/icons/rosa/48x48/mimetypes/x-office-spreadsheet.icon \
usr/share/icons/rosa/48x48/mimetypes/zip.icon \
usr/share/icons/rosa/48x48/places/folder.icon \
usr/share/icons/rosa/48x48/places/folder-remote-ftp.icon \
usr/share/icons/rosa/48x48/places/folder-remote.icon \
usr/share/icons/rosa/48x48/places/folder-remote-nfs.icon \
usr/share/icons/rosa/48x48/places/folder-remote-smb.icon \
usr/share/icons/rosa/48x48/places/folder-remote-ssh.icon \
usr/share/icons/rosa/48x48/places/gnome-folder.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-blockdev.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-directory.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-ftp.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-network.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-nfs.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-share.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-smb.icon \
usr/share/icons/rosa/48x48/places/gnome-fs-ssh.icon \
usr/share/icons/rosa/48x48/places/gnome-mime-x-directory-smb-share.icon \
usr/share/icons/rosa/48x48/places/gnome-mime-x-directory-smb-workgroup.icon \
usr/share/icons/rosa/48x48/places/gtk-directory.icon \
usr/share/icons/rosa/48x48/places/gtk-network.icon \
usr/share/icons/rosa/48x48/places/inode-directory.icon \
usr/share/icons/rosa/48x48/places/neat.icon \
usr/share/icons/rosa/48x48/places/network.icon \
usr/share/icons/rosa/48x48/places/network_local.icon \
usr/share/icons/rosa/48x48/places/network-workgroup.icon \
usr/share/icons/rosa/48x48/places/redhat-system-group.icon \
usr/share/icons/rosa/48x48/places/stock_folder.icon \
usr/share/icons/rosa/48x48/places/stock_shared-by-me.icon \
usr/share/icons/rosa/48x48/places/stock_shared-to-me.icon \
usr/share/icons/rosa/48x48/places/user-share.icon 

exit 0

# show broken links
find usr/share/icons/rosa -type l | while read a ;do [ -f $(readlink -m $a) ] || echo $a ;done | sort | xargs ls -l
