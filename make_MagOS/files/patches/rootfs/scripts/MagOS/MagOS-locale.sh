#!/bin/bash
rm -fr etc/locale  2>/dev/null
ln -sf /usr/share/locale etc/locale
grep -q MagOS usr/bin/locale_install.sh && exit 0
grep -q /usr/share/i18n/SUPPORTED usr/bin/locale_install.sh && exit 0
rm -fr usr/share/locale/locale-archive 2>/dev/null
cp -p usr/bin/locale_install.sh usr/bin/locale_install.sh.deprecated
cp -p usr/bin/locale_uninstall.sh usr/bin/locale_uninstall.sh.deprecated
cat >usr/bin/locale_install.sh <<EOF
#!/bin/bash
# deprecated in MagOS-Linux
exit 0
EOF
cat >usr/bin/locale_uninstall.sh <<EOF
#!/bin/bash
# deprecated in MagOS-Linux
exit 0
EOF
exit 0
