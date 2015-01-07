### Базовое описание основных принципов

Поддерживаемые расширения в MagOS Linux по умолчанию:

    *.ROM - RO слой
    *.RWM - RW слой
    *.XZM - RO слой с squashfs 

    *.RWM.ENC - RW слой криптованый
    *.ROM.ENC - RO слой криптованый

Ввиду множественности параметров ядра введен префикс параметров '**uird**'  (Unified Init Ram Disk): 

    uird.basecfg=
    uird.config=
    ??? uird.sgnfile=
    uird.ro=
    uird.rw=
    uird.copy2ram=
    uird.copy2cache=
    uird.ramsize=
    uird.ip=
    uird.netfsopt=
    uird.load=
    uird.noload=
    uird.from=
    uird.changes=
    uird.cache=
    uird.machines=
    uird.home=

Вводится уровень кеша layer-cache и соответствующий параметр uird.cache=. Служит для синхронизации удаленных репозиториев в локальные или частные (INTRANET) репозитории, а также для обновления системы.

    uird.cache=/MagOS/cache;/MagOS-Data/cache;/MagOS-Data/netlive

Вводится базовый уровень layer-base и параметр uird.from=:

    uird.from=/MagOS;/MagOS-Data;MagOS.iso;http://magos.sibsau.ru/repository/netlive/2014.64/MagOS;ftp://server/path/



### Типы источников

*     **/path/dir**   - директория на любом доступном носителе
*     **/dev/[..]/path/dir**   - директория на заданном носителе
*     **file-dvd.iso, file.img**   - образ диска (ISO, образ блочного устройства)
*     **http://server/path/...**   - источник доступный по HTTP (используется httpfs) 
*     **ssh://server/path/...**   - источник доступный по SSH (используется sshfs)
*     **ftp://server/path/...**   - источник доступный по FTP (используется curlftpfs)
*     **nfs://server/path/...**   - источник доступный по NFS 

### Порядок инициализации системы

1. Осуществляется поиск конфигурационного файла по пути, указанному в параметре uird.basecfg=
2. Устанавливаются параметры из конфигурационного файла, которые еще не установлены в параметрах ядра
3. Происходит монтирование источников **base**-уровня в порядке, указанном в параметре uird.from= 
4. Происходит монтирование источников **cache**-уровня в порядке, указанном в параметре uird.cache= 
5. Происходит подключение в самый _верхний_ уровень AUFS источника, указанного в параметре uird.changes=
6. Осуществляется синхронизация base-уровня в cache-уровень с учетом параметра uird.copy2cache=
7. Осуществляется синхронизация base,cache-уровней в RAM с учетом параметра uird.copy2ram=
8. Осуществляется поиск модулей в base-уровне и подключение их на _[верхний-1]_ уровень AUFS с учетом фильтров, указанных в параметрах uird.load=, uird.ro=,uird.rw=, а также модулей в cache-уровне и RAM.
9. ...

### Структура конфигурационного файла по умолчанию

    ????? [/path/basecfg.ini]
    uird.config=MagOS.ini
    uird.ramsize=70%
    uird.ro=*.xzm;*.rom;*.rom.enc;*.pfs
    uird.rw=*.rwm;*.rwm.enc
    uird.load=*
    uird.noload=/optional/;/machines/;/cache/
    uird.from=/MagOS;/MagOS-Data
    uird.changes=/MagOS-Data/changes
    uird.cache=/MagOS-Data/cache
    uird.machines=/MagOS-Data/machines
    uird.home=/MagOS-Data/homes
    
!!!Если параметр uird.basecfg= не задан, то используется /basecfg.ini внутри initrd.

### Структура системной директории 

      /memory/
      ├── bundles                   - точка монтирования модулей
      │   ├── 00-kernel.xzm
      │   ├── 01-firmware.xzm
      │   ├── 10-core.xzm
      │   ├── 80-eepm-1.5.2.xzm
      │   └── ...
      ├── changes                   - точка монтирования для хранения изменений 
      │   ├── etc
      │   ├── home
      │   ├── memory
      │   ├── run
      │   ├── var
      │   └── ...
      ├── data                      - точка монтирования источников
      │   ├── cache                    - кеш уровня
      │   └── from                     - базового уровня
      ├── layer-base                - точка монтирования базового уровня
      │   ├── 0                        - ресурс первого источника
      │   ├── 1                        - ресурс второго источника (в порядке перечисления в uird.from=)
      │   └── ...
      ├── layer-cache               - точка монтирования кеш уровня
      │   ├── 0                        - ресус первого источника
      │   ├── 1                        - ресурс второго источника (в порядке перечисления в uird.cache=)
      │   └── ...
      ├── cmdline                   - системный файл для хранения дополнительных параметров командной строки
      └── MagOS.ini.gz              - системный файл для хранения конфигурационного файла


### Реализация

В основе реализации лежит набор скриптов инициализации dracut (модули base , busybox ) и скрипты uird (livekitlib+uird-init).

    cmdline-hook: parse-root-uird.sh (проверяет параметр root=uird:)
    mount-hook: mount-uird.sh (выполняет скрипт uird-init)

* [livekitlib](https://github.com/magos-linux/magos-linux/blob/master/make_initrd/modules.d/97uird/livekit/livekitlib) - содержит библиотеку функций системы инициализации.
* [uird-init](https://github.com/magos-linux/magos-linux/blob/master/make_initrd/modules.d/97uird/livekit/uird-init) - последовательно выполняет набор функций из livekitlib и осуществляет каскадно-блочное монтирование модулей системы в единый корень AUFS в директорию указанную в переменной dracut $NEWROOT.
