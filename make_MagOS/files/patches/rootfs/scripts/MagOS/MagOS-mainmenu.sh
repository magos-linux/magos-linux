#!/bin/bash

function update_app
{
 sed -i "s/^.*Categories=.*$/Categories=$2/" usr/share/applications/$1 2>/dev/null
}

ln -sf MagOS-applications.menu etc/xdg/menus/applications.menu
ln -sf MagOS-applications.menu etc/xdg/menus/kde-applications.menu

update_app cheese.desktop "GNOME;AudioVideo;Recorder;"
update_app devede.desktop "AudioVideo;DiscBurning;"
update_app gnomecc.desktop "GNOME;GTK;Settings;X-MandrivaLinux-System-Configuration-GNOME;"
update_app gnome-ppp.desktop "Network;GNOME;Dialup;"
update_app gnome-screenshot.desktop "GTK;GNOME;Utility;Graphics;Scanning;"
update_app gnome-system-monitor.desktop "GNOME;GTK;System;Monitor;"
update_app gxneur.desktop "GTK;GNOME;Settings;HardwareSettings;"
update_app lxrandr.desktop "Settings;X-LXDE-Settings;"
update_app lxtask.desktop "GTK;System;Monitor;X-LXDE-Settings;"
update_app mandriva-grip.desktop "GTK;AudioVideo;Audio;AudioRipper;"
update_app mandriva-mountloop.desktop "Security;System;"
update_app mandriva-mtink.desktop "System;Printing;"
update_app mandriva-tightvnc.desktop "Network;RemoteAccess;"
update_app mandriva-wireshark.desktop "GTK;X-MandrivaLinux-System-Monitoring;System;Monitor;Network;"
update_app mandriva-wireshark-root.desktop "GTK;System;Monitor;Network;"
update_app mandriva-z42tool.desktop "System;Printing;"
update_app net_applet.desktop "GTK;Network;Monitor;X-MandrivaLinux-CrossDesktop;"
update_app obconf.desktop "Settings;DesktopSettings;GTK;X-LXDE-Settings;"
update_app remmina.desktop "GTK;GNOME;X-GNOME-NetworkSettings;Network;RemoteAccess;"
update_app djvulibre-djview3.desktop "Qt;Office;Viewer;"
update_app djvulibre-djview4.desktop "Qt;Office;Viewer;"
update_app startcenter.desktop "Office;Editor;"
update_app draw.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app base.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app web.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app dia.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-base.desktop "Office;Editor;;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-calc.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-draw.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-impress.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-math.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-startcenter.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app libreoffice-writer.desktop "Office;Editor;X-MandrivaLinux-CrossDesktop;"
update_app java-1.6.0-sun-controlpanel.desktop "Settings;X-MandrivaLinux-CrossDesktop;"
update_app java-1.6.0-sun-javaws.desktop "Settings;X-MandrivaLinux-CrossDesktop;"
update_app java-1.6.0-sun-javaws_viewer.desktop "Settings;X-MandrivaLinux-CrossDesktop;"
update_app java-1.6.0-sun-policytool.desktop "Settings;X-MandrivaLinux-CrossDesktop;"
update_app gparted.desktop "GTK;System;Filesystem;Settings;HardwareSettings;X-MandrivaLinux-System-Configuration;"
update_app rawtherapee.desktop "GTK;Graphics;2DGraphics;RasterGraphics;X-MandrivaLinux-CrossDesktop;"
update_app nautilus-browser.desktop "GNOME;GTK;System;Utility;Core;FileManager;"
update_app PlayOnLinux.desktop "Emulator;"
update_app easytag.desktop "Audio;AudioVideoEditing;GTK;X-MandrivaLinux-CrossDesktop;"
update_app parcellite.desktop "Settings;X-LXDE-Settings;"
update_app gucharmap.desktop "GNOME;GTK;Utility;TextEditor;"
update_app gnome-disks.desktop "GTK;System;Filesystems;Settings;HardwareSettings;"
update_app gsmartcontrol.desktop "GTK;System;Filesystems;Settings;HardwareSettings;"
update_app nautilus.desktop "GNOME;GTK;Utility;Core;FileManager;"
update_app gnome-search-tool.desktop "GNOME;GTK;Utility;Core;FileManager;"
update_app gnome-tweak-tool.desktop "GNOME;GTK;DesktopSettings;X-GNOME-PersonalSettings;"
update_app yelp.desktop "GNOME;GTK;Core;Documentation;"
update_app rpmdrake.desktop "GNOME;GTK;PackageManager;"
update_app lxde-ctrl-center.desktop "Settings;X-LXDE-Settings;"
update_app gigolo.desktop "GTK;Filesystems;Network;"
update_app system-config-nfs.desktop "Filesystems;Network;"
update_app system-config-samba.desktop "GTK;Filesystems;Network;"
update_app mdvinput.desktop "GTK;Settings;HardwareSettings;"
update_app add2sudoers.desktop "Settings;System;X-MandrivaLinux-CrossDesktop;"
update_app rmfromsudoers.desktop "Settings;System;X-MandrivaLinux-CrossDesktop;"
update_app meld.desktop "GTK;TextTools;"
update_app mandriva-wireshark-root.desktop "GTK;Network;Capture;"
update_app mandriva-wireshark.desktop "GTK;Network;Capture;"
update_app etherape.desktop "GTK;Network;Capture;"
update_app gnome-nettool.desktop "GTK;Network;Monitor;"
update_app lxshortcut.desktop "GTK;X-LXDE-Settings;"
update_app drakxservices.desktop "Settings;System;X-MandrivaLinux-CrossDesktop;"
update_app XFdrake.desktop "GTK;Settings;HardwareSettings;"

