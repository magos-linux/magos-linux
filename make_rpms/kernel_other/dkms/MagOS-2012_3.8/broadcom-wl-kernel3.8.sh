#!/bin/bash
CPATH=$PWD
cd usr/src/broadcom-wl-*
patch -p1 <<EOF
diff -auprN a/src/include/bcmutils.h b/src/include/bcmutils.h
--- a/src/include/bcmutils.h	2013-04-17 20:52:48.000000000 +0400
+++ b/src/include/bcmutils.h	2013-04-17 21:04:41.000000000 +0400
@@ -555,7 +555,11 @@ extern void printbig(char *buf);
 extern void prhex(const char *msg, uchar *buf, uint len);
 
 extern bcm_tlv_t *BCMROMFN(bcm_next_tlv)(bcm_tlv_t *elt, int *buflen);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
 extern bcm_tlv_t *BCMROMFN(bcm_parse_tlvs)(void *buf, int buflen, uint key);
+#else
+extern bcm_tlv_t *BCMROMFN(bcm_parse_tlvs)(const void *buf, int buflen, uint key);
+#endif
 extern bcm_tlv_t *BCMROMFN(bcm_parse_ordered_tlvs)(void *buf, int buflen, uint key);
 
 extern const char *bcmerrorstr(int bcmerror);
diff -auprN a/src/wl/sys/wl_cfg80211.c b/src/wl/sys/wl_cfg80211.c
--- a/src/wl/sys/wl_cfg80211.c	2013-04-17 20:52:48.000000000 +0400
+++ b/src/wl/sys/wl_cfg80211.c	2013-04-17 21:04:41.000000000 +0400
@@ -63,7 +63,11 @@ static int wl_cfg80211_connect(struct wi
            struct cfg80211_connect_params *sme);
 static s32 wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 36)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
+static s32 wl_cfg80211_set_tx_power(struct wiphy *wiphy,
+           struct wireless_dev *wdev,
+           enum nl80211_tx_power_setting type, s32 dbm);
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 36)
 static s32 wl_cfg80211_set_tx_power(struct wiphy *wiphy,
            enum nl80211_tx_power_setting type, s32 dbm);
 #else
@@ -71,7 +75,12 @@ static s32 wl_cfg80211_set_tx_power(stru
            enum tx_power_setting type, s32 dbm);
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
+static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy,
+           struct wireless_dev *wdev, s32 *dbm);
+#else
 static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm);
+#endif
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 38)
 static s32 wl_cfg80211_config_default_key(struct wiphy *wiphy,
@@ -769,7 +778,11 @@ wl_cfg80211_join_ibss(struct wiphy *wiph
 	else
 		memset(&join_params.params.bssid, 0, ETHER_ADDR_LEN);
 
-	wl_ch_to_chanspec(params->channel, &join_params, &join_params_size);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
+ 	wl_ch_to_chanspec(params->channel, &join_params, &join_params_size);
+#else
+	wl_ch_to_chanspec(params->chandef.chan, &join_params, &join_params_size);
+#endif
 
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
 	if (err) {
@@ -1126,7 +1139,12 @@ wl_cfg80211_disconnect(struct wiphy *wip
 	return err;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 36)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
+static s32
+wl_cfg80211_set_tx_power(struct wiphy *wiphy,
+            struct wireless_dev *wdev,
+            enum nl80211_tx_power_setting type, s32 dbm)
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 36)
 static s32
 wl_cfg80211_set_tx_power(struct wiphy *wiphy, enum nl80211_tx_power_setting type, s32 dbm)
 #else
@@ -1185,7 +1203,12 @@ wl_cfg80211_set_tx_power(struct wiphy *w
 	return err;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
+static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy,
+            struct wireless_dev *wdev, s32 *dbm)
+#else
 static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
+#endif
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -2072,9 +2095,14 @@ static s32 wl_update_bss_info(struct wl_
 	struct bcm_tlv *tim;
 	u16 beacon_interval;
 	s32 dtim_period;
-	size_t ie_len;
-	u8 *ie;
 	s32 err = 0;
+ 	size_t ie_len;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
+ 	u8 *ie;
+#else
+	const u8 *ie;
+	const struct cfg80211_bss_ies *ies;
+#endif
 
 	ssid = &wl->profile->ssid;
 	bss = cfg80211_get_bss(wl_to_wiphy(wl), NULL, (s8 *)&wl->bssid,
@@ -2104,8 +2132,19 @@ static s32 wl_update_bss_info(struct wl_
 		beacon_interval = cpu_to_le16(bi->beacon_period);
 	} else {
 		WL_DBG(("Found the AP in the list - BSSID %pM\n", bss->bssid));
-		ie = bss->information_elements;
-		ie_len = bss->len_information_elements;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
+ 		ie = bss->information_elements;
+ 		ie_len = bss->len_information_elements;
+#else
+		ies = (const struct cfg80211_bss_ies*)rcu_dereference(bss->ies);
+		if (!ies) {
+			/* This should never happen */
+			err = -EIO;
+			goto update_bss_info_out;
+		}
+		ie = ies->data;
+		ie_len = (size_t)(ies->len);
+#endif
 		beacon_interval = bss->beacon_interval;
 		cfg80211_put_bss(bss);
 	}
EOF