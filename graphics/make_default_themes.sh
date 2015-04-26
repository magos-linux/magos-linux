#!/bin/bash
# this scripts makes default set of photo from several themes
TMPWF=/tmp/magos-walls-theme-$$
TMPSF=/tmp/magos-ssaver-theme-$$
#themes for wallpapers
WTHEMES="photos"
#themes for screensaver
SSTHEMES="animals flowers insects nature others scenary ships urban"
#quantity of photos for default theme
PHNUM=30
#min number of photos for each theme
PHMIN=2

### wallpapers
rm -f wallpapers/Default/*
# select min number of photos
for a in $WTHEMES ;do
    find -P wallpapers -type f | grep /$a/ | sort -R | head -n $PHMIN >> $TMPWF
done
echo -n >$TMPWF.2
# select other photos
for a in $WTHEMES ;do
    find -P wallpapers -type f | grep /$a/ | grep -vf $TMPWF >> $TMPWF.2
done
sort -R $TMPWF.2 >> $TMPWF
head -n $PHNUM $TMPWF | while read a ;do
    cp -p $a wallpapers/Default
done

### screensaver
rm -f screensaver/Default/*
ls wallpapers/Default/* | sed s%wallpapers/Default/%% >$TMPWF
echo -n >$TMPSF
# select min number of photos
for a in $SSTHEMES ;do
    find -P screensaver -type f | grep /$a/ | grep -vf $TMPWF | sort -R | head -n $PHMIN >> $TMPSF
done
echo -n >$TMPSF.2
# select other photos
for a in $SSTHEMES ;do
    find -P screensaver -type f | grep /$a/ | grep -vf $TMPWF | grep -vf $TMPSF >> $TMPSF.2
done
sort -R $TMPSF.2 >> $TMPSF
head -n $PHNUM $TMPSF | while read a ;do
    cp -p $a screensaver/Default
done
rm -f $TMPWF $TMPWF.2 $TMPSF $TMPSF.2
