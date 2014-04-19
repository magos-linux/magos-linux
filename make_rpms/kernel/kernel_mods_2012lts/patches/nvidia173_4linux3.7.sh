#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia173-*
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
