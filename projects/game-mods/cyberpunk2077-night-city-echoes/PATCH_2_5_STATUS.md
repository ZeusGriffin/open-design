# Cyberpunk 2077 Update 2.5 — Compatibility and Safety Check

**As of October 22, 2026 · Status: PARTIALLY VERIFIED; DO NOT INSTALL THE NIGHT CITY ECHOES PROTOTYPE ON PATCH 2.5 YET.**

## Verified evidence

| Component | Checked | Finding |
| --- | --- | --- |
| Cyberpunk 2077 | 2026-10-22 | CD PROJEKT RED released the Edgerunners 2 Update, **patch 2.5**. |
| Cyber Engine Tweaks (CET) | 2026-10-22 | Official `maximegmd/CyberEngineTweaks` release **v1.38.0**, published Oct. 22, explicitly lists support for game patch 2.5, executable build **3.0.88.46235**. Older CET versions are no longer supported by that release. |
| RED4ext | 2026-10-22 | The latest published release located at `WopsS/RED4ext` is **v1.30.0**, March 9, 2026. Its notes **do not explicitly confirm compatibility with patch 2.5**. Do not assume compatibility from mere presence. |
| Night City Echoes v0.2 | 2026-10-22 | Lua logic and mocked CET adapter were previously tested off-game. **No game patch 2.5 test has been run.** Real NPC AI behavior is not implemented. |
| The v0.2 Windows installer | 2026-10-22 | **SAFETY UPDATED**: when the executable metadata indicates patch 2.5 (`3.0.88.46235` or product version 2.5), installation is blocked, while uninstall and backup paths remain available. Windows execution is still untested. |

## Official links

- CDPR patch notes: https://www.cyberpunk.net/en/news/52120/check-out-whats-coming-to-night-city-in-the-edgerunners-2-update-for-cyberpunk-2077
- **CET v1.38.0 release**: https://github.com/maximegmd/CyberEngineTweaks/releases/tag/v1.38.0
- RED4ext releases (check for a 2.5 support update): https://github.com/WopsS/RED4ext/releases/latest
- Night City Echoes installer: ./installer/Install-NightCityEchoes.ps1
- Existing installation instructions: ./INSTALL-KIT.md
- Desktop Commander master prompt: ./MASTER_PROMPT_DESKTOP_COMMANDER.md

**Do not use the older, previously generated `NightCityEchoes_Cyberpunk2077_InstallReady_v0.2.zip` without updating its installer script.** That ZIP was packaged before the 2.5 safety change and may incorrectly treat installed frameworks as compatible based only on file existence. Use the latest committed GitHub installer or a freshly rebuilt package.

## Desktop Commander / Computer Use test plan

Do not modify or downgrade game files without explicit permission; do not delete existing mods or saves.

1. Locate the Cyberpunk installation and identify its actual executable version (Steam/GOG/Epic) from file metadata and/or game's main menu.
2. Inventory and back up relevant game mods, game saves, CET and RED4ext configs. Record framework versions and timestamps; do not overwrite working files.
3. Check official CET release compatibility. For **2.5**, CET **v1.38.0** explicitly states support. The 1.38.0 release does not support older game patches.
4. Check official RED4ext releases/notes for explicit **2.5** support; verify other installed native framework mods separately (Codeware, ArchiveXL, TweakXL, redscript, etc., if present).
5. If RED4ext or other required framework support is **unverified**, stop installation. Do not bypass the compatibility gate or inject older DLLs into the updated game.
6. After official framework support is verified, test a clean game start and CET overlay FIRST. Then independently confirm Night City Echoes script starts, capture hotkey works, journal can write/read and restarts without errors.
7. Record logs from `bin\x64\plugins\cyber_engine_tweaks\cyber_engine_tweaks.log` and `red4ext\logs\red4ext.log` when present.
8. Do not claim 'compatible with patch 2.5' until a real in-game test succeeds on the user's PC.
9. Record evidence and test results here; update the installer gate **only after** dependencies and Night City Echoes have passed concrete checks.

## What changed in update 2.5 that may matter

CDPR includes new NPC styles/items, dual-wielding, cross-platform mod support, new quests and scripting-relevant engine updates. The introduction of official cross-platform mod support does **not** prove that Windows CET Lua plugins work on consoles or without their game-version-specific dependencies.

## Pass/fail gates

- [ ] Cyberpunk executable/game menu confirms build 2.5
- [ ] CET **1.38.0** loads with that build
- [ ] RED4ext officially supports 2.5 (or a verified alternative supported route is documented)
- [ ] Other native mods are individually compatible
- [ ] Night City Echoes loads with no CET error
- [ ] Capture hotkey obtains a persistent named NPC
- [ ] Journal writes and reloads
- [ ] Game restarts without crash and rollback available

**Conclusion on Oct. 22:** Do not claim a successful 2.5 install. The only newly established dependency compatibility is CET v1.38.0. This is an evidence-based **hold** pending remaining compatibility and actual PC testing.
