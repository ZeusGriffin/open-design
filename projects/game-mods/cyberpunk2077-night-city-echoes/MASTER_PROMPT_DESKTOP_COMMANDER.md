---
title: "Night City Echoes — Desktop Commander Master Prompt"
aliases:
  - "Night City Echoes Installation Prompt"
  - "Cyberpunk 2077 Nemesis Mod Prompt"
tags:
  - cyberpunk2077
  - modding
  - desktop-commander
  - obsidian
  - night-city-echoes
date: 2026-10-20
project: Night City Echoes
version: "0.2 install kit"
status: ready-for-desktop-verification
---

# MASTER PROMPT — NIGHT CITY ECHOES
## Cyberpunk 2077 | Windows Installation + Development

**Project:** Night City Echoes v0.2  
**Developer:** 9 to 5 Studios / ZeusGriffin  
**Platform:** Windows PC  
**Methods:** Karpathy Method + Caveman Mode + Evidence-First Verification

> [!important] Installation status
> Source and installer files are in GitHub. The Windows installation and in-game tests have NOT been verified. The current project is a manual NPC memory journal, not autonomous revenge AI.

> [!CAUTION]
> **Cyberpunk 2077 patch 2.5 (October 22, 2026): installation on the updated game is NOT yet verified.** CET v1.38.0 explicitly supports patch 2.5, but RED4ext v1.30.0 does not yet have verified 2.5 support in its release notes, and this custom mod has no real in-game test. The GitHub installer now blocks detected patch 2.5 builds. **Do not use a pre-update v0.2 ZIP installer.** [Read the current patch status and checklist](./PATCH_2_5_STATUS.md).

**Patch 2.5 decision rule:** First read [PATCH_2_5_STATUS.md](./PATCH_2_5_STATUS.md). Do not install on patch 2.5 until the official RED4ext support state is checked, CET v1.38.0 loads on that exact game build, and the actual NPC journal test passes. The installer's 2.5 safety gate must not be bypassed. If the PC is updated, perform only non-destructive inspection and backups until prerequisites are confirmed.

### OBJECTIVE

Connect to my Windows desktop and finish setting up **Night City Echoes**, an original Cyberpunk 2077 NPC memory and reputation mod inspired by the general concept of enRAGE for Red Dead Redemption 2.

The project has already been created and committed to GitHub.

**Main repository:**
https://github.com/ZeusGriffin/open-design

**Cyberpunk mod project:**
https://github.com/ZeusGriffin/open-design/tree/main/projects/game-mods/cyberpunk2077-night-city-echoes

**Complete installation instructions:**
https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/cyberpunk2077-night-city-echoes/INSTALL-KIT.md

**Original enRAGE reference:**
https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/enrage-living-world/README.md

Do not redistribute, copy, or port the original enRAGE files. Our Cyberpunk implementation must use independently authored code.

## Cyberpunk DLSS5 baseline correction (October 22, 2026)

**User correction:** The most recent Cyberpunk graphics project is **Cyberpunk DLSS5** (October 17), not the older Luke Ross VR setup. DLSS5/RenoDX/ReShade/OptiScaler is a graphics modification; VR must be identified and verified separately. **Before any install, use the non-destructive [Cyberpunk DLSS5 baseline audit](./CYBERPUNK_DLSS5_BASELINE.md)**: inspect the exact active files and versions, preserve backups/hashes, and verify the existing stack on patch 2.5. Do not run a graphics/DLSS installer or overwrite `dxgi.dll`, Streamline, ReShade, or existing profiles until their provenance and compatibility are established. Neither DLSS5 nor active VR functionality has been tested on the user's current machine through this chat.

### PHASE 1 — INSPECT MY COMPUTER

Use Desktop Commander to:

1. Locate my Cyberpunk 2077 installation.
2. Determine whether it is the Steam, GOG, or Epic version.
3. Inspect the installed game version.
4. Detect existing mods and mod managers.
5. Check whether Cyber Engine Tweaks (CET) is installed and functional.
6. Check RED4ext and its compatibility with my installed version.
7. Check for existing Night City Echoes files.
8. Record what is installed before changing anything.

