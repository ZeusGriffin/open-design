# Espressif / ESP32-S31 — saved reference

**Saved:** 2026-10-30  
**Purpose:** Keep the official Espressif source links and a compact snapshot for future ESP32 firmware, external-display, cyberdeck, and experimental Linux projects.

## Source links

- Espressif Systems GitHub organization: https://github.com/espressif
- ESP32-S31 Developer Platform: https://esp32-s31.espressif.com/en
- ESP32-S31 device documentation/resources: https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32s31/resources.html
- ESP32-S31 preliminary datasheet: https://documentation.espressif.com/esp32-s31_datasheet_en.html
- Official ESP-IDF framework: https://github.com/espressif/esp-idf
- Official Arduino-ESP32 core: https://github.com/espressif/arduino-esp32

## Web snapshot (2026-10-30)

The ESP32-S31 Developer Platform currently highlights:

- RISC-V architecture
- CPU frequency up to 320 MHz
- Up to 512 KB on-chip SRAM
- DDR PSRAM support
- 250 MHz 8-bit DVP camera interface
- USB 2.0 high-speed OTG
- Up to 60 programmable GPIOs
- Hardware JPEG codec

It also spotlights **community projects**, including experimental ESP32-S31 Linux ports. Those are community efforts, not proof of official general-purpose Linux support or compatibility with a particular board.

**Important:** ESP32-S31 is *not* the same target as ESP32-S3. Before using any firmware, confirm the physical board's exact chip, module, flash/PSRAM, peripheral pins, toolchain and ESP-IDF target. Do not flash ESP32-S31 builds onto existing ESP32-S3 hardware such as Cardputer ADV without a verified compatibility pathway.

The ESP32-S31 datasheet viewed on the saved date is labeled **preliminary v0.5** (revision dated 2026-07-13). Recheck the latest official documentation before hardware design or purchasing.

## Reuse notes

- **Cardputer ADV / CyberDeck:** reference for platform comparison; don't alter the established ESP32-S3 firmware baseline.
- **LilyGO/ESP32 boards:** compare exact variants before selecting sample code.
- **Future prototypes:** evaluate S31 USB host, camera, PSRAM, and display possibilities separately from existing S3 projects.

This is a *reference copy of links and research notes*, not a mirror, fork, download of all Espressif repositories, or a guaranteed offline copy of the website.
