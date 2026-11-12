# Pocket Face Keychain — build starter
Status: **software preview ready; ESP32 hardware not connected or flashed**.

Inspired by Tech Talkies' [tiny OLED keychain](https://youtu.be/c_qwv6NKEDg). Its original [Hackster project](https://www.hackster.io/techtalkies1/tiny-oled-keychain-with-a-face-c4c694) publishes the source under MIT. This is an original implementation, not a copied project.

## Step 1 — code first
Open \`web/index.html\` in any browser. Choose a face, turn on **Liquid motion**, and test the color LCD *mockup*. Edit the presets in the source. Nothing needs to be purchased or plugged in yet.

## Step 2 — when your ESP32 is available
Use a **Seeed XIAO ESP32-C3** (the board listed in the published Hackster build) and a **1.3-inch SH1106 128×64 I²C OLED**. Install VS Code + PlatformIO, open \`firmware/\`, build and upload. Wired: D4/GPIO6 → SDA; D5/GPIO7 → SCL; 3V3 → VCC only if rated for 3.3 V; GND → GND. Check your actual display controller and I²C address (usually 0x3C) first.

Serial 115200: n neutral, h happy, s sad, u surprised, z sleepy, a angry, l toggle liquid motion, r resume automatic expressions, ? help.

## Project files
- \`web/index.html\`: one-file, offline-capable browser animation simulator.
- \`firmware/platformio.ini\`: board and U8g2 library.
- \`firmware/src/main.cpp\`: nonblocking Arduino OLED animation firmware.
- \`docs/BOM.md\`: shopping, wiring and verification checklist.
- \`docs/COMMENTS_AND_LIQUID.md\`: source evidence and unverified YouTube comment lead.
- \`config/presets.json\`: expression shape reference.

**Important**: “Liquid motion” currently means gentle soft/squishy face animation, *not* a real physical fluid simulation. A color LCD/AMOLED later requires its own driver and wiring; don't buy based on the browser mockup alone. No battery wiring until USB display tests pass.

Useful references: [Seeed pinout](https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/), [PlatformIO board](https://docs.platformio.org/en/latest/boards/espressif32/seeed_xiao_esp32c3.html), [different ESP32-S3 AMOLED fluid demo](https://github.com/V4C38/esp32-fluidbox).