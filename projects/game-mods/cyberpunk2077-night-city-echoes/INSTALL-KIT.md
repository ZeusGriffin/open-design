# Windows installation — patch 2.5 first-test kit v0.3 (November 3, 2026)

## First-test update — November 3, 2026

**Current status:** Patch 2.5 installer v0.3 and read-only installation-status preview are on branch `night-city-echoes-patch25-first-test-20261103`. On Windows, run `installer/CHECK_MY_PC.cmd` from a complete checkout of this branch (or use the prepared chat ZIP) to report whether NightCityEchoes Lua files exist and whether their hashes match the original source. **This check has not been run on the gaming PC; actual installation is unknown.**

- CET v1.38.1 is available for patch 2.5: https://github.com/maximegmd/CyberEngineTweaks/releases/tag/v1.38.1
- RED4ext v1.31.0 supports patch 2.5, but is not required for this CET-only Lua prototype: https://github.com/WopsS/RED4ext/releases/tag/v1.31.0
- Installer verifies patch 2.5 and original Lua SHA-256 hashes, backs up existing NightCityEchoes files, and requires the operator to confirm CET overlay operation before writes.
- When working from a repository checkout, it uses `mod/init.lua` and `mod/core.lua`; when working from the standalone ZIP, it uses `payload/bin/x64/plugins/cyber_engine_tweaks/mods/NightCityEchoes/`.
- It does not install CET, change game files, touch DLSS5/graphics injection DLLs, or modify unrelated mods.
- No successful in-game NPC capture, journal test, or restart persistence has been observed on the user's gaming PC. Existing dated October 22 safety notes below are historical; do not interpret them as a successful in-game test.


> [!NOTE]
> **Historical status from October 22, 2026 (superseded by first-test update above):** Cyberpunk 2077 patch 2.5 (October 22, 2026): installation on the updated game is NOT yet verified.** CET v1.38.0 explicitly supports patch 2.5, but RED4ext v1.30.0 does not yet have verified 2.5 support in its release notes, and this custom mod has no real in-game test. The GitHub installer now blocks detected patch 2.5 builds. **Do not use a pre-update v0.2 ZIP installer.** [Read the current patch status and checklist](./PATCH_2_5_STATUS.md).

This kit packages the independently authored **Night City Echoes** mod (CET Lua scripts), not the original enRAGE mod. It does **not** include game files, copyrighted enRAGE assets, CET or RED4ext binaries.

## What is ready

- [`installer/Install-NightCityEchoes.ps1`](./installer/Install-NightCityEchoes.ps1) validates a local game install, checks that CET is present, verifies Cyberpunk is not running, backs up any current NightCityEchoes scripts/journal, and installs only `init.lua` and `core.lua` with SHA-256 verification.
- [`installer/CHECK_MY_PC.cmd`](./installer/CHECK_MY_PC.cmd) runs a dry-run with no writes.
- [`installer/INSTALL_NIGHT_CITY_ECHOES.cmd`](./installer/INSTALL_NIGHT_CITY_ECHOES.cmd) starts a confirm-before-copy installation.
- [`installer/UNINSTALL_NIGHT_CITY_ECHOES.cmd`](./installer/UNINSTALL_NIGHT_CITY_ECHOES.cmd) removes only `init.lua` and `core.lua`, leaving `night_city_echoes.json` (the journal) intact.
- Original source: [`mod/init.lua`](./mod/init.lua), [`mod/core.lua`](./mod/core.lua).
- Core tests and a mocked CET adapter smoke test: [`tests/`](./tests/).

The ChatGPT-delivered ZIP arranges the same files in a `payload/` structure. Run installers **from the extracted ZIP's top-level directory**. The scripts in this repo are text-only; for a self-contained installer assembled manually, place `installer/*.ps1` / `*.cmd` alongside `payload/bin/x64/plugins/cyber_engine_tweaks/mods/NightCityEchoes/{init.lua,core.lua}`.

## Instructions for when the PC is available

1. **Close Cyberpunk**. Identify game version 2.5 on the main-menu screen; back up saves (especially if other mods are present).
2. Install or verify matching supported releases of:
   - RED4ext is **optional for this CET-only prototype**; if other mods use it, verify [their compatible RED4ext release](https://github.com/WopsS/RED4ext/releases/latest) without overwriting their configuration.
   - [Cyber Engine Tweaks official releases](https://github.com/maximegmd/CyberEngineTweaks/releases/latest) ([setup](https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing))
   - [Microsoft x64 Visual C++ redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe) if missing.
3. **Run Cyberpunk once with CET only**. Confirm its overlay works; use Windowed Borderless display mode if the overlay doesn't appear, and check for interfering overlays.
4. Extract the complete install ZIP and double-click `CHECK_MY_PC.cmd`. Check the read-only `INSTALL STATUS` line first.
5. If paths/prerequisites show ready, double-click `INSTALL_NIGHT_CITY_ECHOES.cmd`. Type **CET_OK** only after actually verifying the CET overlay works, then type **INSTALL** after reviewing game folder and target paths. The script won't touch other mods or the game's exe.
6. Open Story Mode; open CET and set the mod's `Night City Echoes: Capture NPC` hotkey. The hotkey works while the CET overlay is **closed**.
7. Aim at a person, press capture hotkey, open CET overlay, find **Night City Echoes - Memory Journal**, and click **Helped**. Confirm the score and entry.
8. Restart game and test whether this character's memory persists; anonymous/respawned NPC entity IDs might not be stable.
9. Check `bin/x64/plugins/cyber_engine_tweaks/cyber_engine_tweaks.log` for errors. The mod is **NOT confirmed functional in the real game yet**.
10. To remove, double-click `UNINSTALL_NIGHT_CITY_ECHOES.cmd`, select correct game folder and type **REMOVE**. It preserves the journal. Backups from updates go to `Documents/NightCityEchoes-Backups/`.

**If you already run a modified CET/RED4ext stack, do not reinstall these frameworks blindly.** Check their version compatibility first.

## Limits

- This is install-**ready**, not **installed**. The user's home PC has not been accessed.
- The installer has not been executed on Windows in the current workspace (Windows PowerShell unavailable here); static source/ZIP validation is all that can be performed before running it on Windows.
- The **Lua core test (11)** and **mock CET adapter checks (9)** passed locally using TeX Lua on 2026-10-20. This proves only local scripting behavior, **not** Cyberpunk in-game NPC AI reactions.
- v0.1 is a **manual NPC memory journal**, not a working revenge AI/real faction wars yet.
- The first in-game test may reveal game-patch API changes; errors should be captured from CET log and resolved before promising real nemesis gameplay.

## References

- Official Cyberpunk mod support: https://www.cyberpunk.net/en/modding-support
- Cyber Engine Tweaks installation: https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing
- RED4ext installation: https://docs.red4ext.com/getting-started/installing-red4ext
- Original enRAGE idea reference (no reuse of original files): https://www.nexusmods.com/reddeadredemption2/mods/10967
