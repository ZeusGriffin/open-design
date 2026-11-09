---
aliases: [PLUG, PLUG checkpoint, iPhone firmware command center]
tags: [PLUG, firmware, ESP32, project-checkpoint]
checkpoint: PLUG-2026-11-09-01
---
# PLUG — checkpoint PLUG-2026-11-09-01

Live Site: https://plug-firmware-command.zeusonsora.chatgpt.site
Date: November 9, 2026 (America/Chicago).
Site source commit: 803f3cf3e12fa724e3f43e7736d348ba2da8c22d
Source file SHA256: 8ded533a4b204d8264f934a78bc2f5828fa225f9b457975afcb2d1a5015e377d

## Direction locked
- iPhone first; Android is phase 2.
- ESP32-family boards, especially LILYGO T-Display S3 and M5Stack Cardputer ADV.
- Compact ESP32-C6 OLED profile remains provisional until exact hardware identification.
- Plain, friendly UI with steps based on device and connection method.
- Reuse approved GitHub work and one master Obsidian vault.

## Implemented in the Site
- Setup guide with device and Bluetooth DFU / Wi-Fi OTA / USB-C choices.
- Checkboxes saved separately per device and connection method; next unfinished step highlighted.
- Saved pause notes, progress restoration and last-view restoration.
- Firmware project tracker, source editor, source downloads.
- Editable dependency records, prompt/code/checklist templates.
- Board profiles, comparison table and smallest next actions with pass/fail checks.
- Browser API preflight; serial-port opening where browser supports it. No firmware writer.
- Wireless DFU profile: app, protocol, firmware format, updater URL and recovery notes.
- Local firmware-package SHA256 calculation; no transfer performed.
- Compile request export and manual real-log capture.
- Troubleshooting: iPhone transport, COM-port detection, boot/DFU, drivers, power-only cable, localhost compiler error.
- Memory-card guide for Mac / Windows, exact-use steps, notes and saved checkboxes.
- Official SD Card Formatter and Raspberry Pi Imager links.
- JSON workspace export/import; Markdown note export for Obsidian.

## Honest capability boundaries
- No cloud compiler backend connected; exporting a request does not submit a build.
- No Bluetooth, Wi-Fi OTA or USB firmware writer integrated.
- Existing wireless update workflow is user-reported, not physically verified through PLUG.
- No card formatting in the Site; actual erase/write happens in official/native tools.
- Direct formatting would require a native desktop companion with drive identification and explicit erase confirmation. Not built.
- Browser-local storage only. No cross-device account sync, GitHub runtime sync or direct Obsidian integration.
- Card target format must come from exact firmware/device documentation; do not assume exFAT works or standard SD formatting meets an embedded device requirement.

## Verification performed
- JavaScript syntax validation.
- Browser inspection of original workspace, project save, connection diagnostics and iPhone troubleshooting.
- Automated checks: per-route guide steps; isolated checkpoints; saved pause notes; restoration in a fresh JS session.
- Automated card-guide checks: Windows/Mac branching, isolated progress and saved card identity.
- Native deployment returned succeeded for the latest Site version.
- Latest checklist/card updates were not physically tested on iPhone or card hardware. No actual flash, compile or format was claimed.

## Preserve personal browser data separately
The source checkpoint cannot capture edits or checkmarks stored on the user's iPhone.
In the live Site use Knowledge → Export workspace and keep PLUG-workspace.json beside this note.
Import that JSON on another browser to restore those records. Back up before replacing browser data.

## Next checkpoints
- [ ] Identify exact device + existing iPhone DFU app (App Store URL or name).
- [ ] Record accepted firmware package and updater protocol.
- [ ] Physically verify one Bluetooth or Wi-Fi update and read installed version after reboot.
- [ ] Select and connect a real cloud compile workflow.
- [ ] Verify exact board identities and memory sizes.
- [ ] Decide whether a native Mac/Windows card-formatting companion is worth building.

## Resume prompt
Continue PLUG from checkpoint PLUG-2026-11-09-01. Read this note and index.html first. Preserve the deployed layout and existing data schema. Keep iPhone first and Android later. Do not repeat completed research. Do not claim wireless flashing, cloud compilation or card formatting is integrated. Start by identifying the user's existing iPhone DFU app and exact device, then propose the smallest protocol integration with a real pass/fail hardware test. Preserve browser-local user data and export/import compatibility.

## Local preview
Serve the folder with a local HTTP server, e.g. python3 -m http.server 8080. Open http://localhost:8080.
The standalone index.html contains all application source. No dependency installation is needed.

## Obsidian use
Copy this Markdown file into your existing master vault under Projects/PLUG/. Keep index.html and the exported workspace JSON as attachments if desired. This bundle does not create or connect a second vault.
