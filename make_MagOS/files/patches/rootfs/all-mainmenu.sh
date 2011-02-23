#!/bin/bash
function update_app
{
 sed -i "s/^.*Categories=.*$/Categories=$2/" usr/share/applications/$1
}

update_app cheese.desktop "GNOME;AudioVideo;Recorder;"
update_app devede.desktop "AudioVideo;DiscBurning;"
update_app gnomecc.desktop "GNOME;GTK;Settings;X-MandrivaLinux-System-Configuration-GNOME;"
update_app gnome-ppp.desktop "Network;GNOME;Dialup;"
update_app gnome-screenshot.desktop "GTK;GNOME;Utility;Graphics;Scanning;"
update_app gnome-system-monitor.desktop "GNOME;GTK;System;Monitor;"
update_app gxneur.desktop "GTK;GNOME;Application;Utility;Office;"
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

update_app kde4/akonaditray.desktop "Qt;KDE;X-KDE-Utilities-PIM;"
update_app kde4/dolphin.desktop "Qt;KDE;System;Utility;Core;FileManager;"
update_app kde4/filelight.desktop "Qt;KDE;Utility;X-MandrivaLinux-System-FileTools;"
update_app kde4/kcalc.desktop "Qt;KDE;Utility;X-KDE-Utilities-Desktop;Calculator;"
update_app kde4/KCharSelect.desktop "Qt;KDE;Utility;"
update_app kde4/kcolorchooser.desktop "Qt;KDE;Graphics;X-KDE-More;Scanning;"
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

sed -i /NoDisplay=true/d usr/share/applications/gnomecc.desktop

exit 0
