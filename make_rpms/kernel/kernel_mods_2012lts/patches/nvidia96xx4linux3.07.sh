#!/bin/bash
CPATH=$PWD
cd /usr/src/nvidia96xx-*
patch -p1 <<EOF
diff -auprN a/conftest.sh b/conftest.sh
--- a/conftest.sh	2013-06-23 12:23:42.000000000 +0400
+++ b/conftest.sh	2013-06-23 18:27:54.198246174 +0400
@@ -128,6 +128,7 @@ build_cflags() {
         if [ "\$ARCH" = "i386" -o "\$ARCH" = "x86_64" ]; then
             MACH_CFLAGS="\$MACH_CFLAGS -I\$HEADERS/asm-x86/mach-default"
             MACH_CFLAGS="\$MACH_CFLAGS -I\$SOURCES/arch/x86/include/asm/mach-default"
+            MACH_CFLAGS="\$MACH_CFLAGS -I\$HEADERS/arch/x86/include/uapi"
         fi
         if [ "\$XEN_PRESENT" != "0" ]; then
             MACH_CFLAGS="-I\$HEADERS/asm-\$ARCH/mach-xen \$MACH_CFLAGS"
@@ -137,6 +138,7 @@ build_cflags() {
         if [ "\$ARCH" = "i386" -o "\$ARCH" = "x86_64" ]; then
             MACH_CFLAGS="\$MACH_CFLAGS -I\$HEADERS/asm-x86/mach-default"
             MACH_CFLAGS="\$MACH_CFLAGS -I\$SOURCES/arch/x86/include/asm/mach-default"
+            MACH_CFLAGS="\$MACH_CFLAGS -I\$HEADERS/arch/x86/include/uapi"
         fi
         if [ "\$XEN_PRESENT" != "0" ]; then
             MACH_CFLAGS="-I\$HEADERS/asm/mach-xen \$MACH_CFLAGS"
@@ -144,9 +146,12 @@ build_cflags() {
     fi
 
     CFLAGS="\$BASE_CFLAGS \$MACH_CFLAGS \$OUTPUT_CFLAGS -I\$HEADERS \$AUTOCONF_CFLAGS"
+    CFLAGS="\$CFLAGS -I\$HEADERS -I\$HEADERS/uapi"
 
     if [ "\$ARCH" = "i386" -o "\$ARCH" = "x86_64" ]; then
-        CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include -I\$OUTPUT/arch/x86/include/generated"
+        CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include -I\$SOURCES/arch/x86/include/uapi"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated/uapi"
     fi
     if [ -n "\$BUILD_PARAMS" ]; then
         CFLAGS="\$CFLAGS -D\$BUILD_PARAMS"
@@ -1457,10 +1462,12 @@ case "\$5" in
                 # kernel older than 2.6.6, that's all we require to
                 # build the module.
                 #
+                VERSION=\$(grep "^VERSION =" \$MAKEFILE | cut -d " " -f 3)
                 PATCHLEVEL=\$(grep "^PATCHLEVEL =" \$MAKEFILE | cut -d " " -f 3)
                 SUBLEVEL=\$(grep "^SUBLEVEL =" \$MAKEFILE | cut -d " " -f 3)
 
-                if [ -n "\$PATCHLEVEL" -a \$PATCHLEVEL -ge 6 \\
+                if [ -n "\$VERSION" -a \$VERSION -ge 3 ] || \\
+                   [ -n "\$PATCHLEVEL" -a \$PATCHLEVEL -ge 6 \\
                         -a -n "\$SUBLEVEL" -a \$SUBLEVEL -le 5 ]; then
                     SELECTED_MAKEFILE=Makefile.kbuild
                     RET=0
diff -auprN a/nv.c b/nv.c
--- a/nv.c	2013-06-23 12:23:42.000000000 +0400
+++ b/nv.c	2013-06-23 18:28:01.942246362 +0400
@@ -2350,7 +2350,11 @@ int nv_kern_mmap(
 
         /* prevent the swapper from swapping it out */
         /* mark the memory i/o so the buffers aren't dumped on core dumps */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0)
+        vma->vm_flags |= (VM_IO | VM_LOCKED | (VM_DONTEXPAND | VM_DONTDUMP));
+#else
         vma->vm_flags |= (VM_IO | VM_LOCKED | VM_RESERVED);
+#endif
     }
 
     NV_VMA_FILE(vma) = file;
diff -auprN a/nv.h b/nv.h
--- a/nv.h	2013-06-23 12:23:42.000000000 +0400
+++ b/nv.h	2013-06-23 18:28:37.704247231 +0400
@@ -547,3 +547,6 @@ static inline int nv_count_bits(NvU64 wo
 }
 
 #endif
+#ifndef VM_RESERVED
+#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
+#endif
EOF
cd $CPATH
