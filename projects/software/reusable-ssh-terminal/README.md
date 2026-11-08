# Reusable SSH Terminal Kit

Status: source references, configuration schema, and build prompt prepared. No iOS app or firmware has been compiled or installed.

## Source candidates
- iOS: https://github.com/madeye/gterm (MIT, verify current license and pin commit)
- iOS alternative: https://github.com/jhancock1975/pockterm (Apache-2.0)
- ESP32-S3: https://github.com/sigman78/esperdeck (verify exact license and board requirements)
- Terminal rendering: https://github.com/migueldeicaza/SwiftTerm

## Targets
1. iPhone 15 CyberDeck — landscape terminal with Bluetooth keyboard
2. Raspberry Pi Zero 2 W + Whisplay HAT — SSH server endpoint or separate UI
3. Cardputer ADV — client feasibility study, limited RAM/screen
4. Windows PC — SSH server endpoint with OpenSSH
5. ESP32-S3 — independent client firmware only if hardware supports it

## Boundaries
SSH is a secure remote shell protocol; a terminal UI is not an SSH implementation. Do not transplant Swift iOS code into ESP32 firmware. Use maintained SSH libraries, host-key verification, and device secure storage. Never embed credentials or disable host-key checking.
