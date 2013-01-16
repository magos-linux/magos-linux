#!/bin/bash

TESTTARGET=bash
#TESTTARGET=sh

if [ -w /root ] ;then
   echo "Don't run this script under root!"
   exit 1
fi

mkdir -p bin
if [ ! -x bin/busybox ] ;then
   echo copying /bin/busybox.static
   cp -pf /bin/busybox.static bin/busybox || exit 1
else
   echo working with existing bin/busybox
fi

# build links to busybox's functions from busybox's own help text
for i in $(bin/busybox --help | grep -v Copyright | grep , | tr , " "); do
    ln -sf busybox bin/$i 2>/dev/null
done

# make some files needed tests
echo 'TEST=$(echo TEST)' >./test_busybox_sub1
echo -e 'TEST=test\nexit 1' >./test_busybox_sub2

function make_tests()
{
 echo -e "\n$1"
 echo "----- Test 1        ------"
 $TESTTARGET -c ". ./test_busybox_sub1"
 echo "----- End of test 1 ------"

 echo "----- Test 2        ------"
 $TESTTARGET -c '[ $(echo test) ]'
 echo "----- End of test 2 ------"

 echo "----- Test 3        ------"
 $TESTTARGET -c 'echo -n `echo -n ""`'
 echo "----- End of test 3 ------"

 echo "----- Test 4        ------"
 $TESTTARGET -c 'TEST=$(echo test)'
 echo "----- End of test 4 ------"

 echo "----- Test 5        ------"
 $TESTTARGET -c 'echo test >/root/test_busybox 2>/dev/null' 2>/dev/null
 echo "----- End of test 5 ------"

 echo "----- Test 6        ------"
 $TESTTARGET './test_busybox_sub2'
 echo "----- End of test 6 ------"

}

make_tests "Tests working with the system utilities /bin/*"
PATH=$PWD/bin
make_tests "Tests working with bin/busybox"


