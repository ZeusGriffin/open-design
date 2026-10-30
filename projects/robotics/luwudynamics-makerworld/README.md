# LuwuDynamics MakerWorld — Build Library

**Status:** Research and build planning (2026-10-30). **Owner:** Zeus / Made by Zeus.  
**Source profile:** https://makerworld.com/en/@LuwuDynamics  
**First requested model:** https://makerworld.com/models/3318467 (RIG-TARS)

This project collects **links, research, hardware requirements, printable-model references, firmware pointers, and reproducible build checkpoints** for the LuwuDynamics/CyberBionicMaker desktop-robot designs. It does **not** claim the robots are built or tested, and it does **not** redistribute any third-party STL/3MF files.

> **Coverage caveat:** MakerWorld blocked automated direct viewing of the creator page on 2026-10-30. The five model IDs below were independently corroborated through model-mirror descriptions and official Luwu docs. This is a verified **starter inventory, not a claim that every item on the live profile has been enumerated**. Review the live profile manually for additional listings, variants and any changes.

## Inventory and priority

| Project | MakerWorld model | Control platform | Drive | Printed files / print profile | Status |
| --- | --- | --- | --- | --- | --- |
| **RIG-TARS** (original user link) | [3318467](https://makerworld.com/models/3318467) | ESP32-S3, RIG-Omni `tars` | 3 SCS009 servos | MakerWorld; verify listing/license/revision | Plan ready, not downloaded |
| **RIG-Puppy** | [2102311](https://makerworld.com/models/2102311) | ESP32-S3, RIG-Omni `puppy` | 5 EM3 bus servos | Single-color multi-plate profile reported, Bambu A1 tuning | Plan ready, not downloaded |
| **RIG-Hover** | [2909205](https://makerworld.com/models/2909205) | ESP32-S3, RIG-Omni `hover` | 1 EM3 servo + 2 KP4012 wheel motors | Multicolor/AMS profile reported; Bambu A1 tuning | Plan ready, not downloaded |
| **RIG-Arm** | [2913469](https://makerworld.com/models/2913469) | ESP32-S3, RIG-Omni `arm` | 5 SCS009 bus servos | Multicolor/AMS profile reported; Bambu A1 tuning | Plan ready, not downloaded |
| **XGO-Duck** | [3357821](https://makerworld.com/models/3357821) | **Arduino UNO Q** (not ESP32-S3 RIG platform) | 15 Feetech 1910 servos | Printable mechanical structures also in hardware GitHub; consult original license | Plan ready, not downloaded |

### Shared firmware and documentation

- Luwu [official MakerWorld / STL note](https://wiki.xgorobot.com/kb/common-resources-en/dc036a811b7b5b80ebb8cef0f): RIG-Puppy, RIG-Hover and RIG-Arm hosted on MakerWorld; STL (not STEP). Note that later TARS and XGO-Duck model links are separately discoverable.
- [RIG-Omni firmware](https://github.com/LuwuDynamics/rig_omni): ESP-IDF 5.5.x, **board-specific** configuration for Puppy, Hover, Arm, TARS. Includes voice, display, networking, calibration and MCP tools. RIG models generally require matching ESP32-S3 hardware, **not any random ESP32-S3 breakout**.
- [RIG docs](https://wiki.xgorobot.com/kb/the-rig-series-robot): choose electronics-kit assembly vs assembled-robot path, then calibration, activation and first movement.
- [XGO-Duck hardware](https://github.com/LuwuDynamics/xgoduck_hardware), [UNO Q runtime](https://github.com/LuwuDynamics/xgoduck_runtime_arduino), [reinforcement-learning tooling](https://github.com/LuwuDynamics/xgoduck_rl). XGO-Duck is a **separate controller and wiring ecosystem**.

## Build plans

### 01 — RIG-TARS (first priority)
[3D model](https://makerworld.com/models/3318467) · [assembly](https://wiki.xgorobot.com/kb/the-rig-series-robot/rig_en_tars_assembly) · [firmware](https://github.com/LuwuDynamics/rig_omni)

1. Confirm exact revision, license, and all STL/3MF/print-profile plates directly on MakerWorld. Record print orientation, material, support use and total filament before committing to a full print.
2. Cross-check the official kit BOM and structural part names; source **matching** TARS ESP32-S3 board/controller, **three SCS009** servos, 320×240 landscape display, power, wiring and hardware **as specified by the actual kit revision**; do not treat the ESP32-S3 as a complete kit.
3. Test the electronics and official firmware before installing inside the printed body, following the [TARS assembly guide](https://wiki.xgorobot.com/kb/the-rig-series-robot/rig_en_tars_assembly).
4. Print a small fit-critical piece first; only then print the body and articulated parts. Assemble with power disconnected and verify no wire gets pinched.
5. Select `RIG-Tars` in RIG-Omni firmware, verify screen orientation and calibration, then test one safe movement and one conversation.
6. **Pass:** correct display, three actuators respond without binding, safe stop/recovery works; cloud/activation checked separately.

### 02 — RIG-Puppy
[3D model](https://makerworld.com/models/2102311) · [assembly](https://wiki.xgorobot.com/kb/the-rig-series-robot/rig_en_puppy_assembly)

1. Download the **single-color multi-plate** print profile if still available; AMS optional for the single-color workflow. Confirm actual plate, file and license.
2. Match Puppy ESP32-S3 controller, **five EM3 UART bus servos**, round 240×240 screen, camera/audio/IMU and approved battery/power configuration.
3. Bench-test connected electronics before installing into printed structure; print one leg fitting and test tolerance before full shell.
4. Follow leg orientation and waist coupling instructions; calibrate using the **Puppy-specific** guide.
5. **Pass:** all four legs and waist move safely, no servo ID conflict, one expression and conversation work.

### 03 — RIG-Hover
[3D model](https://makerworld.com/models/2909205) · [assembly](https://wiki.xgorobot.com/kb/the-rig-series-robot/rig_en_hover_assembly)

1. Verify available print profile (reported multicolor with AMS) and actual material, fit tolerances and complete mechanical inventory.
2. Match Hover ESP32-S3 controller, **two KP4012 wheel motors + one EM3 head servo**, IMU, round display and approved power kit.
3. Bench-test hardware, then print a wheel mount and test bearing/clearance before full assembly.
4. Follow model-specific wiring/ID and startup instructions; support upright during the first **2–3-second IMU initialization**, then release gradually. Do **not** apply Puppy or Arm calibration shortcuts.
5. **Pass:** correct supported startup, controlled stationary balance on a safe surface, safe shutdown, voice/display pass.

### 04 — RIG-Arm
[3D model](https://makerworld.com/models/2913469) · [assembly](https://wiki.xgorobot.com/kb/the-rig-series-robot/rig_en_arm_assembly)

1. Obtain the MakerWorld print set (reported multicolor/AMS profile) and official screw, bearing, profile and fastener count.
2. Match RIG-Arm ESP32-S3 controller, **five SCS009 bus servos**, round 240×240 display and actual cable routing and power.
3. Test electronics before assembly; print one servo mount and check fit, then build from base upward, leaving sufficient cable slack.
4. Align arm upright using the supplied calibration drawing; give the short calibration touch, **not** a long touch that may reset settings.
5. **Pass:** safe single-joint motion, clear joint limits, no binding or pinch points, correct display and first conversation.

### 05 — XGO-Duck
[3D model](https://makerworld.com/models/3357821) · [hardware, BOM and assembly guide](https://github.com/LuwuDynamics/xgoduck_hardware)

1. Use the official [hardware repo](https://github.com/LuwuDynamics/xgoduck_hardware) as the mechanical source of truth; record the active board revision (V1.1 cited as of 2026-10-26) and applicable license notices. Its structure includes STL parts and TPU-designated pieces.
2. Build parts list from the **current** [BOM](https://github.com/LuwuDynamics/xgoduck_hardware/blob/master/docs/BOM.md): **Arduino UNO Q**, Luwu expansion PCB, **15 Feetech 1910 serial servos**, battery/charger **compatible with the revision**, bearings, screws, PLA/PETG/TPU per the print docs.
3. Assemble *one leg/joint and a PCB/power bench test* first, using the V1.1 guide; verify polarity with the actual board drawing before applying power. Do not feed the 8.4V servo/battery rail into a logic/USB pin.
4. Follow the 25-page assembly guide; install the current [runtime](https://github.com/LuwuDynamics/xgoduck_runtime_arduino), then servo-ID assignment and joint-zero calibration. Only then attempt walking; save config and policies together.
5. **Pass:** all fifteen actuators respond with correct IDs, calibrated neutral positions, browser control, and one safe supervised motion. RL modifications are a later phase.

## Universal build sequence / gates

- [ ] Confirm MakerWorld listing, creator, license, revision and download permission. **Link rather than mirror restricted STL/3MF content.**
- [ ] Print source files obtained legitimately; record hashes, revision and slicer settings locally if available.
- [ ] Copy the official itemized BOM; don't purchase assumed replacements before checking connector details.
- [ ] Bench test matched electronics using the model's own guide; preserve stock firmware first.
- [ ] Print one fit-critical test part; evaluate tolerance, orientation, support removal and fit.
- [ ] Assemble unpowered, inspect cable routing, then first power-on with a safe stop method.
- [ ] Capture baseline: photos, board revision, firmware commit/hash, ESP-IDF version (if applicable), print settings and pass/fail tests.
- [ ] Only after baseline passes: experiment with modifications and optional phone/AI integration.

## Hardware reuse note

Existing ESP32-S3 boards (such as Cardputer ADV or LilyGO displays) may provide experimental code/logic components but **are not electrically or mechanically interchangeable** with proprietary motor/controller assemblies without verified power, pinout, drivers and form factor. Whisplay + Pi Zero 2 W is a distinct project. XGO-Duck requires UNO Q hardware.

## License / source provenance

- MakerWorld model licenses vary by item. Listings/mirrors report **MakerWorld Exclusive** for some items and **Standard Digital File License – Community Use** for others. These are **not general redistribution grants**; inspect current canonical MakerWorld license before copying or modifying externally.
- RIG-Omni firmware reports Apache-2.0, but check each dependency and current repository license.
- XGO-Duck builds on Pollen Robotics Microduck. Respect upstream credits, hardware repo's `LICENSING.md` and applicable file-level licenses.
- No third-party printable asset or original product photo is committed in this catalog.

## Links

- Creator profile: https://makerworld.com/en/@LuwuDynamics
- First model: https://makerworld.com/models/3318467
- Official documentation: https://wiki.xgorobot.com/kb/the-rig-series-robot
- RIG firmware: https://github.com/LuwuDynamics/rig_omni
- Duck hardware: https://github.com/LuwuDynamics/xgoduck_hardware
- MakerWorld backup descriptions for link identification (not canonical downloads):
  - https://3dgo.app/models/makerworld/3318467
  - https://3dgo.app/models/makerworld/2102311
  - https://3dgo.app/models/makerworld/2909205
  - https://3dgo.app/models/makerworld/2913469
  - https://3dgo.app/models/makerworld/3357821

**Next small step:** Verify RIG-TARS's live download/license and kit revision on MakerWorld, list its exact printable pieces and BOM, and test one fitted part before bulk printing.
