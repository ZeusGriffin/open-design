# Tamagotchi New Juke — Known Hardware

Historical project context, NOT a physical USB inventory or confirmed pinout scan.

1. LILYGO T-Display S3 — ESP32-S3, 320x170 ST7789; starter at variants/lilygo-t-display-s3; needs pin mapping verification.
2. LILYGO T-Display SF32 — SiFli SF32LB52X, 480x480 AMOLED, NOT an ESP32; separate SiFli/RT-Thread firmware.
3. LILYGO T-Display K230 Kit — Kendryte K230, Linux/Buildroot, 568x1232 AMOLED; separate Linux app.
4. Small ESP32-C6 with 1.3-inch display — exact display driver and pinout unverified. Existing SSD1306 variant is conditional; SH1106 is possible.
5. Freenove FNK0104A / ES3N28P — ESP32-S3, ILI9341 240x320 2.8-inch LCD.
6. M5Stack Cardputer ADV — ESP32-S3 with built-in keyboard/display; use Cardputer ADV-specific libraries and profile.
7. SF32 keyboard ESP32-C6 — separate coprocessor; do not flash as if it were a standalone ESP32-C6 OLED.

Firmware must be selected by verified board revision, display controller and pins. Back up factory firmware before flashing.

iPhone companion source: iphone/NewJukeApp.swift
Video reference: https://youtu.be/7HAVLICDQXI (original code not verified).
