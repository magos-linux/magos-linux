#!/bin/bash
CPATH=$PWD
cd /usr/src/nvidia173-*
patch -p1 <<EOF
diff -aupr a/os-interface.c b/os-interface.c
--- a/os-interface.c	2013-11-08 18:18:02.000000000 +0400
+++ b/os-interface.c	2013-12-13 18:52:05.000000000 +0400
@@ -292,7 +292,11 @@ NvU64 NV_API_CALL os_get_page_mask(void)
 
 NvU64 NV_API_CALL os_get_system_memory_size(void)
 {
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3, 11, 0))
     return ((NvU64) num_physpages * PAGE_SIZE) / RM_PAGE_SIZE;
+#else
+    return ((NvU64) totalram_pages * PAGE_SIZE) / RM_PAGE_SIZE;
+#endif
 }
 
 //
EOF
cd $CPATH
