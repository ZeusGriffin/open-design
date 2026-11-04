# Wuzplay Cyberdeck v9

This directory is the end-to-end build harness for a custom Wuzplay/Pixl.js Nordic DFU.

## What is in this branch
- firmware patch generator (`apply_patch.py`)
- post-patch compatibility fixes (`post_patch_fixes.py`)
- canonical GitHub Actions DFU workflow
- complete build/acceptance specification (`BUILD_SPEC.md`)
- Nordic DFU validator and release packager (`package_release.py`)
- Meditation Cyber phone-side web source

## Intended firmware features
- 180-degree OLED rotation
- four-button mapping: LEFT / SELECT / RIGHT / BACK
- native Cyberdeck mini-app
- Meditations
- Games: Snake, Pong, Breakout, Dodge, Reaction, NBA 2K Coming Soon
- VFS companion pages
- Chameleon/NFC preservation
- multi-press shortcut handling

## Shortcut map
- BACK x5 -> Govee preset/action
- BACK, RIGHT, BACK, BACK -> Meditation Cyber
- LEFT x5 -> Find My Car
- RIGHT x6 -> Flashlight

NFC phone actions are not remote-control radio commands. A phone must still read the emulated NFC tag unless a separate tested BLE companion is implemented.

## Build output
A passing canonical workflow should publish `Wuzplay-Cyberdeck-v9-Verified-Package`, containing the compiled DFU, an outer verified install package, hashes, firmware size report, companion files, and instructions.

## Verification language
Compilation and archive validation are CI-verifiable. Screen orientation, physical button GPIO mapping, NFC behavior, and phone actions must remain labeled `COMPILE VERIFIED - DEVICE TEST REQUIRED` until tested on actual hardware.
