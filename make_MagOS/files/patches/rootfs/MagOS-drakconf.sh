#!/bin/bash
PFP=usr/share/locale/ru/LC_MESSAGES/drakconf
msgunfmt $PFP.mo -o drakconf.po
if ! grep -q XZM drakconf.po ;then
  cat >>drakconf.po <<EOF

msgid "Modules Management"
msgstr "Управление модулями"

msgid "Install Software & Create LZM/XZM module"
msgstr "Установить приложения & Создать модуль LZM/XZM"

msgid "Convert LZM/XZM modules"
msgstr "Конвертация модулей LZM/XZM"

msgid "Modules Manager"
msgstr "Менеджер модулей"

msgid "Configs Management"
msgstr "Управление конфигурациями"

msgid "Configs Manager"
msgstr "Менеджер конфигурационными файлами"

EOF
  msgfmt drakconf.po -o $PFP.mo 
fi
rm -f drakconf.po
exit 0
