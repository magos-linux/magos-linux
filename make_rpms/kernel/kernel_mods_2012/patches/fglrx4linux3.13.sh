#!/bin/bash
CPATH=$PWD
cd usr/src/fglrx-*
patch -p1 <<EOF
--- a/kcl_acpi.c	2014-02-13 14:35:03.033044372 +0700
+++ b/kcl_acpi.c	2014-02-13 14:24:05.927024791 +0700
@@ -792,7 +792,9 @@
 unsigned int ATI_API_CALL KCL_ACPI_GetHandles(kcl_match_info_t *pInfo)
 {
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,12)
-    #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,8,0)
+    #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,13,0)
+        pInfo->video_handle = pInfo->pcidev->dev.acpi_node.companion;
+    #elif LINUX_VERSION_CODE >= KERNEL_VERSION(3,8,0)
         pInfo->video_handle = pInfo->pcidev->dev.acpi_node.handle;
     #elif LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19)
         pInfo->video_handle = pInfo->pcidev->dev.archdata.acpi_handle;
EOF
cd $CPATH
