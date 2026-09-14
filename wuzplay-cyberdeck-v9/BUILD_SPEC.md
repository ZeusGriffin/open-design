# Wuzplay Cyberdeck v9 — End-to-End Build Specification

## Goal
Produce a real, compiled, installable Nordic DFU ZIP for Wuzplay. Source-only packages, placeholder ZIPs, renamed binaries, and JavaScript mockups do not count as completion.

## Firmware base
- Upstream: `solosky/pixl.js`
- Pinned build base: `2.12.0` unless device compatibility proves another exact tag is required
- Target: Nordic nRF52 / OLED / 128x64 monochrome
- Build: `BOARD=OLED RELEASE=1 APP_VERSION=900`
- Preserve BLE, Chameleon/NFC, Amiibo, VFS, settings, power management, bootloader compatibility, and existing apps

## Display
Rotate the complete OLED interface 180 degrees. Do not mirror text. Menus, text, Cyberdeck, NFC screens, status UI, and games must match the flipped physical orientation.

## Buttons
1. Button 1 = LEFT
2. Button 2 = SELECT / OK
3. Button 3 = RIGHT
4. Button 4 = BACK

BACK returns one logical level: detail -> parent, submenu -> parent, game -> Games list, Cyberdeck page -> previous Cyberdeck page. Do not implement BACK as reboot.

## Cyberdeck app
Native MUI mini-app named `Cyberdeck` with:
- Meditations
- Games
- NFC Cards
- Cyber Dashboard
- Calendar
- Contacts
- Notes
- Cyber Tools

Controls: LEFT previous, RIGHT next, SELECT open, BACK previous page. Use fonts already compiled by Pixl.js; `u8g2_font_wqy12_t_gb2312a` is known-safe.

## External storage
Support bounded reading of:
`alerts.txt`, `calendar.txt`, `commands.txt`, `contacts.txt`, `cyber.txt`, `emergency.txt`, `govee.txt`, `home.txt`, `links.txt`, `network.txt`, `nfc.txt`, `notes.txt`, `quick.txt`, `system.txt`, `todo.txt`, `tools.txt`.

Missing files must display `FILE NOT FOUND` or `NO DATA`, never crash.

## Games
Enable native Games and include:
- SNAKE — LEFT/RIGHT steering, food, growth, collision, BACK exits
- PONG — player paddle, CPU paddle, ball collision, score, BACK exits
- BREAKOUT — reuse/adapt tiny Arkanoid where practical, BACK exits
- DODGE — three lanes, LEFT/RIGHT, obstacles, score, collision, BACK exits
- REACTION — random wait, GO signal, SELECT reaction, result display, BACK exits
- NBA 2K - COMING SOON — joke screen: `Salary cap: 2 KB RAM` and `No microtransactions.`

## Meditations
Native Stoic section focused on Marcus Aurelius and Seneca using public-domain material or original paraphrases. LEFT/RIGHT browse, SELECT open, BACK return.

## Meditation Cyber
Phone-side portrait experience launched by NFC:
- dark gray stone atmosphere
- extremely subtle parallax mist/cloud depth
- monospace/code-inspired type
- words emerge slowly from mist
- unusual off-center placement
- two-part thought may appear in two separate locations
- complete experience fades away after about 15 seconds
- random Stoic meditation per load

Wuzplay provides NFC launch data only. The phone loads the web experience. Never claim Wuzplay itself loads Internet content.

## NFC / Chameleon
Preserve Chameleon emulation. Cyberdeck NFC area should support concepts including CyberSync Alerts/All/Dashboard/Network/System/Tools, Drive Home, Find Car, Flashlight, Govee Blue/Bright/Movie/Off/On/Red/Relax, Open WuzSync, Quick Note, Timer 10m, Meditations Tap, and Meditation Cyber.

Each card should expose human-readable Details in the correct metadata/UI layer. Do not inject arbitrary text into raw NFC dump bytes.

## Button shortcuts
- BACK x5 -> Govee preset/action
- BACK -> RIGHT -> BACK -> BACK -> Meditation Cyber
- LEFT x5 -> Find My Car
- RIGHT x6 -> Flashlight

Use a bounded sequence buffer and reasonable timeout. Normal single-button navigation must remain predictable. NFC shortcuts may select/activate a preset, but the phone still needs to read the NFC tag unless a separate tested BLE companion path exists.

## Phone actions
Phone-assisted actions include Govee, Flashlight, Find My Car, Quick Note, Timers, and Meditation Cyber. Clearly document Apple Shortcuts/phone-side dependencies where required.

## Embedded constraints
Use bounded buffers, static data where practical, small stack frames, minimal dynamic allocation, no Internet stack on Wuzplay, no huge images/quote databases, and reuse existing firmware functionality. Watch flash/RAM linker output.

## CI / build
End with one canonical workflow that:
1. checks out this repository
2. clones pinned Pixl.js source
3. initializes submodules
4. applies Cyberdeck patches
5. applies compatibility fixes
6. compiles OLED firmware
7. generates Nordic DFU ZIP
8. validates manifest/BIN/DAT
9. calculates SHA-256
10. stages companion files and install instructions
11. uploads the final artifact

Do not hide build errors with `|| true`.

## DFU validation
A successful install ZIP must contain a valid `manifest.json` and referenced application `.bin` / `.dat` files, all non-empty. Generate `DFU_VERIFICATION.json` with hashes and build metadata.

## Final package
`Wuzplay_Cyberdeck_v9_Verified_Package.zip`

Expected layout:
- `01_INSTALL_WUZPLAY_DFU_KEEP_ZIPPED.zip`
- `02_COMPANION_FILES_UNZIP_FIRST/External_Storage/`
- `02_COMPANION_FILES_UNZIP_FIRST/NFC_Pack/`
- `02_COMPANION_FILES_UNZIP_FIRST/Meditation_Cyber_Web/`
- `02_COMPANION_FILES_UNZIP_FIRST/instructions/`
- `READ_ME_FIRST.txt`
- `DFU_VERIFICATION.json`

## Acceptance status
Only CI-verifiable items may be marked complete in CI. Anything requiring the physical Wuzplay must be labeled `COMPILE VERIFIED - DEVICE TEST REQUIRED` until actually tested on hardware.

Required acceptance checks include screen rotation, four-button mapping, one-level BACK behavior, Cyberdeck registration/navigation, all game entries, Meditations, Meditation Cyber integration, safe missing-file handling, Chameleon build integrity, safe NFC Details handling, shortcut detection, valid Nordic DFU output, passing GitHub Actions, and downloadable artifact.
