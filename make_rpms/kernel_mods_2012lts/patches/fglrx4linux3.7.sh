#!/bin/bash
CPATH=$PWD
cd /usr/src/fglrx-*
patch -p1 <<EOF
--- a/firegl_public.c	2013-03-23 08:58:43.000000000 +0400
+++ b/firegl_public.c	2013-03-23 09:05:08.000000000 +0400
@@ -191,6 +191,10 @@
 #include <asm/fpu-internal.h>
 #endif
 
+#ifndef VM_RESERVED
+#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
+#endif
+
 #include "firegl_public.h"
 #include "kcl_osconfig.h"
 #include "kcl_io.h"
EOF
cd $CPATH
