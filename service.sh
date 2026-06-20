#!/system/bin/sh

# Some ROM/vendor services rewrite a few props after post-fs-data.
sleep 10

resetprop ro.build.tags release-keys
resetprop ro.build.type user
resetprop ro.debuggable 0
resetprop ro.secure 1

resetprop ro.boot.flash.locked 1
resetprop ro.boot.vbmeta.device_state locked
resetprop ro.boot.verifiedbootstate green
resetprop ro.boot.veritymode enforcing
resetprop ro.boot.verifiedmode enforcing
resetprop vendor.boot.vbmeta.device_state locked
resetprop vendor.boot.verifiedbootstate green
resetprop vendor.boot.veritymode enforcing

resetprop sys.oem_unlock_allowed 0
resetprop ro.oem_unlock_supported 1

resetprop ro.boot.warranty_bit 0
resetprop ro.vendor.boot.warranty_bit 0
resetprop ro.vendor.warranty_bit 0
resetprop ro.warranty_bit 0

resetprop ro.secureboot.devicelock 1
resetprop ro.secureboot.lockstate locked
resetprop ro.bootmode unknown
resetprop ro.boot.mode unknown
resetprop vendor.boot.mode unknown
