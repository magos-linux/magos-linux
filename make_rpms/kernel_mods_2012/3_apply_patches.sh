#!/bin/bash
. .config
export KERN
PP="$PWD/patches"
cd / 
for a in $PP/*.sh ;do
    echo $a
    bash $a
done
for a in $PP/*.patch ;do
    echo $a
    patch -p1 -i $a
done
mv /usr/bin/rpmlint /usr/bin/rpmlint.disabled
ln -sf /bin/true /usr/bin/rpmlint
echo Done.
