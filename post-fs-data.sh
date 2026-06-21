#!/system/bin/sh

# Use -n in post-fs-data; KernelSU warns that setprop can block this stage.
check_reset_prop() {
  local name="$1"
  local expected="$2"
  local value
  value="$(resetprop "$name")"
  [ -z "$value" ] || [ "$value" = "$expected" ] || resetprop -n "$name" "$expected"
}

check_reset_prop ro.build.tags release-keys
check_reset_prop ro.build.type user
check_reset_prop ro.debuggable 0
check_reset_prop ro.force.debuggable 0
check_reset_prop ro.secure 1
check_reset_prop ro.adb.secure 1

check_reset_prop ro.boot.flash.locked 1
check_reset_prop ro.boot.vbmeta.device_state locked
check_reset_prop ro.boot.verifiedbootstate green
check_reset_prop ro.boot.veritymode enforcing
check_reset_prop ro.boot.verifiedmode enforcing
check_reset_prop vendor.boot.vbmeta.device_state locked
check_reset_prop vendor.boot.verifiedbootstate green
check_reset_prop vendor.boot.veritymode enforcing

check_reset_prop sys.oem_unlock_allowed 0
check_reset_prop ro.oem_unlock_supported 1

check_reset_prop ro.boot.warranty_bit 0
check_reset_prop ro.vendor.boot.warranty_bit 0
check_reset_prop ro.vendor.warranty_bit 0
check_reset_prop ro.warranty_bit 0

check_reset_prop ro.secureboot.devicelock 1
check_reset_prop ro.secureboot.lockstate locked
check_reset_prop ro.boot.realmebootstate green
check_reset_prop ro.boot.realme.lockstate 1

check_reset_prop ro.bootmode unknown
check_reset_prop ro.boot.bootmode unknown
check_reset_prop ro.boot.mode unknown
check_reset_prop vendor.boot.bootmode unknown
check_reset_prop vendor.boot.mode unknown
