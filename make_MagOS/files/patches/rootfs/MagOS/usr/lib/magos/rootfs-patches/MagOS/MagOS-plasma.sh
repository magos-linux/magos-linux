#!/bin/bash
PFP=/etc/xdg/plasmarc
[ -f $PFP ] || exit 0
sed -i s/^name=.*/name=magos/ $PFP
PFP=/etc/xdg/kdeglobals
cp -pf /usr/share/magos/plasma/kdeglobals $PFP
sed -i s/^ColorScheme=.*/"ColorScheme=MagOS"/ $PFP
egrep -v "^\[General\]|^Name=|^\[KDE\]|^ColorScheme=|^contrast=|^shadeSortColumn="  "/usr/share/color-schemes/MagOS.colors" >> /etc/xdg/kdeglobals

PFP=/etc/xdg/kscreenlockerrc
cat >$PFP <<EOF
[Daemon]
Autolock=false
LockGrace=300
Timeout=20

[Greeter]
WallpaperPlugin=org.kde.slideshow

[Greeter][Wallpaper][org.kde.slideshow][General]
SlidePaths=/usr/share/magos/screensaver/Default
EOF

PFP=/etc/xdg/ksplashrc
cat >$PFP <<EOF
[KSplash]
Engine=KSplashQML
Theme=org.magos.desktop
EOF

PFP=/etc/xdg/kwinrc
sed -i /^Rows.*/d $PFP
sed -i s/^Number=.*/Number=4\\nRows=2/ $PFP
cat >>$PFP <<EOF

[Plugins]
blurEnabled=false
contrastEnabled=false
kwin4_effect_fadeEnabled=false
kwin4_effect_loginEnabled=false
kwin4_effect_logoutEnabled=false
kwin4_effect_morphingpopupsEnabled=false
kwin4_effect_translucencyEnabled=false
presentwindowsEnabled=false
screenedgeEnabled=false
slidingpopupsEnabled=false
EOF

PFP=/usr/share/plasma/plasmoids/org.kde.plasma.kicker/contents/config/main.xml
sed -i s/rpmdrake.desktop/magos-ctrl-center.desktop/ $PFP

PFP=/usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i s/rpmdrake.desktop/magos-ctrl-center.desktop/ $PFP

[ -f /usr/bin/kdesu5 -a ! -f /usr/bin/kdesu ] && ln -s kdesu5 /usr/bin/kdesu

patch -p1 <<EOF
--- /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js.orig	2018-01-18 06:25:07.000000000 +0300
+++ /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js	2017-12-31 22:12:30.950196149 +0300
@@ -36,23 +36,42 @@ minimizeall.currentConfigGroup = ["Short
 minimizeall.writeConfig("global", "Meta+M")
 
 var dolphin = panel.addWidget("org.kde.plasma.icon")
+dolphin.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.dolphin.desktop")
 dolphin.currentConfigGroup = ["General"]
 dolphin.writeConfig("applicationName", "Dolphin")
 dolphin.writeConfig("iconName", "system-file-manager")
 dolphin.writeConfig("url","file:///usr/share/applications/kde5/org.kde.dolphin.desktop")
 
-var libreoffice = panel.addWidget("org.kde.plasma.icon")
-libreoffice.currentConfigGroup = ["General"]
-libreoffice.writeConfig("applicationName", "LibreOffice Writer")
-libreoffice.writeConfig("iconName", "libreoffice-writer")
-libreoffice.writeConfig("url","file:///usr/share/applications/libreoffice-writer.desktop")
-
 var firefox = panel.addWidget("org.kde.plasma.icon")
+firefox.writeConfig("localPath", "/usr/share/applications/firefox.desktop")
 firefox.currentConfigGroup = ["General"]
 firefox.writeConfig("applicationName", "Firefox")
 firefox.writeConfig("iconName", "firefox")
 firefox.writeConfig("url","file:///usr/share/applications/firefox.desktop")
 
+var thunderbird = panel.addWidget("org.kde.plasma.icon")
+thunderbird.writeConfig("localPath", "/usr/share/applications/mandriva-mozilla-thunderbird.desktop")
+thunderbird.currentConfigGroup = ["General"]
+thunderbird.writeConfig("applicationName", "Thunderbird")
+thunderbird.writeConfig("iconName", "mozilla-thunderbird")
+thunderbird.writeConfig("url","file:///usr/share/applications/mandriva-mozilla-thunderbird.desktop")
+
+var doublecmd = panel.addWidget("org.kde.plasma.icon")
+doublecmd.writeConfig("localPath", "/usr/share/applications/doublecmd.desktop")
+doublecmd.currentConfigGroup = ["General"]
+doublecmd.writeConfig("applicationName", "Double Commander")
+doublecmd.writeConfig("iconName", "doublecmd")
+doublecmd.writeConfig("url","file:///usr/share/applications/doublecmd.desktop")
+
+var kalc = panel.addWidget("org.kde.plasma.icon")
+kalc.writeConfig("localPath", "/usr/share/applications/kde5/org.kde.kcalc.desktop")
+kalc.currentConfigGroup = ["General"]
+kalc.writeConfig("applicationName", "Kalc")
+kalc.writeConfig("iconName", "accessories-calculator")
+kalc.writeConfig("url","file:///usr/share/applications/kde5/org.kde.kcalc.desktop")
+
+panel.addWidget("org.kde.plasma.pager")
+
 var taskmanager = panel.addWidget("org.kde.plasma.taskmanager")
 taskmanager.currentConfigGroup = ["General"]
 taskmanager.writeConfig("groupingStrategy", "0")
EOF

patch -p1 <<EOF
--- /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml.orig	2018-01-02 16:12:27.000000000 +0300
+++ /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml	2018-01-01 12:28:36.596399354 +0300
@@ -12,7 +12,7 @@
     </entry>
     <entry name="Image" type="String">
       <label>Wallpaper image path or wallpaper name</label>
-      <default></default>
+      <default>file:///usr/share/magos/wallpapers/default.jpg</default>
     </entry>
     <entry name="FillMode" type="int">
       <label>Sizing, cropping and positioning of the wallpaper image</label>
EOF
