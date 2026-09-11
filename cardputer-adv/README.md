# Cardputer ADV resource collection

Collected 2026-09-11 for Zee’s Cardputer ADV app-design work. This folder is a research collection added to the existing repository. It contains 24 upstream project references, compatibility notes, a machine-readable source registry, and an app-design starting brief. Upstream firmware source trees and binary images are not bundled or installed.

## Start here

- [Source registry](sources.json)
- [App-design brief](APP_DESIGN_BRIEF.md)
- [Reusable research and development workflow](RESEARCH_WORKFLOW.md)
- [Official Cardputer ADV hardware documentation](https://docs.m5stack.com/en/core/Cardputer-Adv)

For a first native app, investigate M5Cardputer + M5Unified + M5GFX. For Python iteration, compare UIFlow2, Picoware and the ADV MicroHydra port. These are research recommendations, not results of a device benchmark.

## Hardware baseline

The official ADV documentation specifies an ESP32-S3FN8, 8 MB flash, 240 × 135 display, 56-key keyboard with a TCA8418 controller, ES8311 audio, BMI270 IMU, microSD and a 1750 mAh battery. Treat ADV as a distinct hardware target. LoRa and GPS require appropriate external hardware; do not assume they are built into the base unit. Source: [M5Stack specifications and pin map](https://docs.m5stack.com/en/core/Cardputer-Adv).

## Collection

### Official development

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [m5stack/M5Cardputer](https://github.com/m5stack/M5Cardputer) | Official Arduino library for Cardputer and ADV. | Explicit ADV library support; start here for native apps. [Evidence](https://github.com/m5stack/M5Cardputer/blob/master/README.md) |
| [m5stack/M5Unified](https://github.com/m5stack/M5Unified) | Hardware abstraction for display, audio, input, motion and power. | Lists M5CardputerADV; individual peripheral APIs still need device testing. [Evidence](https://github.com/m5stack/M5Unified/blob/master/README.md) |
| [m5stack/M5GFX](https://github.com/m5stack/M5GFX) | Graphics, fonts and drawing library. | Lists M5CardputerADV. [Evidence](https://github.com/m5stack/M5GFX/blob/master/README.md) |
| [m5stack/M5Cardputer-UserDemo](https://github.com/m5stack/M5Cardputer-UserDemo) | Factory demo source and integration reference. | Use CardputerADV branch, whose README specifies ESP-IDF 5.4.2; default branch targets older hardware. [Evidence](https://github.com/m5stack/M5Cardputer-UserDemo/blob/CardputerADV/README.md) |
| [m5stack/uiflow-micropython](https://github.com/m5stack/uiflow-micropython) | Official UIFlow MicroPython firmware and board framework. | Choose the ADV board build; see official device documentation. [Evidence](https://github.com/m5stack/uiflow-micropython/blob/master/README.md) |

### Launchers and Python

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [bmorcelli/Launcher](https://github.com/bmorcelli/Launcher) | Firmware launcher with SD installation, online installation and browser file management. | ADV support documented upstream; confirm the selected image and partition requirements. [Evidence](https://github.com/bmorcelli/Launcher/blob/main/README.md) |
| [jblanked/Picoware](https://github.com/jblanked/Picoware) | MicroPython environment with applications and supported-device guides. | README explicitly lists Cardputer ADV. [Evidence](https://github.com/jblanked/Picoware/blob/main/README.md) |
| [XCSTech/MicroHydra-CardputerADV-firmware](https://github.com/XCSTech/MicroHydra-CardputerADV-firmware) | ADV port binaries for MicroHydra. | Port documents TCA8418 keyboard and ES8311 audio; BMI270 not integrated according to README. [Evidence](https://github.com/XCSTech/MicroHydra-CardputerADV-firmware/blob/main/README.md) |
| [XCSTech/Cardputer-adv-microhydra](https://github.com/XCSTech/Cardputer-adv-microhydra) | Source repository linked by the ADV MicroHydra binary project. | Port source; follow the paired firmware project for ADV-specific status. [Evidence](https://github.com/XCSTech/Cardputer-adv-microhydra/blob/main/README.md) |
| [echo-lalia/MicroHydra-Apps](https://github.com/echo-lalia/MicroHydra-Apps) | Community MicroHydra apps and contribution format. | Ecosystem resource: each app needs its own ADV compatibility check. [Evidence](https://github.com/echo-lalia/MicroHydra-Apps/blob/main/README.md) |

### Everyday utilities

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [lxhyl/cardputer](https://github.com/lxhyl/cardputer) | UIFlow2-based launcher, BLE keyboard/mouse, vocabulary trainer, QR generator, sensors and games. | Explicit ADV target; external sensors and desktop bridge functions require additional components. [Evidence](https://github.com/lxhyl/cardputer/blob/main/README.md) |
| [KyleBing/m5stack-cardputer-sparks](https://github.com/KyleBing/m5stack-cardputer-sparks) | Sparks home control, IR automation, HID keyboard, dashboards and games. | Explicit ADV target; merged-image and filesystem layout are project-specific. [Evidence](https://github.com/KyleBing/m5stack-cardputer-sparks/blob/main/README.md) |

### Creative and games

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [CHARL3X/GLIDE-Synth-Cardputer-ADV](https://github.com/CHARL3X/GLIDE-Synth-Cardputer-ADV) | Playable pocket synth with pitch glide and generative sound presets. | README explicitly supports original v1.1 and ADV; use the correct release. [Evidence](https://github.com/CHARL3X/GLIDE-Synth-Cardputer-ADV/blob/master/README.md) |
| [acpayers-alt/raising-hell-cardputer](https://github.com/acpayers-alt/raising-hell-cardputer) | Virtual pet with life stages, mini-games and motion interaction. | Explicit ADV target; SD card required for assets. [Evidence](https://github.com/acpayers-alt/raising-hell-cardputer/blob/main/README.md) |
| [slowlane112/Esp32-Game-and-Watch](https://github.com/slowlane112/Esp32-Game-and-Watch) | Game & Watch recreation with Cardputer builds. | Cardputer subdirectory documents ADV support, including multi-screen mode; review asset rights separately. [Evidence](https://github.com/slowlane112/Esp32-Game-and-Watch/blob/main/gandw_cardputer/README.md) |

### Radio and navigation

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [DevinWatson/Cardputer-Adv-GPS-Info](https://github.com/DevinWatson/Cardputer-Adv-GPS-Info) | GPS dashboard with satellite views, tracks, maps and trip statistics. | Explicit ADV target; external GPS needed, with Cap LoRa-1262 documented. [Evidence](https://github.com/DevinWatson/Cardputer-Adv-GPS-Info/blob/main/README.md) |
| [ratspeak/rsCardputer](https://github.com/ratspeak/rsCardputer) | Reticulum/LXMF messenger and RNode host-radio modes. | Explicit ADV target; LoRa requires SX1262 cap/module. WiFi/BLE modes can operate without LoRa hardware. [Evidence](https://github.com/ratspeak/rsCardputer/blob/main/README.md) |
| [mariovirgili/Meshtastic-for-Cardputer-ADV](https://github.com/mariovirgili/Meshtastic-for-Cardputer-ADV) | Community Meshtastic ADV fork and release source. | Repository exists but default README is inherited generic Meshtastic text; independently check ADV release artifact before use. [Evidence](https://github.com/mariovirgili/Meshtastic-for-Cardputer-ADV/blob/develop/README.md) |
| [sosprz/meshcore-cardputer-adv](https://github.com/sosprz/meshcore-cardputer-adv) | Community MeshCore ADV firmware project. | Needs further verification: current README download link points to a different Wio Tracker repository. [Evidence](https://github.com/sosprz/meshcore-cardputer-adv/blob/main/README.md) |
| [RaymiiOrg/MeshCompromise](https://github.com/RaymiiOrg/MeshCompromise) | Experimental combined Meshtastic/MeshCore firmware. | Explicit ADV target; upstream says code is LLM-generated without human review and shared radio may miss messages; experimental reference only. [Evidence](https://github.com/RaymiiOrg/MeshCompromise/blob/master/README.md) |

### AI companions

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [lichen79/xiaozhi-cardputer-adv](https://github.com/lichen79/xiaozhi-cardputer-adv) | Xiaozhi voice-assistant ADV port. | Documents ES8311 audio and push-to-talk; on-device wake word unavailable due to memory constraints; network service required. [Evidence](https://github.com/lichen79/xiaozhi-cardputer-adv/blob/main/README.md) |
| [haohlin/m5stack-cardputer-adv-firmware](https://github.com/haohlin/m5stack-cardputer-adv-firmware) | Independent PlatformIO apps including Claude Desktop Buddy, Orca Buddy and RFID2 lab tools. | Explicit ADV target; README distinguishes historical/raw releases from Launcher-ready packages; maturity varies by app. [Evidence](https://github.com/haohlin/m5stack-cardputer-adv-firmware/blob/main/README.md) |

### Security tools

| Project | What it offers | ADV compatibility / limitations |
|---|---|---|
| [BruceDevices/firmware](https://github.com/BruceDevices/firmware) | ESP32 security multitool and peripheral integration reference. | ADV support documented; features may require add-on hardware and vary by image. Use security functions on authorized systems. [Evidence](https://github.com/BruceDevices/firmware/blob/main/README.md) |
| [n0xa/m5stick-nemo](https://github.com/n0xa/m5stick-nemo) | Security-awareness toolkit including USB device inspection and wireless attack detection. | README explicitly mentions ADV for BadUSB Hunter; release selection remains device-specific. [Evidence](https://github.com/n0xa/m5stick-nemo/blob/main/README.md) |

## Verification and reuse

All entries were checked against upstream README material on the collection date. A README claim does not prove a binary works. No firmware was compiled, flashed or hardware-tested. The source registry records README blob hashes as evidence identifiers, not firmware commit pins. Release links are navigation links and do not assert that a current ADV binary exists.

Before importing code, preserve each project's license, notices and attribution, and check individual asset licenses. Before flashing, identify the exact ADV image, whether it is a full-flash or application-only image, required partition layout, and backup/recovery path. Do not reuse an offset from another project. Launchers and MicroPython app runtimes are different deployment models.

The MeshCore entry with a mismatched download link and the experimental combined-mesh project are research leads, not ready-to-flash recommendations. This is a curated starting collection, not an exhaustive inventory of every Cardputer firmware.
