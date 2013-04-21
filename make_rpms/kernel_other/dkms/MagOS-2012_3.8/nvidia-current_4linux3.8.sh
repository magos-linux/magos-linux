#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia-current-*
patch -p1 <<EOF
cd $CPATH
diff -auprN a/conftest.sh b/conftest.sh
--- a/conftest.sh	2013-04-17 18:15:18.000000000 +0400
+++ b/conftest.sh	2013-04-17 18:25:01.000000000 +0400
@@ -162,6 +162,7 @@ build_cflags() {
         CFLAGS="\$CFLAGS -I\$SOURCES/arch/x86/include"
         CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated"
         CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/generated/uapi"
+        CFLAGS="\$CFLAGS -I\$OUTPUT/arch/x86/include/uapi"
     elif [ "\$ARCH" = "arm" ]; then
         CFLAGS="\$CFLAGS -I\$SOURCES/arch/arm/include"
         CFLAGS="\$CFLAGS -I\$OUTPUT/arch/arm/include/generated"
EOF