Do not reinstall anything already working.

### PHASE 2 — PREPARE THE FILES

Retrieve the latest committed project files from my GitHub repository.

The existing package is named: NightCityEchoes_Cyberpunk2077_InstallReady_v0.2.zip

If the ZIP is unavailable on my computer, reconstruct the installation package from the verified repository files.

Do not download executable files from unofficial mirrors. Verify source files before installing.

### PHASE 3 — BACK UP AND INSTALL

1. Close Cyberpunk 2077.
2. Back up existing Night City Echoes files and any configuration that must change.
3. Preserve existing save games and unrelated mods.
4. Run the PC readiness checks.
5. Obtain compatible CET and RED4ext versions from official releases only when needed.
6. Install Night City Echoes to the game folder:
   Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes\
7. Verify that init.lua and core.lua are correctly installed.
8. Confirm checksums and record the backup location.
9. Keep an uninstall and rollback procedure ready.

If installation requires an unexpected high-risk change, explain it before proceeding.

### PHASE 4 — TEST

Run all available local tests first. Then perform a real Cyberpunk 2077 test when desktop interaction and game access permit.

Verify:

- Cyberpunk starts normally.
- CET loads without relevant errors.
- Night City Echoes loads.
- NPC capture works.
- The memory journal opens.
- Encounter choices change reputation scores.
- Journal information saves and reloads.
- Existing mods remain functional.
- Relevant error logs are collected.

Previously reported results were 11 Lua core checks and 9 mocked CET checks. Re-run them; do not treat those results as proof of in-game compatibility.

### PHASE 5 — DEVELOP THE NEMESIS SYSTEM

After the existing prototype is confirmed working, advance toward these features:

1. Automatic NPC encounter detection.
2. Persistent identities where the game supports them.
3. NPC memories of player actions.
4. Dynamic friendships and rivalries.
5. Gang and faction reputation.
6. Revenge encounters.
7. Returning enemies.
8. NPC behavioral reactions driven by remembered encounters.
9. Persistent consequences across game sessions.
10. Optional future dialogue integration.

**Important:** The current v0.2 package is primarily a manual encounter journal and reputation prototype. It does not yet provide real NPC revenge AI. Develop those features incrementally through verified Cyberpunk modding APIs.

Implement one feature at a time, run tests, and preserve the last working version.

### PHASE 6 — SAVE TO GITHUB

Use my existing repository: ZeusGriffin/open-design

Keep all Night City Echoes development under:
projects/game-mods/cyberpunk2077-night-city-echoes/

Update:

- Source code
- Installation instructions
- Version information
- Test results
- Known issues
- Rollback instructions
- Next development steps

Avoid creating another repository unless absolutely necessary.

### WORKING RULES

- Apply the Karpathy Method to nontrivial changes.
- Follow Caveman Mode: clear instructions, minimal unnecessary complexity.
- Preserve working files and user data.
- Check before replacing dependencies.
- Do not invent test results.
- Do not claim installation success until verified.
- Do not claim real in-game AI behavior until tested.
- Keep the build Windows-compatible.
- Minimize unnecessary downloads and duplicate files.
- Complete everything possible in the current session.
- If blocked, explain the exact blocker and smallest next action.

### FINAL REPORT

Tell me:

1. What was already installed.
2. What you downloaded.
3. What you installed or changed.
4. Which tests passed or failed.
5. Whether Night City Echoes works inside Cyberpunk.
6. Which Nemesis features are implemented versus planned.
7. What was committed to GitHub.
8. The smallest next step.

**START by inspecting my computer and comparing its current installation against the GitHub instructions. Do not start over or overwrite existing working mods.**

---

## Obsidian note location

This note has Obsidian YAML metadata and an Obsidian callout. Suggested vault path:

Projects/Game Mods/Cyberpunk 2077/Night City Echoes/MASTER_PROMPT_DESKTOP_COMMANDER.md

This GitHub file is the canonical version. Do not create divergent copies.
