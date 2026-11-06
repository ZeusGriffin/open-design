---
tags: [hardware, ESP32-C3, AI, firmware, xiaozhi, ready-to-flash]
status: prepared-not-hardware-tested
created: 2026-11-06
project: Pocket ESP AI by Huy Vector
---
# Pocket ESP AI — Ready to Flash

**Ready for later hardware testing, but NOT flashed.**

## When I use it
- [ ] Identify ESP32-C3 SuperMini and verify peripheral pins
- [ ] Connect data USB and identify its current COM port in Device Manager
- [ ] Install Python 3 and esptool if absent (`SETUP-WINDOWS.cmd`)
- [ ] Run `FLASH-WINDOWS.cmd` from the offline kit, enter the correct COM port and type `FLASH`
- [ ] Test OLED, Wi-Fi provisioning, wake word “Hi ESP”, mic and speaker

**Do not use this image for Cardputer ADV, ESP32-S3 or ESP32-C6.** It is a one-image ESP32-C3 write at address 0x0, **not OTA**, and may overwrite saved settings.

## Original sources
- Video: https://youtu.be/25RGnr407PM
- Creator page and diagram: https://www.huyvector.org/robots-kinetic/pocket-ai-assistant
- Original merged .bin: https://drive.google.com/file/d/17c_fR2NngYaQpYxT_LWSCMmulzYWSW7z/view
- Original complete source: https://drive.google.com/file/d/1cMkIfFeNmcq-qPcIJcd-mscBPmawfYK2/view
- GitHub repo folder: https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/pocket-esp-ai

**Firmware SHA-256:** `3d9dc6d68cc0eebaacb05f20fb4cc49fda7802eda21400483f1d9fcf2a01cf98` (3,541,630 bytes). Verified against publisher's project archive.

## Wiring quick reference
SSD1306: SDA21 SCL20. INMP441: BCLK2 WS1 SD8 L/R=GND. MAX98357A: BCLK2 LRC1 DIN3. Button: GPIO10/GND. OLED/mic 3.3V; speaker amplifier 5V; common ground.

**Next:** confirm physical board and wiring before flashing. See [README](../README.md).