update_app kde4/akonaditray.desktop "Qt;KDE;X-KDE-Utilities-PIM;"
update_app kde4/dolphin.desktop "Qt;KDE;System;Utility;Core;FileManager;"
update_app kde4/filelight.desktop "Qt;KDE;Utility;X-MandrivaLinux-System-FileTools;"
update_app kde4/kcalc.desktop "Qt;KDE;Calculator;"
update_app kde4/KCharSelect.desktop "Qt;KDE;Utility;TextEditor;"
update_app kde4/kcolorchooser.desktop "Qt;KDE;Graphics;Scanning;"
update_app kde4/kdf.desktop "Qt;KDE;System;X-KDE-settings-peripherals;"
update_app kde4/kleopatra.desktop "Qt;KDE;Utility;Security;"
update_app kde4/krandrtray.desktop "Qt;KDE;System;HardwareSettings;"
update_app kde4/krename.desktop "Qt;KDE;Utility;FileManager;"
update_app kde4/krusader_root-mode.desktop "Qt;KDE;FileManager;"
update_app kde4/ksnapshot.desktop "Qt;KDE;Graphics;Scanning;"
update_app kde4/ksysguard.desktop "Qt;KDE;System;Monitor;"
update_app kde4/ktimer.desktop "Qt;KDE;X-KDE-Utilities-PIM;"
update_app kde4/kwikdisk.desktop "Qt;KDE;X-KDE-settings-peripherals;"
update_app kde4/sweeper.desktop "Qt;KDE;Utility;Security;"
update_app kde4/okular.desktop "Qt;KDE;Office;Viewer;"
update_app kde4/knotes.desktop "Qt;KDE;Utility;TextTools;"
update_app kde4/Kjots.desktop "Qt;KDE;Utility;TextTools;"
update_app kde4/irkick.desktop "Qt;KDE;X-KDE-settings-peripherals;"
update_app kde4/KFloppy.desktop "Qt;KDE;X-KDE-settings-peripherals;"
update_app kde4/bluedevil-monolithic.desktop "Qt;KDE;X-Bluetooth;X-KDE-settings-peripherals;"
update_app kde4/kruler.desktop "Qt;KDE;Graphics;Scanning;"
update_app kde4/kgpg.desktop "Qt;KDE;Utility;Security;"
update_app kde4/nepomukcleaner.desktop "Qt;KDE;X-KDE-Utilities-Desktop;"

PFP=usr/share/applications/mdvinput.desktop
[ -f $PFP ] && sed -i /"Categories=Application;Settings"/d $PFP
PFP=usr/share/applications/gnomecc.desktop
[ -f $PFP ] && sed -i /NoDisplay=true/d $PFP
PFP=usr/share/applications/gnome-system-monitor.desktop
[ -f $PFP ] && sed -i s/'Name.ru.=.*'/'Name[ru]=Системный монитор GNOME'/ $PFP
PFP=usr/share/applications/gpilotd-control-applet.desktop
[ -f $PFP ] && sed -i s/'Name.sk.='/'Name[ru]=Устройства на базе PalmOS'\\n'Name[sk]='/ $PFP
PFP=usr/share/applications/gconf-editor.desktop
[ -f $PFP ] && sed -i s/'Name.ru.=.*'/'Name[ru]=Правка настроек GConf'/ $PFP
PFP=usr/share/applications/pcmanfm.desktop
[ -f $PFP ] && sed -i s/'Name.ru.=.*'/'Name[ru]=Файловый менеджер Pcmanfm'/ $PFP
PFP=var/lib/mandriva/kde4-profiles/common/share/config/kickoffrc
if [ -f $PFP ] ;then
   sed -i 's|,/usr/share/applications/kde4/Kontact.desktop||' $PFP
   sed -i 's|,/usr/share/applications/clementine.desktop||'   $PFP
   sed -i 's|,/usr/share/applications/kde4/kopete.desktop||'  $PFP
   sed -i 's|/usr/share/applications/mandriva-drakconf.desktop,||' $PFP
fi
PFP=usr/share/applications/kde4/ksysguard.desktop
[ -f $PFP ] && sed -i s/'Name.ru.=.*'/'Name[ru]=Системный монитор KDE'/ $PFP
PFP=usr/share/applications/mandriva-avidemux-gtk.desktop
[ -f $PFP ] && grep -q GenericName.ru.= $PFP || echo "GenericName[ru]=Редактор видео файлов" >> $PFP
PFP=usr/share/applications/mandriva-grip.desktop
[ -f $PFP ] && grep -q GenericName.ru.= $PFP || echo "GenericName[ru]=Преобразование аудио дисков" >> $PFP
PFP=usr/share/applications/PlayOnLinux.desktop
[ -f $PFP ] && sed -i s/GenericName=.*/GenericName=PlayOnLinux/ $PFP
PFP=usr/share/applications/fusion-icon.desktop
[ -f $PFP ] && sed -i s/^Exec=.*/'Exec=fusion-icon -n'/ $PFP
PFP=usr/share/applications/gparted.desktop
[ -f $PFP ] && sed -i s/^Exec=.*/'Exec=gksu -lg gparted'/ $PFP
[ -f $PFP ] && sed -i s/'Name.ru.=.*'/'Name[ru]=GParted - управление разделами'/ $PFP
[ -f $PFP ] && sed -i s/'Comment.ru.=.*'/'Comment[ru]=GParted - управление разделами'/ $PFP
PFP=etc/xdg/autostart/blueman.desktop
[ -f $PFP ] && grep -q OnlyShowIn $PFP || echo "OnlyShowIn=LXDE;" >> $PFP

exit 0
