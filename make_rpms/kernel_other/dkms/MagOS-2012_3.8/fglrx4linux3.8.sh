#!/bin/bash
CPATH=$PWD
cd usr/src/fglrx-*
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
diff -auprN a/kcl_acpi.c b/kcl_acpi.c
--- a/kcl_acpi.c	2013-04-17 20:52:48.000000000 +0400
+++ b/kcl_acpi.c	2013-04-17 22:06:29.000000000 +0400
@@ -775,7 +775,9 @@ static unsigned int KCL_ACPI_SearchHandl
 unsigned int ATI_API_CALL KCL_ACPI_GetHandles(kcl_match_info_t *pInfo)
 {
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,12)
-    #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19)
+    #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,8,0)
+	pInfo->video_handle = pInfo->pcidev->dev.acpi_node.handle;
+    #elif LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19)
         pInfo->video_handle = pInfo->pcidev->dev.archdata.acpi_handle;
     #else 
         pInfo->video_handle = pInfo->pcidev->dev.firmware_data;
EOF
cd $CPATH
