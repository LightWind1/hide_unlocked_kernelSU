#!/system/bin/sh

ui_print "*******************************"
ui_print " Hide Locked for KernelSU"
ui_print " KernelSU / SukiSU Ultra module"
ui_print "*******************************"
ui_print "- This module masks property-only bootloader checks."
ui_print "- It does not bypass hardware attestation or bootloader splash warnings."

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
