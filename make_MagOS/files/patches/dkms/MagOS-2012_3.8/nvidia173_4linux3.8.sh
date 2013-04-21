#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia173-*
patch -p1 <<EOF
--- a/conftest.sh	2013-03-23 09:15:47.000000000 +0400
+++ b/conftest.sh	2013-03-23 09:31:34.000000000 +0400
@@ -145,7 +145,11 @@ build_cflags() {
     CFLAGS="\$BASE_CFLAGS \$MACH_CFLAGS \$OUTPUT_CFLAGS -I\$HEADERS \$AUTOCONF_CFLAGS"
 
     if [ "\$ARCH" = "i386" -o "\$ARCH" = "x86_64" ]; then
-        CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include -I\$OUTPUT/arch/x86/include/generated"
+        CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include"
+        CFLAGS="\$CFLAGS -I\$SOURCES/include/uapi"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated/uapi"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/uapi"
     fi
     if [ -n "\$BUILD_PARAMS" ]; then
         CFLAGS="\$CFLAGS -D\$BUILD_PARAMS"
EOF
patch -p1 <<EOF
--- a/nv.h	2013-03-23 08:57:08.000000000 +0400
+++ b/nv.h	2013-03-23 09:42:00.000000000 +0400
@@ -576,3 +576,6 @@ static inline int nv_count_bits(NvU64 wo
 }
 
 #endif
+#ifndef VM_RESERVED
+#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
+#endif
\ В конце файла нет новой строки
EOF
cd $CPATH
