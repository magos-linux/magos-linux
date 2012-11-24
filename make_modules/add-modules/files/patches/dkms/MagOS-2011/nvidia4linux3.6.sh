#!/bin/bash
CPATH=$PWD
cd usr/src/nvidia-current-*
patch -p1 <<EOF
diff -aup a/nv-acpi.c b/nv-acpi.c
--- a/nv-acpi.c	2012-05-10 15:43:32.000000000 +0400
+++ b/nv-acpi.c	2012-10-21 11:29:45.000000000 +0400
@@ -300,7 +300,11 @@ static int nv_acpi_remove(struct acpi_de
     if (pNvAcpiObject->notify_handler_installed)
     {
         // no status returned for this function
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+        acpi_os_wait_events_complete();
+#else
         acpi_os_wait_events_complete(NULL);
+#endif
 
         // remove event notifier
         status = acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY, nv_acpi_event);
EOF

cd $CPATH
cd usr/src/nvidia173-*
patch -p1 <<EOF
diff -aup a/nvacpi.c b/nvacpi.c
--- a/nvacpi.c	2012-10-21 11:21:25.000000000 +0400
+++ b/nvacpi.c	2012-10-21 11:36:19.531888542 +0400
@@ -260,7 +260,11 @@ static int nv_acpi_remove(struct acpi_de
     if (pNvAcpiObject->notify_handler_installed)
     {
         // no status returned for this function
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+        acpi_os_wait_events_complete();
+#else
         acpi_os_wait_events_complete(NULL);
+#endif
 
         // remove event notifier
         status = acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY, nv_acpi_event);
EOF
cd $CPATH
