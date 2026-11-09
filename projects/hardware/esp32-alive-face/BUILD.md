# Build and flash — beginner steps

## Required for this initial demo
- Generic ESP32 DevKit board supported by PlatformIO's esp32dev profile
- SSD1306 128x64 I2C OLED (not a color TFT)
- USB data cable, jumper wires, computer with VS Code and PlatformIO

## Wiring (ONLY for a confirmed compatible generic ESP32)
- OLED VCC -> 3.3V (verify your module supports 3.3V)
- OLED GND -> GND
- OLED SDA -> GPIO21
- OLED SCL -> GPIO22
- Verify voltage, pinout, I2C address and screen controller before powering on.

## Steps
1. Install VS Code and the PlatformIO extension.
2. Open this project folder.
3. Confirm your exact board is generic ESP32 DevKit; otherwise STOP and change profile and wiring.
4. Connect the board with a USB DATA cable.
5. Select PlatformIO: Build.
6. Fix build errors before attempting upload.
7. Select the detected serial port and Upload.
8. Open serial monitor at 115200 baud.
9. Expected: animated blinking eyes and alternating mouth expressions.
10. If screen remains blank, disconnect power and verify wiring, address (0x3C), and controller type.

## Safety / recovery
- Do not flash this generic build to Cardputer ADV, LilyGO K230, or an unknown board.
- Keep backups of existing firmware and configuration before any upload.
- Hardware has NOT been tested; passing a build alone does not confirm compatibility.

## Original video research
https://youtu.be/7HAVLICDQXI
Original source repository: NOT VERIFIED.
Original display and board: NOT VERIFIED.
