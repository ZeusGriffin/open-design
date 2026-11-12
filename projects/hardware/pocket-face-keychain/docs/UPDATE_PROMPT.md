# Repeatable Pocket Face update prompt

Continue the existing Pocket Face Keychain project in `projects/hardware/pocket-face-keychain`.

**Task:** [INSERT EXACT REQUESTED CHANGE].

**Baseline lock:** Keep the offline browser preview, six emotions, automatic blink/gaze motion, and the XIAO ESP32-C3 + SH1106 (128x64 I2C) PlatformIO target intact unless I explicitly ask to change them. Treat color LCD/AMOLED and real particle fluid simulations as optional separate tracks, not completed hardware.

**Instructions:**
1. Inspect the existing code and documentation before editing.
2. Change only the requested component, preserving all other behavior.
3. Update the browser simulator first; validate that all existing face states still work.
4. For changed expression geometry, keep web code, `config/presets.json`, and firmware face profiles aligned.
5. For hardware changes, state exact board, controller, data pins, supply voltage, and library before implementing.
6. Never claim a board was flashed, a library compiled, or a battery verified unless it actually happened.
7. Keep the Tech Talkies attribution and note whether additional liquid-display sources are verified.
8. Report files changed, tests run, known blockers, and the smallest next step.

**Verification:** browser UI works offline; PlatformIO compile and real device test are pending until the ESP32 arrives.