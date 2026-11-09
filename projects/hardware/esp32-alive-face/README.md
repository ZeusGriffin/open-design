# ESP32 Alive Face — firmware starter

Status: ORIGINAL STARTER / UNVERIFIED AGAINST VIDEO / NOT HARDWARE TESTED.

Reference video: https://youtu.be/7HAVLICDQXI
Visual reference: user's screenshot of "ESP32 Projects For Beginners" / "IT'S ALIVE", 14:28, showing a handheld device with animated face.

## Objective
Create our own ESP32 device with an animated face on a small display.

## Important
The original video's description, source code, specific board, display controller, wiring and creator repository have NOT been retrieved or verified. Do not assume this starter matches the video. Do not flash the Cardputer ADV or a LilyGO device using an arbitrary board profile.

## Files
- platformio.ini — initial generic ESP32 dev-board build target
- src/main.cpp — animated face demo for SSD1306 128x64 I2C OLED (our own code)
- BUILD.md — setup, wiring caveats, test and recovery steps

## Next steps
1. Verify video description and original creator repository.
2. Identify actual ESP32 model, screen driver and pins.
3. Add a matching board profile and display driver.
4. Build and flash on selected hardware.
5. Verify screen and animations physically before marking complete.

This is a safe starting scaffold, not a recreation of the unverified original source.
