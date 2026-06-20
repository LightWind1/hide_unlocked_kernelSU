#!/system/bin/sh

# Use -n in post-fs-data; KernelSU warns that setprop can block this stage.
resetprop -n ro.build.tags release-keys
resetprop -n ro.build.type user
resetprop -n ro.debuggable 0
resetprop -n ro.secure 1

resetprop -n ro.boot.flash.locked 1
resetprop -n ro.boot.vbmeta.device_state locked
resetprop -n ro.boot.verifiedbootstate green
resetprop -n ro.boot.veritymode enforcing
resetprop -n ro.boot.verifiedmode enforcing
resetprop -n vendor.boot.vbmeta.device_state locked
resetprop -n vendor.boot.verifiedbootstate green
resetprop -n vendor.boot.veritymode enforcing

resetprop -n sys.oem_unlock_allowed 0
resetprop -n ro.oem_unlock_supported 1

resetprop -n ro.boot.warranty_bit 0
resetprop -n ro.vendor.boot.warranty_bit 0
resetprop -n ro.vendor.warranty_bit 0
resetprop -n ro.warranty_bit 0

resetprop -n ro.secureboot.devicelock 1
resetprop -n ro.secureboot.lockstate locked
resetprop -n ro.bootmode unknown
resetprop -n ro.boot.mode unknown
resetprop -n vendor.boot.mode unknown
