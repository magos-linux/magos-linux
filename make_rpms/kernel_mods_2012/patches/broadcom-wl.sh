#!/bin/bash
CPATH=$PWD
cd usr/src/broadcom-wl-*
patch -p1 <<EOF
diff -auprN a/src/wl/sys/wl_cfg80211.c b/src/wl/sys/wl_cfg80211.c
--- a/src/wl/sys/wl_cfg80211.c	2013-05-23 14:05:14.000000000 +0400
+++ b/src/wl/sys/wl_cfg80211.c	2013-06-21 21:11:50.000000000 +0400
@@ -2142,9 +2142,12 @@ static s32 wl_update_bss_info(struct wl_
 		ie_len = (size_t)(ies->len);
 #endif
 		beacon_interval = bss->beacon_interval;
-		cfg80211_put_bss(bss);
-	}
-
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 9, 0)
+ 		cfg80211_put_bss(bss);
+#else
+		cfg80211_put_bss(wl_to_wiphy(wl), bss);
+#endif
+ 	}
 	tim = bcm_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
 	if (tim) {
 		dtim_period = tim->data[1];

EOF