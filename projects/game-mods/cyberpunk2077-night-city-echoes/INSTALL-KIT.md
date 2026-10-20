# One-click Windows install kit — v0.2 (October 20, 2026)

This kit packages the independently authored **Night City Echoes** mod (CET Lua scripts), not the original enRAGE mod. It does **not** include game files, copyrighted enRAGE assets, CET or RED4ext binaries.

## What is ready

- [`installer/Install-NightCityEchoes.ps1`](./installer/Install-NightCityEchoes.ps1) validates a local game install, checks that CET and RED4ext are present, verifies Cyberpunk is not running, backs up any current NightCityEchoes scripts/journal, and installs only `init.lua` and `core.lua` with SHA-256 verification.
- [`installer/CHECK_MY_PC.cmd`](./installer/CHECK_MY_PC.cmd) runs a dry-run with no writes.
- [`installer/INSTALL_NIGHT_CITY_ECHOES.cmd`](./installer/INSTALL_NIGHT_CITY_ECHOES.cmd) starts a confirm-before-copy installation.
- [`installer/UNINSTALL_NIGHT_CITY_ECHOES.cmd`](./installer/UNINSTALL_NIGHT_CITY_ECHOES.cmd) removes only `init.lua` and `core.lua`, leaving `night_city_echoes.json` (the journal) intact.
- Original source: [`mod/init.lua`](./mod/init.lua), [`mod/core.lua`](./mod/core.lua).
- Core tests and a mocked CET adapter smoke test: [`tests/`](./tests/).

The ChatGPT-delivered ZIP arranges the same files in a `payload/` structure. Run installers **from the extracted ZIP's top-level directory**. The scripts in this repo are text-only; for a self-contained installer assembled manually, place `installer/*.ps1` / `*.cmd` alongside `payload/bin/x64/plugins/cyber_engine_tweaks/mods/NightCityEchoes/{init.lua,core.lua}`.

## Instructions for when the PC is available

1. **Close Cyberpunk**. Identify game version on the main-menu screen; back up saves (especially if other mods are present).
2. Install or verify matching supported releases of:
   - [RED4ext official releases](https://github.com/WopsS/RED4ext/releases/latest) ([setup](https://docs.red4ext.com/getting-started/installing-red4ext))
   - [Cyber Engine Tweaks official releases](https://github.com/maximegmd/CyberEngineTweaks/releases/latest) ([setup](https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing))
   - [Microsoft x64 Visual C++ redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe) if missing.
3. **Run Cyberpunk once with CET only**. Confirm its overlay works; use Windowed Borderless display mode if the overlay doesn't appear, and check for interfering overlays.
4. Extract the complete install ZIP and double-click `CHECK_MY_PC.cmd`.
5. If paths/prerequisites show ready, double-click `INSTALL_NIGHT_CITY_ECHOES.cmd`. Type **INSTALL** only after reviewing game folder and target paths. The script won't touch other mods or the game's exe.
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
