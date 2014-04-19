#!/bin/bash
CPATH=$PWD
cd /usr/src/nvidia-current-*
patch -p1 <<EOF
diff -aupr a/nv-linux.h b/nv-linux.h
--- a/nv-linux.h	2013-12-13 18:44:40.167472059 +0400
+++ b/nv-linux.h	2013-12-13 18:42:02.078472228 +0400
@@ -958,7 +958,11 @@ static inline int nv_execute_on_all_cpus
 #endif
 
 #if !defined(NV_VMWARE)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 11, 0)
+#define NV_NUM_PHYSPAGES                get_num_physpages()
+#else
 #define NV_NUM_PHYSPAGES                num_physpages
+#endif
 #define NV_GET_CURRENT_PROCESS()        current->tgid
 #define NV_IN_ATOMIC()                  in_atomic()
 #define NV_LOCAL_BH_DISABLE()           local_bh_disable()
EOF
cd $CPATH
