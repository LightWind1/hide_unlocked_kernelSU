# Hide Unlocked for KernelSU / SukiSU Ultra

This module masks common Android bootloader and verified-boot properties so
apps that only read Android system properties see a locked, green, user build.

It is intended for KernelSU and SukiSU Ultra. It does not modify the real
bootloader state, AVB state, hardware-backed attestation, or the early
bootloader warning screen.

## Android 15+ status

Android 15 and newer devices still expose lock and verified boot state through
boot properties such as:

- `ro.boot.flash.locked`
- `ro.boot.vbmeta.device_state`
- `ro.boot.verifiedbootstate`
- `ro.boot.veritymode`

KernelSU can still load `system.prop` with `resetprop -n` and execute module
boot scripts, so this module can still affect property-only checks on Android
15+ when KernelSU or SukiSU Ultra is active during boot.

Limitations:

- Hardware-backed Play Integrity / Key Attestation can still report the real
  device state.
- Bootloader splash warnings are shown before Android userspace starts and
  cannot be hidden by a userspace module.
- Some apps read kernel bootconfig, `/proc/cmdline`, TEE-backed signals, or
  vendor-specific interfaces instead of `getprop`; this module cannot cover
  those checks by itself.

## Install

1. Run `powershell -ExecutionPolicy Bypass -File .\pack.ps1`.
2. Install the zip from KernelSU Manager, SukiSU Ultra, or a compatible manager.
3. Reboot.

## WebUI

Open this module from a WebUI-capable KernelSU/SukiSU Ultra manager to view
the current value and match status for each masked property.

## Verify

After reboot, run:

```sh
su -c 'getprop | grep -E "flash.locked|vbmeta.device_state|verifiedbootstate|veritymode|warranty_bit|secureboot|oem_unlock|build.type|build.tags|debuggable|ro.secure"'
```

Expected highlights:

- `ro.boot.flash.locked=1`
- `ro.boot.vbmeta.device_state=locked`
- `ro.boot.verifiedbootstate=green`
- `ro.boot.veritymode=enforcing`
- `ro.build.type=user`
- `ro.build.tags=release-keys`
- `ro.debuggable=0`
- `ro.secure=1`

## Notes

The included property set is based on the original `hide_locked` module and
cross-checked with Root-Masker. The module intentionally avoids system file
replacement, so no OverlayFS/metamodule dependency is required.
