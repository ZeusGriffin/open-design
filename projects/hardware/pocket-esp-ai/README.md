# Pocket ESP AI — ready-to-flash kit

**Status (2026-11-06): STAGED / NOT FLASHED / NOT HARDWARE-TESTED.**

Huy Vector Tiny Pocket AI Assistant from [this video](https://youtu.be/25RGnr407PM). The custom build is **ESP32-C3 SuperMini** + 0.96-inch SSD1306 OLED + INMP441 mic + MAX98357A amplifier, built on XiaoZhi. **Do not flash this to an ESP32-S3, ESP32-C6, Cardputer ADV, or Raspberry Pi.**

## Original sources
- Creator instructions/wiring: https://www.huyvector.org/robots-kinetic/pocket-ai-assistant
- Author's merged firmware: https://drive.google.com/file/d/17c_fR2NngYaQpYxT_LWSCMmulzYWSW7z/view
- Author's complete original source archive: https://drive.google.com/file/d/1cMkIfFeNmcq-qPcIJcd-mscBPmawfYK2/view
- XiaoZhi upstream: https://github.com/78/xiaozhi-esp32
- Espressif flashing reference: https://docs.espressif.com/projects/esptool/en/latest/esp32c3/esptool/basic-commands.html

## One-image firmware
The author's firmware image is **3,541,630 bytes**, SHA-256 **3d9dc6d68cc0eebaacb05f20fb4cc49fda7802eda21400483f1d9fcf2a01cf98**. Checked: identical to the firmware copy inside the original source archive. Target: ESP32-C3, write one merged image at **0x0**. No separate bootloader or partition files are needed for this specific published image.

The image itself and full source archive remain available via the original creator's links. This repository keeps setup/verification files separately, and an offline kit copy was created with firmware + source + scripts. If re-downloaded, always verify SHA-256 before flashing.

## Flash it later on Windows
1. Confirm the exact physical ESP32-C3 SuperMini board, peripherals and 4 MB+ flash; disconnect other ESP boards.
2. Get Python 3 and install esptool once: `py -3 -m pip install --user esptool`.
3. Place `flash_pocket_ai.py`, `FLASH-WINDOWS.cmd`, and the original binary in `firmware/pocket-esp-ai-by-huy-vector-english.bin` in the same project folder layout. The packaged ZIP already contains these files.
4. Offline check: `py -3 flash_pocket_ai.py --check-only`.
5. Use Device Manager to identify current COM port; run `FLASH-WINDOWS.cmd`, enter the port, verify chip/flash size, and type `FLASH` when prompted.
6. Verify display, provisioning Wi-Fi, microphone, speaker, and “Hi ESP” wake word.

**Warning:** Full write at 0x0 may overwrite old firmware, partitions, Wi-Fi settings or other data. This is **not** OTA; preserve an old firmware backup if needed. We have **not** validated the boot or features on real hardware.

## Wiring copied from author's supplied README

| Device | Pins → ESP32-C3 SuperMini |
|---|---|
| SSD1306 OLED | SDA GPIO21, SCL GPIO20 (3.3V) |
| INMP441 mic | BCLK GPIO2, WS GPIO1, SD GPIO8, L/R GND (3.3V) |
| MAX98357A speaker amp | BCLK GPIO2, LRC GPIO1, DIN GPIO3 (5V per project) |
| Button | GPIO10 to GND |

Share common GND. GPIO8 may be attached to a built-in LED on some boards. Confirm your exact board's wiring and power input before applying power.

## Verification status
- [x] Original build page and both downloaded files located
- [x] SHA-256 verified; standalone binary matches source-archive firmware
- [x] Cross-platform one-write flasher script prepared and offline check tested
- [ ] Exact owner hardware and connections checked
- [ ] Serial-port chip/flash size confirmed
- [ ] Physical flash and application feature testing completed

Obsidian note: [obsidian/Pocket ESP AI - Ready to Flash.md](obsidian/Pocket%20ESP%20AI%20-%20Ready%20to%20Flash.md)
