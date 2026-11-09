# Tamagotchi New Juke
Two original firmware variants for existing hardware.
Video reference: https://youtu.be/7HAVLICDQXI
Status: source video hardware unverified; firmware untested on physical devices.

## Variant A: LILYGO T-Display S3
Folder: variants/lilygo-t-display-s3/
Uses built-in color display via TFT_eSPI. Requires exact pin mapping from the particular LilyGO revision, configured in TFT_eSPI User_Setup before flashing. Do not assume stock TFT_eSPI settings work.

## Variant B: ESP32-C6 1.3-inch OLED
Folder: variants/esp32-c6-oled/
Uses SSD1306 I2C 128x64 demo. WARNING: many 1.3-inch OLED modules use SH1106, not SSD1306; confirm controller, resolution, pins and address. GPIO pins are explicitly placeholders.

## Get-home test
1. Photograph each board front/back and identify its exact model.
2. Identify OLED controller and LILYGO display pinout from the manufacturer's board revision.
3. Set correct pins and drivers in source and build config.
4. Build in PlatformIO, then upload only to matching board.
5. Check serial logs, animation, sleep/power and button behavior.
6. Preserve original firmware before flashing.

Original creator's GitHub code has not been verified. These are our own starter examples.
