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

update_app kde4/akonaditray.desktop "Qt;KDE;X-KDE-Utilities-PIM;"
update_app kde4/dolphin.desktop "Qt;KDE;System;Utility;Core;FileManager;"
update_app kde4/filelight.desktop "Qt;KDE;Utility;X-MandrivaLinux-System-FileTools;"
update_app kde4/kcalc.desktop "Qt;KDE;Calculator;"
update_app kde4/KCharSelect.desktop "Qt;KDE;Utility;"
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

sed -i /NoDisplay=true/d usr/share/applications/gnomecc.desktop
sed -i s/'Name.ru.=.*'/'Name[ru]=Системный монитор GNOME'/ usr/share/applications/gnome-system-monitor.desktop
sed -i s/'Name.ru.=.*'/'Name[ru]=Системный монитор KDE'/ usr/share/applications/kde4/ksysguard.desktop
sed -i s/'Name.sk.='/'Name[ru]=Устройства на базе PalmOS'\\n'Name[sk]='/ usr/share/applications/gpilotd-control-applet.desktop
sed -i s/'Name.ru.=.*'/'Name[ru]=Файловый менеджер Pcmanfm'/ usr/share/applications/pcmanfm.desktop
sed -i 's|,/usr/share/applications/kde4/Kontact.desktop||' var/lib/mandriva/kde4-profiles/common/share/config/kickoffrc
sed -i 's|,/usr/share/applications/clementine.desktop||'   var/lib/mandriva/kde4-profiles/common/share/config/kickoffrc
sed -i 's|,/usr/share/applications/kde4/kopete.desktop||'  var/lib/mandriva/kde4-profiles/common/share/config/kickoffrc
grep -q GenericName.ru.= usr/share/applications/mandriva-avidemux-gtk.desktop || echo "GenericName[ru]=Редактор видео файлов" >> usr/share/applications/mandriva-avidemux-gtk.desktop
grep -q GenericName.ru.= usr/share/applications/mandriva-grip.desktop || echo "GenericName[ru]=Преобразование аудио дисков" >> usr/share/applications/mandriva-grip.desktop
sed -i s/GenericName=.*/GenericName=PlayOnLinux/ usr/share/applications/PlayOnLinux.desktop
sed -i s/^Exec=.*/'Exec=fusion-icon -n'/ usr/share/applications/fusion-icon.desktop
sed -i s/^Exec=.*/'Exec=gksu -lg gparted'/ usr/share/applications/gparted.desktop
sed -i s/'Name.ru.=.*'/'Name[ru]=GParted - управление разделами'/ usr/share/applications/gparted.desktop
sed -i s/'Comment.ru.=.*'/'Comment[ru]=GParted - управление разделами'/ usr/share/applications/gparted.desktop
sed -i s/'Name.ru.=.*'/'Name[ru]=Правка настроек GConf'/ usr/share/applications/gconf-editor.desktop
grep -q OnlyShowIn etc/xdg/autostart/blueman.desktop || echo "OnlyShowIn=LXDE;" >> etc/xdg/autostart/blueman.desktop

exit 0
