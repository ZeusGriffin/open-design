# Hardware & software checklist

## Original OLED version
- [ ] Seeed Studio XIAO ESP32-C3 board (note: some video metadata elsewhere references S3; this plan follows Hackster's parts list).
- [ ] 1.3-inch 128×64 SH1106 I²C **4-pin** OLED module, confirmed 3.3V-compatible.
- [ ] USB-C **data** cable for flashing and initial powering.
- [ ] 4 jumper wires/breadboard for testing.
- [ ] VS Code and PlatformIO extension or Arduino IDE with U8g2 library.
- [ ] Single-cell **protected** 3.7V LiPo battery, correctly sized and wired per board manufacturer (later).
- [ ] Suitable on/off switch (later).
- [ ] Custom 3D-printed case matched to *measured* parts, key ring, small fasteners.
- [ ] Soldering iron, insulation, multimeter (for permanent enclosure).

| SH1106 I²C OLED | XIAO ESP32-C3 |
|---|---|
| SDA | D4 / GPIO6 |
| SCL | D5 / GPIO7 |
| VCC | 3V3 only if OLED module supports 3.3 V |
| GND | GND |

I²C address often 0x3C; controller can also be SSD1306 — check actual hardware first. A display with different interface is *not* interchangeable by changing one number.

## LCD or real fluid simulation (optional; do not order yet)
- [ ] Decide if “liquid” means fluid animation or a liquid-crystal/color display.
- [ ] For an LCD: confirm driver, resolution, supply, and SPI or other pinout (example ST7789; not a drop-in OLED).
- [ ] For physically reactive fluid: consider an accelerometer and a better-supported ESP32-S3 + suitable AMOLED board, e.g. V4C38/esp32-fluidbox.

## Verification sequence
1. Run preview offline; all six emotions must work.
2. Flash firmware to the correct XIAO board via USB (no battery yet).
3. Confirm OLED animation and Serial output at 115200.
4. Test each emotion command and liquid mode.
5. Measure module dimensions; then decide enclosure and battery layout.
6. Never short, puncture, crush or use an unprotected lithium cell.
