# YouTube comments and liquid-display research

Source video: https://youtu.be/c_qwv6NKEDg

**Evidence limit:** YouTube comments were not exposed in the accessible video result. Hackster lists two comments but the available static page did not render their text. So **no particular comment or “liquid display” link is verified**.

Verified published creator material:
- https://www.hackster.io/techtalkies1/tiny-oled-keychain-with-a-face-c4c694
- Published October 5, 2026, MIT license.
- XIAO ESP32-C3, 1.3-inch OLED, LiPo battery, 3D shell.
- Original sketch: U8g2, SH1106 128×64 I²C, 33 ms frame cap, six expressions, blink, saccades, easing.

Two separate possible meanings of “liquid display”:
1. Organic/liquid **motion** for the face (we implemented basic software easing/squash in the preview and firmware).
2. Color **LCD** (liquid crystal display) or **AMOLED** hardware (not implemented in OLED driver; needs specific model and driver).

Independent actual fluid-simulation code: https://github.com/V4C38/esp32-fluidbox — built for an ESP32-S3 Waveshare AMOLED board and is **not known** to be the link in the video comments.

Before adding third-party code, capture the exact YouTube commenter’s link/text and verify its license and display driver.
