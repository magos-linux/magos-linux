#!/bin/bash
PFP=etc/gconf/gconf.xml.defaults/%gconf-tree.xml
sed -i s/evolution.desktop/gcalctool.desktop/ $PFP
PFP=/etc/gconf/schemas/panel-default-setup.entries
sed -i s/evolution.desktop/gcalctool.desktop/ $PFP
PFP=etc/xdg/gnome/menus/settings.menu
grep -q MagOS $PFP && exit 0
cat >$PFP <<EOF
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
 "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
 <!-- MagOS gnome menu settings -->

<Menu>

  <Name>Desktop</Name>
  <Directory>X-GNOME-Menu-System.directory</Directory>

  <!-- Read standard .directory and .desktop file locations -->
  <DefaultAppDirs/>
  <DefaultDirectoryDirs/>

  <!-- Read in overrides and child menus from applications-merged/ -->
  <DefaultMergeDirs/>
  <Layout>
    <Merge type="menus"/>
    <Merge type="files"/>
  </Layout>

  <!-- Add a link to the control center -->
  <Include>
    <Filename>gnomecc.desktop</Filename>
  </Include>


</Menu> <!-- End Settings -->
EOF
exit 0
