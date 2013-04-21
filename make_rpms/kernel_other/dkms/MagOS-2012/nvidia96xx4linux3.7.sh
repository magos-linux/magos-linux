#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia96xx-*
patch -p1 <<EOF
--- a/conftest.sh	2013-03-23 08:57:09.000000000 +0400
+++ b/conftest.sh	2013-03-23 09:49:15.000000000 +0400
@@ -124,6 +124,9 @@ build_cflags() {
 
     if [ "\$ARCH" = "i386" -o "\$ARCH" = "x86_64" ]; then
         CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include"
+        CFLAGS="\$CFLAGS -I\$SOURCES/include/uapi"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated/uapi"
     fi
     if [ -n "\$BUILD_PARAMS" ]; then
         CFLAGS="\$CFLAGS -D\$BUILD_PARAMS"
EOF
patch -p1 <<EOF
--- a/nv.h	2013-03-23 08:57:09.000000000 +0400
+++ b/nv.h	2013-03-23 09:49:36.000000000 +0400
@@ -547,3 +547,6 @@ static inline int nv_count_bits(NvU64 wo
 }
 
 #endif
+#ifndef VM_RESERVED
+#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
+#endif
\ В конце файла нет новой строки
EOF
cd $CPATH
