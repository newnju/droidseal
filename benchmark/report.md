# DroidSeal 基准评测报告

- 来源：内置基准
- 用例数：30
- 合计：TP=15 FP=10 FN=2
- **精度 60.0% · 召回 88.2%**

| 用例 | TP | FP | FN |
|---|---|---|---|
| taint-credential-log | SOURCE_LOG_SENSITIVE | SOURCE_RECEIVER_ORDER_SENSITIVE | — |
| crypto-weak-des | SOURCE_DES_USE | SOURCE_ECB_CIPHER_USAGE | — |
| injection-sql | SOURCE_SQL_RAW_STRING | SOURCE_SQL_INJECTION_SRC | — |
| ssl-bypass-hostname | SOURCE_CERTIFICATE_HOSTNAME_OFF | — | — |
| storage-sdcard | — | SOURCE_SDCARD_WRITE | — |
| network-https-ok | — | — | — |
| crypto-gcm-ok | — | — | — |
| random-secure-ok | — | — | — |
| taint-query-uri-log | SOURCE_URI_LOGGED | — | — |
| crypto-md5 | SOURCE_MD5_USE | SOURCE_WEAK_HASH_FOR_SECURITY | — |
| crypto-sha256-ok | — | — | — |
| injection-ldap | — | — | SOURCE_LDAP_INJECTION |
| injection-command | SOURCE_RUNTIME_EXEC_DANGEROUS | — | — |
| storage-prefs-secret | — | SOURCE_RECEIVER_ORDER_SENSITIVE | SOURCE_PREFS_KEY_SENSITIVE |
| storage-internal-ok | — | SOURCE_INTERNAL_STORAGE_PLAINTEXT | — |
| network-ws-plain | SOURCE_PLAINTEXT_WEBSOCKET | — | — |
| network-wss-ok | — | — | — |
| permission-unknown-source | SOURCE_PERMISSION_INSTALL_UNKNOWN | — | — |
| permission-basic-ok | — | — | — |
| component-exported-auth | SOURCE_EXPORTED_ACTIVITY_NO_AUTH | — | — |
| component-exported-ok | — | — | — |
| ui-toast-secret | SOURCE_TOAST_SENSITIVE | SOURCE_RECEIVER_ORDER_SENSITIVE,SOURCE_LIFECYCLE_DIALOG_SENSITIVE | — |
| ui-title-ok | — | — | — |
| supplychain-jwt | SOURCE_JWT_HARDCODED | — | — |
| serialization-java | SOURCE_SERIALIZATION_JAVA | — | — |
| serialization-json-ok | — | — | — |
| webview-js-bridge | SOURCE_WEBVIEW_JS_BRIDGE_UNSAFE | — | — |
| webview-file-ok | — | — | — |
| backup-allowed | SOURCE_ADB_BACKUP_ALLOWED | SOURCE_BACKUP_RULE_ABSENT | — |
| backup-ok | — | — | — |
