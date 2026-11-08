# CYBERDECK + STANDALONE SSH — AI HANDOFF

## Source
- https://github.com/cobanov/cyberdeck
- https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/cyberdeck-iphone15
- https://github.com/ZeusGriffin/open-design/tree/main/projects/software/reusable-ssh-terminal
- https://github.com/madeye/gterm
- https://github.com/sigman78/esperdeck

## Mission 1: CAD first
Clone and pin upstream. Inspect its CAD, licenses, dependencies and keyboard dimensions. Adapt to **standard iPhone 15** nominal 147.6 x 71.6 x 7.8 mm, checking USB-C, camera, buttons, speakers, keyboard and hinge. Make slate and clamshell designs. Export editable CAD, watertight STL and Bambu Studio 3MF; confirm A1 mini build volume and provide BOM, assembly and test-fit checklist. Do not claim physical fit before a real print test.

## Mission 2: Standalone SSH code
Keep software/reusable-ssh-terminal independent from CAD. Inspect and pin gterm iOS upstream and licenses. Build Swift iOS SSH app with landscape UI, Bluetooth keyboard Ctrl/Alt/Esc/Tab/arrows, saved profiles, Keychain-secured credentials, secure host-key verification, and Raspberry Pi/Linux/Windows OpenSSH connectivity. Separate terminal renderer, SSH transport, settings and device-specific UI. Investigate ESP32-S3/Cardputer as independent embedded firmware, not a Swift port.

## Process
Evidence-first Karpathy-style smallest changes, baseline lock, test every stage, no duplicate work, no secrets committed, licenses preserved. Deliver complete source, build instructions, screenshots, STL/3MF, README, Obsidian notes, verification checklist and honest blockers. Start by reading existing repo files; do CAD first, then SSH.
