# Pocket ESP AI — full source archive (2026-11-06)

**Complete original Huy Vector project archive is stored in this repository**, split into ten Git blobs because of large-file upload limits. It contains **1,623 source files** plus the creator's original ESP32-C3 firmware and instructions.

- Original video: https://youtu.be/25RGnr407PM
- Creator project: https://www.huyvector.org/robots-kinetic/pocket-ai-assistant
- XiaoZhi upstream: https://github.com/78/xiaozhi-esp32
- Creator source archive SHA-256: `fa2748b253e356b7947276b5f4e7654e3515466a62a5d6fddee898ee08259958`
- Creator ESP32-C3 merged image SHA-256: `3d9dc6d68cc0eebaacb05f20fb4cc49fda7802eda21400483f1d9fcf2a01cf98`

## Rebuild code for your board

1. In Windows PowerShell, run `scripts/RESTORE_SOURCE.ps1` from this project. It verifies and extracts the full original source.
2. Activate your ESP-IDF environment; the creator reports ESP-IDF **5.5.2** for the original C3 build, while the included upstream mainline documentation discusses **6.x**. Use the SDK version compatible with the selected target.
3. Run `scripts/BUILD_FOR_BOARD.ps1 -Chip esp32s3` or `-Chip esp32c6`, etc. This executes `idf.py set-target`, `menuconfig`, and `build`. Select a matching board profile and correct pins in menuconfig before building.
4. Add `-Flash -Port COM7` only after checking physical hardware; **the build is not flashed by default**.

The framework has target variants for ESP32, C3, C5, C6, S3 and P4. It is **not automatically compatible with arbitrary non-ESP32 boards** or every peripheral setup. The prebuilt Huy firmware is solely for his wired **ESP32-C3 SuperMini** configuration. For other ESP32 boards compile a separate profile from source. A single `idf.py flash` command can install a board-specific build; this is different from one universal binary.

## Source license and status

The archive includes XiaoZhi's **MIT license** in `source/xiaozhi-esp32/LICENSE`, which must be kept with distributed code. Preserve creator credit for Huy Vector. We did not modify the creator ZIP contents. Individual board builds and hardware testing are **not completed**.
