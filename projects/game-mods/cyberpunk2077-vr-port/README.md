# CyberpunkVR Port — Quest 3 motion-controller VR

Status: **PC quick-update kit ready; installation pending** (2026-11-11)
Source video: https://youtu.be/6sDvHXDF1yM
Upstream: https://github.com/dariulone/cyberpunk-vr-port
Releases: https://github.com/dariulone/cyberpunk-vr-port/releases
Nexus: https://www.nexusmods.com/cyberpunk2077/mods/30093
Preferred manager: https://github.com/MrSurviv0r/MRSURVIV0R-S-VR-HUB/releases
Hardware target: Meta Quest 3 + Windows PC + RTX 4070 Super + Steam Cyberpunk 2077

## Goal
Play Cyberpunk 2077 in PCVR with real stereo rendering, 6-DoF head tracking, full-body VRIK, tracked motion-controlled hands, weapon aiming, physical reloads, motion melee and physical holsters. This is **not** the older Luke Ross head-aimed VR mod.

## Current verified stack — 2026-11-11
- Cyberpunk 2077: **2.5** (current PC patch).
- CyberpunkVR Port: **0.2.3**, released 2026-11-08.
- Mandatory VR dependency: **RED4ext 1.31.0 or newer**.
- OpenXR runtime must be started before the game.
- CET, ArchiveXL, TweakXL, Input Loader, Codeware and redscript are **not required by the VR port anymore**. Keep them only if other installed mods need them.
- v0.2.3 adds built-in holsters, shotgun shell handling, walkable mirrors and scene-camera smoothing.
- The port is experimental. Back up before changing an existing modded install.

## Fastest update path — preferred
If MrSurviv0r's VR HUB is already installed:
1. Close Cyberpunk 2077.
2. Open the newest VR HUB.
3. Open the **Cyberpunk 2077** card.
4. Choose **Install Update**.
5. Let the HUB detect/download the stable CyberpunkVR Port + RED4ext stack and migrate the previous VR setup.
6. Start your OpenXR runtime (Quest Link / SteamVR / Virtual Desktop VDXR).
7. Launch Cyberpunk.
8. Calibrate in the VR lobby.
9. Verify hands, aiming, reload, holsters, driving, saves and existing non-VR mods.

The HUB release notes say the Cyberpunk update flow backs up and migrates older verified VR files while preserving settings, saves and shared mods. It also checks GitHub for newer stable CyberpunkVR Port releases.

## Direct official fallback
If the HUB is unavailable, use the official upstream release:
1. Install/update RED4ext 1.31.0+.
2. Download CyberpunkVR Port 0.2.3 from the upstream GitHub Releases page.
3. Follow upstream README/UNINSTALL guidance for any legacy <=0.1.9 files.
4. Extract the release into the Cyberpunk game root (the folder containing `bin\`, `r6\` and `red4ext\`).
5. Start OpenXR first, then launch `bin\x64\Cyberpunk2077.exe`.

Use `scripts/Stage-CyberpunkVR-Update.ps1` to download the pinned official packages into a staging folder without modifying the game.

## Controls / quick reference
- Hold **L3 + R3**: VR menu.
- **F10 / Insert**: in-headset VR settings overlay.
- **F7**: recenter.
- Start the OpenXR runtime **before** the game.

## Existing baseline — preserve
Existing custom Night City Echoes install kit: [INSTALL-KIT](../cyberpunk2077-night-city-echoes/INSTALL-KIT.md).

Do not remove Night City Echoes just to install the VR port. The new VR port no longer needs CET itself, but Night City Echoes may still rely on CET and other frameworks. Keep those frameworks if another mod needs them.

## Verification checklist
- [ ] Cyberpunk reports patch 2.5
- [ ] RED4ext 1.31.0+ present
- [ ] CyberpunkVR Port 0.2.3 installed
- [ ] OpenXR runtime starts before game
- [ ] Quest 3 connects
- [ ] Both hands track independently
- [ ] Weapon aiming works
- [ ] Physical reload works
- [ ] Holsters work
- [ ] Driving works
- [ ] Save loads successfully
- [ ] Night City Echoes / other mods still work
- [ ] No competing old VR injector remains active
- [ ] Rollback files/backups exist

## Current state
Research and repository prep are complete. No claim is made that the files are already installed on the Windows PC. The next PC action is the HUB **Install Update** flow or the staged direct-official fallback.
