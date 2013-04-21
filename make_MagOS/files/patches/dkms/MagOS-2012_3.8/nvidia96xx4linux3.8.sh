#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia96xx-*
cp -pf ../../../conftest4nvidia96 ./conftest.sh
cp -pf ../../../nv.c ./
patch -p1 <<EOF
diff -auprN a/nv.h b/nv.h
--- a/nv.h	2012-05-10 15:31:03.000000000 +0400
+++ b/nv.h	2013-04-17 21:49:58.000000000 +0400
@@ -477,7 +477,7 @@ BOOL       NV_API_CALL  rm_init_adapter
 BOOL       NV_API_CALL  rm_disable_adapter       (nv_state_t *);
 BOOL       NV_API_CALL  rm_shutdown_adapter      (nv_state_t *);
 void       NV_API_CALL  rm_set_interrupts        (BOOL);
-BOOL       NV_API_CALL  rm_ioctl                 (nv_state_t *, void *, U032, void *);
+RM_STATUS  NV_API_CALL  rm_ioctl                 (nv_state_t *, void *, U032, void *, U032);
 BOOL       NV_API_CALL  rm_isr                   (nv_state_t *, U032 *);
 void       NV_API_CALL  rm_isr_bh                (nv_state_t *);
 RM_STATUS  NV_API_CALL  rm_power_management      (nv_state_t *, U032, U032);
@@ -523,7 +523,7 @@ RM_STATUS  NV_API_CALL  rm_i2c_smbus_wri
 
 RM_STATUS  NV_API_CALL  rm_i2c_remove_adapters   (nv_state_t *);
 
-RM_STATUS  NV_API_CALL  rm_perform_version_check (nv_ioctl_rm_api_version_t * pParams);
+RM_STATUS  NV_API_CALL  rm_perform_version_check (void *, U032);
 
 #define rm_disable_interrupts() rm_set_interrupts(FALSE)
 #define rm_enable_interrupts()  rm_set_interrupts(TRUE)
@@ -547,3 +547,6 @@ static inline int nv_count_bits(NvU64 wo
 }
 
 #endif
+#ifndef VM_RESERVED
+#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
+#endif
\ В конце файла нет новой строки
diff -auprN a/nv-linux.h b/nv-linux.h
--- a/nv-linux.h	2012-05-10 15:31:03.000000000 +0400
+++ b/nv-linux.h	2012-09-01 02:04:44.000000000 +0400
@@ -91,7 +91,9 @@
 #include <linux/timer.h>
 
 #include <asm/div64.h>              /* do_div()                         */
+#if defined(NV_ASM_SYSTEM_H_PRESENT)
 #include <asm/system.h>             /* cli, sli, save_flags             */
+#endif
 #include <asm/io.h>                 /* ioremap, virt_to_phys            */
 #include <asm/uaccess.h>            /* access_ok                        */
 #include <asm/page.h>               /* PAGE_OFFSET                      */
EOF
cd $CPATH
