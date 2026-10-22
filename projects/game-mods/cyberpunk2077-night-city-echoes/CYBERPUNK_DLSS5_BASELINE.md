# Cyberpunk DLSS5: baseline correction and Cyberpunk 2.5 compatibility audit

**Date:** October 22, 2026  
**Status:** Source/reference audit prepared; current Windows installation and 2.5 runtime compatibility **not verified**.  
**Purpose:** Preserve the user's **Cyberpunk DLSS5** project as the baseline before testing or installing Night City Echoes. The old Luke Ross R.E.A.L. VR setup must not be substituted for it.

## What the historical project actually establishes

- In the October 17, 2026 Cyberpunk discussion, the user stated that DLSS5 was **already present on Cyberpunk** and wanted similar functionality in another game.
- Earlier notes (September 13, 2026) describe a proposed **DLSS5 Neural Rendering / RenoDX**, RenoDX DLSS Installer, **ReShade Add-on Support**, and associated Streamline / DLSS files graphics workflow.
- Those notes do **not** identify the exact Cyberpunk installation files, active versions, hashes, selected method, current game patch, or a successful PC runtime test.
- A search of the connected `ZeusGriffin/open-design` Git tree on October 22 found **Night City Echoes** but **not** a saved standalone folder named Cyberpunk DLSS5. Another user repo, `Deep-Sea-Harness`, contains **Skyrim DLSS5** notes; those are different and must not be used as proof of a Cyberpunk installation.
- The earlier answer that treated Luke Ross as the **current** project was incorrect. Luke Ross is **older, separate VR context**. **DLSS5 is a graphics/Neural Rendering modification, not by itself a VR mod.**

## Evidence from public modding resources

- Official Cyberpunk patch 2.5 news: https://www.cyberpunk.net/en/news/52120/check-out-whats-coming-to-night-city-in-the-edgerunners-2-update-for-cyberpunk-2077
- RenoDX-community Cyberpunk DLSS5 guide: https://www.nexusmods.com/cyberpunk2077/mods/33380
  - Last updated September 1, 2026; predates Cyberpunk patch 2.5.
  - Describes **two mutually exclusive methods**: ReShade add-on or OptiScaler.
  - Describes overwriting Streamline and DLSS runtime files. **Do not perform this step** until installed files are inventoried and 2.5 compatibility is verified.
- Independent RenoDX setup guide: https://www.nexusmods.com/cyberpunk2077/mods/33457
  - Describes RenoDX installer + current community files + ReShade add-on overlay. It does not itself verify the user's current installation.
- CET v1.38.0 release explicitly supports Cyberpunk patch 2.5, but CET support does **not** establish RenoDX/OptiScaler or other graphics/VR-stack compatibility: https://github.com/maximegmd/CyberEngineTweaks/releases/tag/v1.38.0

## Non-destructive desktop inspection FIRST

1. Find the **actual** installed Cyberpunk 2077 root and game version. User previously had Steam installation at `C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077`, but **verify it still exists**.
2. Inventory `bin\x64` filenames, versions, sizes, modification dates, and SHA256 hashes before any repair. In particular look for:
   - `dxgi.dll`, `d3d12.dll`, other existing injection loaders
   - `nvngx_dlss.dll`, `nvngx_dlssg.dll`, `nvngx_dlssd.dll`, `nvngx_dlssnr.dll`
   - `sl.*.dll`, especially Streamline loader/interposer files
   - `renodx-dlss5.addon64`, `dlss5.addon64`, `ReShade.ini`, `reshade-shaders`, existing RenoDX profiles and logs
   - OptiScaler files **if** that method is installed.
3. Establish which method is active: **ReShade/RenoDX** or **OptiScaler**. Do not install or activate both indiscriminately.
4. Back up only after identifying the exact active files, using a dated copy outside the game folder; produce a manifest with hashes and a rollback route.
5. With **no file replacements**, test flat game startup on patch 2.5. If using ReShade/RenoDX, open its overlay and see whether the DLSS5 addon loads, look for missing dependencies/errors, and compare a repeatable scene before/after graphics effects if feasible.
6. If user specifically wants VR, **separately** identify its currently installed injector/tool and confirm whether VR still works. Do not assume it is Luke Ross, and do not equate DLSS5 with VR.
7. Only after DLSS5 (and separately VR, if active) has passed, test the Night City Echoes CET journal mod. Avoid overwriting any graphics root DLLs. Check CET 1.38.0 and RED4ext compatibility individually.
8. If any result is unclear, stop and report exact files, error logs, and the smallest check. Do not claim compatibility without observed evidence.

## Pass/fail checks

- [ ] Exact installed Cyberpunk version and store identified
- [ ] Existing DLSS5 method and exact component versions identified
- [ ] Inventory + SHA256 backup manifest recorded, no overwrite
- [ ] Base game boots on updated patch 2.5
- [ ] DLSS5 addon/method loads without error and effect can be confirmed
- [ ] VR support identified and independently tested if user intends VR (not assumed)
- [ ] Night City Echoes loads without altering DLSS/graphics DLLs
- [ ] Restore/rollback tested or clearly documented

## Conclusion

**Do not reinstall any VR mod or DLSS5 graphics stack based on the old Luke Ross answer.** Preserve the user's October 17 Cyberpunk DLSS5 baseline, inspect the actual files and version, and test it on patch 2.5 before introducing Night City Echoes. Source reading alone does not prove local compatibility.

## Reusable continuation prompt

> Open the **Cyberpunk DLSS5** project/workflow, not the older Luke Ross VR mod. I previously said DLSS5 was already on Cyberpunk. Inspect the real Cyberpunk folder and identify whether my setup uses RenoDX/ReShade or OptiScaler, exact DLLs and SHA256 hashes, and current game build. Back up without changing anything. Determine whether DLSS5 still works on Cyberpunk 2.5 through actual flat-game and overlay testing. If I also have an active VR runtime, identify and test it separately without guessing. Only after the existing stack passes, assess installing Night City Echoes from `ZeusGriffin/open-design/projects/game-mods/cyberpunk2077-night-city-echoes`, preserving all graphics DLLs. Verify CET/RED4ext as needed, run tests, record evidence and rollback, update GitHub, and produce a PDF containing this continuation prompt. Do not claim tested without actually running the game.
