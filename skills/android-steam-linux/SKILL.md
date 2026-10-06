---
name: android-steam-linux
en_name: Android Steam Linux
description: >
  Set up, explain, troubleshoot, or document the experimental native ARM64 Linux Steam
  client on Android using Bannerlator. USE WHEN the user says SteamOS app on Android,
  Steam on Android, Bannerlator Steam Linux, ARM64 Proton Android, Steam Deck-style
  Android gaming, or asks to reproduce the workflow shown in the YouTube video
  https://youtu.be/aAMj92eUJIk. Treat "SteamOS app" as shorthand: this is not a full
  official SteamOS install; it is Valve's native ARM64 Linux Steam client plus Proton
  running inside Bannerlator's Linux runtime.
triggers:
  - "SteamOS app on Android"
  - "Steam on Android"
  - "Bannerlator Steam Linux"
  - "ARM64 Proton Android"
  - "Steam Deck Android"
  - "aAMj92eUJIk"
metadata:
  author: ZeusGriffin
  version: "1.0.0"
  source_video: "https://youtu.be/aAMj92eUJIk"
  source_project: "https://github.com/The412Banner/Bannerlator"
  last_verified: "2026-10-05"
od:
  mode: prototype
  surface: mobile
  design_system:
    requires: false
---

# Android Steam Linux

Reusable workflow for turning the "SteamOS is an app now" concept into a repeatable Android setup, test, and troubleshooting procedure.

## Core interpretation

Do not call this a full official SteamOS installation.

What is actually running:
- Bannerlator on Android.
- Bannerlator's Linux runtime.
- Valve's native ARM64 Linux Steam client.
- Valve ARM64 Proton for Windows games.
- Gamescope/Wayland display path.
- Turnip graphics path on Adreno GPUs.

The result can look and behave like a Steam Deck-style Steam session, but the full SteamOS operating system is not replacing Android.

## Compatibility gate

Before giving install steps, check these first:

1. Android device uses a Snapdragon/Adreno GPU.
2. Android exposes Developer options.
3. "Disable child process restrictions" can be enabled.
4. User understands the feature is experimental.
5. User has enough storage for:
   - app APK
   - about 755 MB Linux runtime
   - about 2 GB Valve ARM64 Proton
   - game files

Do not recommend this workflow for Mali, Xclipse, or PowerVR GPUs. Current Bannerlator documentation says those devices can produce audio with a black screen.

## Fresh install workflow

1. Download the current Bannerlator APK from the official GitHub releases page.
2. Use the standard APK unless the user already knows they need another package flavor.
3. Install the APK.
4. Enable Android Developer options if needed:
   - Settings
   - About phone
   - tap Build number seven times
5. Open Developer options.
6. Turn on "Disable child process restrictions".
7. Open Bannerlator.
8. Go to Contents -> Linux Runtime -> Download.
9. Allow the roughly 755 MB runtime download to finish.
10. Confirm "Steam (Linux)" appears in the games list.
11. Launch Steam (Linux).
12. Wait for Steam to download/update itself.
13. Sign in with password or Steam QR sign-in.
14. Do NOT install a game yet.
15. Wait for "Proton Experimental (ARM64)" to download.
16. If Steam asks for internal storage vs SD card, choose a location and start the Proton download.
17. If no dialog appears, check Steam Downloads.
18. Wait for Steam to restart itself after Proton finishes.
19. Only after Steam reopens automatically should the user install a game.
20. Launch a small known-compatible game first.

## Critical rule

Never install the first test game before the ARM64 Proton download completes and Steam performs its automatic restart.

If the user installs a game too early, Steam can pull a wrong tool chain and the game may silently fail.

## Recommended first test

Use a small, non-critical game first.

Verification checklist:
- Steam client opens.
- User can sign in.
- Library loads.
- Proton Experimental (ARM64) finishes downloading.
- Steam restarts itself.
- Game installs.
- Game launches.
- Controller input works.
- Audio works.
- Session can exit and relaunch.

Do not claim a game or device is verified unless the user or a cited upstream report confirms it.

## Default settings guidance

Start conservative:
- Steam Linux resolution: 720p.
- Steam Deck mode: OFF.
- Default bundled Turnip driver first.
- No frame generation for the first test.
- No custom Proton build for the first test.

After a successful baseline, change one variable at a time.

## Optional tuning

After baseline success:
- Change resolution.
- Try scaling modes: Auto, Integer, Fit, Fill, Stretch.
- Try scaling filters: Linear, Nearest, Pixel, FSR, NIS, SGSR.
- Compare alternate Linux Turnip drivers.
- Try GE-Proton or proton-cachyos ARM64 builds.
- Enable HUD.
- Test DirectAudio.
- Test frame generation.

Every tuning change must include a before/after verification.

## Steam Deck mode warning

Steam Deck mode is experimental.

Current upstream notes say:
- Steam menus can work.
- Quick Access features are partially available.
- Game controller input can break in Deck mode.

Default instruction: leave Steam Deck mode OFF unless testing that feature specifically.

## Existing Bannerlator games

Bannerlator can expose Games-tab entries inside Steam as Non-Steam games.

Important:
- saves may be shared
- do not launch the same game in Bannerlator and Steam at the same time
- a game that works under Bannerlator's normal Wine/FEX path may fail under Valve Proton

Treat the two launch paths as separate compatibility targets.

## Troubleshooting order

Always troubleshoot in this order:

1. GPU compatibility.
2. Child process restriction setting.
3. Linux Runtime complete.
4. ARM64 Proton complete.
5. Steam automatic restart completed.
6. Steam Deck mode OFF.
7. Baseline 720p/default driver.
8. Controller path.
9. Audio path.
10. Per-game compatibility.

Do not start by randomly changing drivers, Proton versions, frame generation, and resolution all at once.

## Failure patterns

### Black screen with sound
Likely unsupported GPU path. Confirm GPU. Mali/Xclipse/PowerVR are not supported by the current Turnip-based runtime.

### Steam session randomly dies
Check "Disable child process restrictions".

### Game installs but silently fails
Confirm the user waited for ARM64 Proton and the automatic Steam restart before installing the game.

### Controller works in Steam menus but not in game
Confirm Steam Deck mode is OFF first.

### Audio crackle
Test DirectAudio setting and compare with the default/fallback audio path. Record which Proton build is in use.

### One game fails but Steam works
Treat as per-game Proton compatibility. Do not rebuild the whole setup immediately.

## Evidence collection

For a Bannerlator Linux Steam failure, ask for the session folder:
`Download/Bannerlator-LinuxSteam/session-<date>-<time>/`

Also record:
- device model
- SoC
- GPU
- Android version
- Bannerlator version
- Proton version
- Turnip driver
- resolution
- Steam Deck mode state
- controller model
- exact game

## Update workflow

Because Bannerlator is moving quickly, verify the latest official release notes before giving version-specific instructions.

When a new release changes setup:
1. update this skill
2. update references/SOURCES.md
3. preserve older migration notes
4. date the verification

## Agent output format

When helping a user, return:

1. Compatibility: YES / NO / UNKNOWN.
2. Smallest next action.
3. Exact tap path.
4. Verification check.
5. One fallback only if the check fails.
6. Do not overload the user with every optional tweak before baseline works.

## Source priority

Use sources in this order:
1. The412Banner/Bannerlator release notes and README.
2. WinNative upstream/collaboration notes where relevant.
3. Source video for context.
4. Community reports only as secondary evidence.

See `references/SOURCES.md`.
