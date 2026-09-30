---
name: wuzplay-firmware-build
description: Build, verify and ship the Wuzplay Cyberdeck v9 firmware (Pixl.js 2.12.0, OLED, Nordic DFU) from ZeusGriffin/open-design. Use when changing the Cyberdeck app, games, screen rotation, button input or shortcuts, running or debugging the GitHub Actions build, validating the DFU zip, or reporting build status.
---

# Wuzplay firmware build

Goal: a real, compiled, installable Nordic DFU zip built by GitHub Actions. Never a mockup, source-only package or renamed file.

## Where things live

Repo `ZeusGriffin/open-design`, branch `wuzplay-cyberdeck-v9-build`, draft PR #1. Everything is under `wuzplay-cyberdeck-v9/`:

- `apply_patch.py` - board header (4 buttons), input enum, generated placeholders, registry, game list.
- `post_patch_fixes.py` - include-path dedup, font swap, base OLED rotation fix.
- `apply_features.py` - the feature layer. Copies `overlay/` into the source tree, then patches upstream files with exact-string `replace()`. A pattern that does not match aborts the run, so upstream drift is caught early.
- `overlay/` - new C files copied into the Pixl.js tree (Cyberdeck app, games, shortcuts, rotation header).
- `tests/rotation_test.c` - host unit test for screen rotation.
- `package_release.py` - builds the outer user package and README.
- Workflow: `.github/workflows/wuzplay-cyberdeck-v9.yml` (the only Wuzplay workflow).

Apply order is always: `apply_patch.py`, `post_patch_fixes.py`, `apply_features.py`, each with the Pixl.js source dir as argument.

## Build target

Upstream `solosky/pixl.js` tag `2.12.0`, `make all BOARD=OLED RELEASE=1 APP_VERSION=900`, inside the `solosky/nrf52-sdk` container. Upstream targets nRF52832 with S112 7.2.0 and packages the DFU with `--hw-version 52 --sd-req 0x0103`. Do not hide compiler errors (no `|| true`).

## Change workflow

1. Edit overlay files or `apply_features.py`. Keep changes surgical.
2. Test the patch locally without compiling: copy a clean upstream tree, run the three scripts in order, grep the result. Do this before pushing.
3. Commit, push, poll the Actions run.
4. If it fails, read the exact compiler/linker error, decide if it is upstream or ours, fix the root cause, push again. Do not comment features out.
5. Only report success after both CI jobs pass.

Polling without `gh`: the repo is public, so
`https://api.github.com/repos/ZeusGriffin/open-design/actions/runs?head_sha=<sha>` and `.../runs/<id>/jobs` work unauthenticated. Build facts (SHA-256, firmware size, warnings) are published as annotations on the `build-dfu` job at `.../check-runs/<job_id>/annotations`.

Getting the artifact without `gh`: `https://nightly.link/ZeusGriffin/open-design/actions/runs/<run_id>/Wuzplay-Cyberdeck-v9-Verified-Package.zip`. Unzip it and compare hashes with the annotations.

Add `[skip ci]` to the commit message for changes that must not trigger a rebuild (docs, skills).

## Screen orientation

One switch controls everything: `WUZ_ROTATE_180` in `board_oled.h` (patched in by `apply_features.py`).

- UI path: u8g2 rotation via `WUZ_U8G2_ROT` (`U8G2_R2` when the switch is 1).
- Game path: `JOY_OLED_*` layer in `driver.c` buffers each 128-byte page and emits it reversed using `wuz_rotate.h`.
- `WUZ_OLED_COL_OFFSET 2`: SH1106 RAM is 132 columns wide, visible 128 start at column 2. u8g2 uses this offset, so the game path must too.
- `tests/rotation_test.c` runs as its own CI job and gates the firmware build. It proves the game rotation equals a true 180 degree rotation and is not a mirror.
- On-device check: Games > SCREEN TEST and Cyber Tools > Screen test draw the same layout through the two paths. Both must read upright and match.
- If everything is upside down on the device, set `WUZ_ROTATE_180` to 0. Both paths follow.

## Input

Four buttons: 1 LEFT, 2 SELECT, 3 RIGHT, 4 BACK (assumed GPIO 8, not confirmed on hardware). `INPUT_KEY_BACK` goes up exactly one logical level. BACK is handled in Cyberdeck, games, stock list menus and the Chameleon view. Not yet handled: amiibo detail, BLE status, text input.

Shortcuts (`wuz_shortcuts.c`): bounded buffer, 450 ms gap timeout, only armed on the home screen, slot activation is scheduled with `app_sched_event_put`, never run in interrupt context.

## Embedded rules

nRF52832 class: static or flash-resident data, bounded buffers, no dynamic allocation in game loops, no Internet libraries. Missing companion files must never crash: the Cyberdeck shows built-in defaults from `cyberdeck_data.h`; a file on the device overrides them. Only use fonts the firmware actually exports (`u8g2_font_wqy12_t_gb2312a` is known good).

NFC card Details are metadata shown by the Cyberdeck. Never write text into raw `.bin` dumps. NFC preset `.bin` files are stored on the device and imported through Card Emulator / Tag Explorer; they cannot ship inside the DFU.

## Verifying the DFU

Check all of these, do not assume:

- zip opens, `manifest.json` parses, `bin_file` and `dat_file` exist and are non-empty
- filenames match the manifest
- SHA-256 of the DFU zip, the outer package, and the inner bin/dat
- the `.dat` init packet contains the expected SoftDevice requirement (`0x0103` encodes as varint `83 02`)

Read the zip in memory with Python `zipfile`. Do not unzip the install DFU inside the user package.

## Reporting rules

- Say "COMPILE VERIFIED - DEVICE TEST REQUIRED" for anything CI cannot prove. Never claim hardware testing that did not happen.
- Report only facts: commit SHA, run id, job results, firmware size, artifact name, hashes.
- Keep PR #1 a draft until the firmware boots on the device and the Screen Tests are confirmed.
- Do not merge automatically.

## Open items

- Chip and button 4 wiring are unconfirmed on hardware (build assumes nRF52832 / S112 and GPIO 8). A rejected DFU shows an error in nRF Connect or MTools; use that text to retarget.
- BACK missing in amiibo detail, BLE status and text input.
- BACK from the games list returns to the home screen, not Cyberdeck.
- Fast LEFT x5 or RIGHT x6 could still trigger a shortcut by accident.
- NFC_Pack has details and a readme but no `.bin` preset files.
- README and `DFU_VERIFICATION.json` status labels still need the device-test wording.
- The Stoic NFC card needs a real HTTPS URL in place of the placeholder.
