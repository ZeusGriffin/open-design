# BASE: engineering notes and change gates

**Locked baseline:** standard iPhone 15 (not Pro), Pamir-inspired white/orange/black, sloped rear display module, rear USB access opening, two interchangeable versions. Preserve existing geometry when fixing fit.

## Industrial design constraints
The original Lapis One reference is 85×85×28mm, with an angled orange screen hood, white lower body and 240×400 monochrome LCD. BASE adapts these elements to a 71.6mm-wide iPhone 15. This is not original factory CAD or a copy of its electronics.

## Prototype pass/fail checks
1. [ ] 0.5mm nominal case clearance per side: phone seats without force; no glass/aluminum abrasion.
2. [ ] Camera and flash: actual measured island clear, lenses safely recessed or guarded.
3. [ ] Side buttons and mute switch: move freely.
4. [ ] Speakers and microphones: unobstructed.
5. [ ] Native bottom USB-C: charging cable fully inserts and can be unplugged safely.
6. [ ] Rear USB: choose a *real* extension fitting the 15×8mm access opening, design cable routing and strain relief, then electrically test.
7. [ ] BASE02 LCD: real 51.2×27.3mm Waveshare module, board thickness, cable exit and active display align with pocket/bezel.
8. [ ] Powered prototype temperature, wireless charging, and handling: safe in sustained use.

## Suggested materials
TPU for the phone-retaining shell, PETG for rigid orange display wedge, black opaque PLA/PETG for insert/bezel. Slice with supports when required; no impact or water-resistance rating.

## Engineering note on the rear connector
The CAD contains an **opening only**, not a USB-C receptacle. Replacing the opening with a working rear connector requires picking and measuring a compatible right-angle USB-C male-to-female extension, carving a protected channel in the rear module, isolating the hardware from phone glass, and avoiding lateral stress on the phone's native USB-C plug. Do not claim it is functional until hardware verified.

## Electronics
Waveshare 1.9in SPI LCD, 170×320, module dimensions 51.2×27.3mm. Bare SPI LCD is not a native external iPhone display. For status functionality, prototype independently with ESP32-class MCU and supported low-voltage power, then plan a companion app if phone communication is desired.

## Sources
- https://www.pamir.ai/
- https://support.apple.com/en-us/111831
- https://www.waveshare.com/1.9inch-LCD-Module.htm
