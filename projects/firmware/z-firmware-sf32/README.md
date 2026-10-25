# Z-Firmware SF32

**Custom portable-tool launcher for LILYGO T-Display SF32 + Keyboard expansion**

**Status: v0.1 source overlay, NOT yet compiled or hardware-tested.** This is original code that modifies the home launcher in LILYGO's official RT-Thread/LVGL `menu_app` sample. It is not M5Stack Cardputer firmware and contains no M5Stack binaries.

## v0.1 (implemented in source)

- Z-Firmware navy/white/blue home screen and 2-column touch/physical-key launcher.
- All 11 official `menu_app` destinations are preserved: music, LoRa, sensors/IR, GPS, Wi-Fi, charge status, weather, voice recorder, SD file browser, keyboard test, system.
- Original GPS, LoRa, battery monitoring/low-battery protection, wireless init, existing apps and keyboard event handler stay in LILYGO's code.
- The exact upstream Git commit is pinned to prevent accidental changes.
- Source overlay refuses unexpected upstream layouts, keeps an original `ui.c` backup, and is idempotent.
- No automated firmware flashing (a deliberate safety precaution).

### Not yet implemented

New apps/plug-in system, NFC, emulators, phone notifications, Wi-Fi radar, Bluetooth text messaging, additional IR protocol library, and a one-click signed firmware file are *future ideas*, not current capabilities. This release simply creates a new launcher over a supported factory-code base.

## On your Windows PC

1. Download this ZIP and extract it somewhere like `Documents\Z-Firmware-SF32`.
2. Install Git for Windows and Python 3, if absent.
3. In PowerShell **within the extracted folder**, run `powershell -ExecutionPolicy Bypass -File .\prepare_windows.ps1`. This downloads a **specific upstream commit**, then patches `examples/menu_app/src/ui.c` (with an unmodified backup). It does **not** flash the device.
4. Install LILYGO's [SiFli SDK](https://github.com/Xinyuan-LILYGO/SlFli-SDK-Lilygo) and follow its [Windows instructions](https://github.com/Xinyuan-LILYGO/SlFli-SDK-Lilygo/blob/master/readme.md).
5. Open the SDK-configured Windows Command Prompt (`set_env.bat`) and run `build_windows.cmd` from this folder. The build uses `scons --board=t-display-sf32_hcpu -j8`.
6. **Do not flash until** your particular board/radio variant is confirmed, a recovery path is available, and the resulting build has been reviewed. The build creates an `uart_download.bat` in the firmware project output; flashing is intentionally a separate manual step.

## Official sources

- Board source: https://github.com/Xinyuan-LilyGO/T-Display-SF32
- Original menu app: https://github.com/Xinyuan-LilyGO/T-Display-SF32/tree/master/examples/menu_app
- Original factory keyboard recovery files: https://github.com/Xinyuan-LilyGO/T-Display-SF32/tree/master/firmware/T-SF32-Factory-Keyboard-V1.5.5
- Official SDK: https://github.com/Xinyuan-LILYGO/SlFli-SDK-Lilygo
- Pinned board commit: `6f98f80d9ac4b147940593a9a2c2738586a4436e` (September 17, 2026).

## Hardware and safety notes

- Device has SiFli SF32LB52X as its main processor; expansion keyboard includes ESP32-C6 Wi-Fi/serial support and L76K GPS on a shared UART. This is **not** ESP32-S3 and will not run Cardputer ADV `.bin` files.
- **Do not disable** battery measurement and low-battery protection: LILYGO explicitly warns that firmware without it can over-discharge the battery. v0.1 leaves the official battery logic in place, but a build still needs bench tests.
- USB-C on this model connects through CH343P USB-to-UART, not directly to the processor's USB HID/MSC interface.
- GPS and Wi-Fi share a UART multiplexer; do not expect simultaneous uninterrupted access without handling switching.
- LoRa transmission must use a frequency/setting legal for your region and compatible with the installed module variant.
- Preserve the original `ui.c.z-original-backup` file. Save original firmware/recovery instructions before attempting any flash.

## Verification checklist

- [x] Official `menu_app` function identified and app IDs retained.
- [x] Custom menu overlay source and Windows prepare/build scripts written.
- [x] Python patcher has sample-source tests.
- [ ] Real upstream source patch validated against checked-out commit on Windows.
- [ ] SiFli SDK build passes.
- [ ] Display/touch/keyboard checked on actual LILYGO board.
- [ ] GPS, Wi-Fi, LoRa, charging and low-battery behavior checked.
- [ ] Factory firmware recovery demonstrated.

## Project layout

- `patches/z_launcher_home.c` — new LVGL launcher function (inserted into official UI source).
- `apply_z.py` — guarded patcher.
- `prepare_windows.ps1` — download pinned original code and apply patch.
- `build_windows.cmd` — build only, never flash.
- `tests/test_patcher.py` — offline patch checks.

No claim of a working installable firmware image is made until build and hardware validation succeed.