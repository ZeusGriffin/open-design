# Cardputer ADV app-design starting brief

Status: proposed direction for discussion, not an implemented app or approved final design.

## Proposed first app: Pocket Desk

A small offline-first utility app for quick notes, a focus timer and device status. It exercises the keyboard, display, SD persistence and navigation without requiring extra hardware or a cloud account. Alternatives worth exploring after this baseline are an instrument inspired by GLIDE, a virtual companion inspired by Raising Hell, or a desktop status companion.

## Device experience

- Home: three choices — Notes, Timer, Device — with a clear selected row.
- Notes: list, editor, explicit save and visible saved/unsaved state.
- Timer: duration, start/pause, remaining time, and optional sound.
- Device: battery estimate, storage status and firmware version.
- Global navigation: predictable Back and Home actions; shortcuts visible on screen.
- Missing SD card: explain what cannot be saved and preserve an in-memory draft when possible.
- Offline use: core screens remain responsive without Wi-Fi.

Layout proposal for the 240 × 135 display: a 16-pixel status strip, a 103-pixel content area, and a 16-pixel action strip. Prototype at actual resolution before selecting font sizes; these dimensions are design choices, not hardware API requirements. Use a visible focus marker and words/icons as well as color. Avoid tiny touch targets: the interface is keyboard driven.

## Implementation choices to evaluate

| Route | Benefit | Tradeoff |
|---|---|---|
| Arduino/C++ with M5Cardputer, M5Unified and M5GFX | Direct control and an official hardware foundation | Compile/reflash cycle and explicit memory management |
| UIFlow2 / MicroPython | Short iteration loop and official board support | Runtime-specific APIs and memory limits |
| Picoware or ADV MicroHydra | Existing app discovery and application ecosystem | Adopt the chosen runtime's app format; do not mix deployment conventions |

Provisional preference: native C++ for a polished standalone utility; Python for quick concept trials. Select one runtime after testing keyboard, drawing, storage and audio on the actual device.

## References for design study

- [M5Cardputer](https://github.com/m5stack/M5Cardputer): hardware entry point.
- [Sparks](https://github.com/KyleBing/m5stack-cardputer-sparks): letter shortcuts and compact utilities.
- [lxhyl launcher](https://github.com/lxhyl/cardputer): menu/status organization and simple app entry points.
- [GLIDE](https://github.com/CHARL3X/GLIDE-Synth-Cardputer-ADV): keyboard as an expressive control surface.
- [Raising Hell](https://github.com/acpayers-alt/raising-hell-cardputer): personality and small-screen interaction.
- [Official ADV specifications](https://docs.m5stack.com/en/core/Cardputer-Adv): hardware constraints.

These are inspiration and technical references; copying implementation or assets requires checking their licenses.

## Acceptance checks for implementation

1. All actions work using the ADV keyboard and show visible focus.
2. Key repeat, modifier keys, Back and Home work without accidental activation.
3. Timer and input remain responsive during storage or network work.
4. Notes survive a normal restart after saving; interrupted writes do not destroy the previous saved copy.
5. Missing/full SD card and disconnected Wi-Fi produce clear recoverable states.
6. Text fits at 240 × 135 without hiding the active action.
7. Speaker/headphone behavior, sleep and battery indication are checked on hardware.
8. Record exact dependency revisions, build target, partition layout and tested hardware.

## Decisions for the next design session

Choose the first app's purpose, visual style (minimal, retro terminal, playful), preferred runtime, and whether it needs a phone/desktop companion. Inventory available SD storage and any LoRa/GPS or other expansion modules before selecting features that depend on them.
