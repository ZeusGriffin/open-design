---
tags: [hardware, esp32, c3, s3, c6, pocket-ai, xiaozhi, firmware, github]
status: source-archived-not-hardware-tested
source_video: https://youtu.be/25RGnr407PM
github: https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/pocket-esp-ai
created: 2026-11-06
---

# Pocket ESP AI — Huy Vector source and multi-board build

**Goal:** Keep the original source and adapt the XiaoZhi project for different ESP32 devices. Do not replace other board firmware with the creator's C3-specific binary.

## Links
- [[Pocket ESP AI - Ready to Flash]] — original C3 wiring and one-image reference
- [Project GitHub folder](https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/pocket-esp-ai)
- [Creator build](https://www.huyvector.org/robots-kinetic/pocket-ai-assistant)
- [Upstream XiaoZhi](https://github.com/78/xiaozhi-esp32)
- [YouTube video](https://youtu.be/25RGnr407PM)

## Extracted source and verified inputs
- Full original source packaged in GitHub as **10 numbered archive parts**.
- Run `scripts/RESTORE_SOURCE.ps1` in the checked-out project; reassembles and extracts after SHA-256 validation.
- ZIP SHA-256: `fa2748b253e356b7947276b5f4e7654e3515466a62a5d6fddee898ee08259958`.
- Original C3 firmware SHA-256: `3d9dc6d68cc0eebaacb05f20fb4cc49fda7802eda21400483f1d9fcf2a01cf98`.
- Reusable XiaoZhi source covers several ESP32 targets, not literally every MCU board.

## Build a new board profile
1. Open ESP-IDF PowerShell.
2. Run `scripts/RESTORE_SOURCE.ps1` one time.
3. Run `scripts/BUILD_FOR_BOARD.ps1 -Chip esp32s3` (or `esp32c6`, `esp32c3`).
4. Choose matching board target, screen, mic, speaker, GPIO, and partition sizes in menuconfig.
5. Build first, flash only on explicit `-Flash -Port COMx` when hardware is available.
6. Verify boot, Wi-Fi provisioning, speech capture, reply audio, and display.

## Pending physical verification
- [ ] Select exact ESP board and peripherals
- [ ] Confirm pinout and memory capacity
- [ ] Run first target build
- [ ] Flash and test speech round-trip
- [ ] Lock tested firmware image and rollback file
