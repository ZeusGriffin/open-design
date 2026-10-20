# enRAGE — Living World & Nemesis System (RDR2)

**Source reference + installation record; not a mirror.**

- Official mod: https://www.nexusmods.com/reddeadredemption2/mods/10967
- Official Files/download tab: https://www.nexusmods.com/reddeadredemption2/mods/10967?tab=files
- Video supplied for research (contents not independently verified): https://youtu.be/XHNFbyUOqXU
- Author: **nicklovin99**
- Latest verified on 2026-10-20: **v0.9.5**, published 2026-10-19; approximately **1.4 MB** ZIP, marked **Early Access**
- Supported: **Red Dead Redemption 2 PC Story Mode only**
- Download status: **NOT downloaded** into this workspace; Nexus directs downloads through its authenticated website. **No mod binary is stored in GitHub.**
- Installation status: **NOT installed** or game-tested on the owner's PC.

## Distribution and reuse — important

The Nexus Mods author specifically states:
- **No uploading the mod files to other websites** (GitHub included).
- **No conversion of the mod files to other games**.
- **Permission required to modify files or reuse its assets**.

This directory intentionally contains **only independent notes and original planning**. Do not commit enRAGE ZIP/EXE/DLL or other author's assets to this repo. If a mod copy or port is desired, obtain explicit written permission directly from the author first. Independently implementing broader *concepts* for supported offline games is a distinct proposed project; do not copy protected source, text, art, compiled modules, data tables, UI, or assets.

## Official prerequisite links

1. [Script Hook RDR2 — Alexander Blade](https://www.dev-c.com/rdr2/scripthookrdr2/) — download normal package, **not SDK**.
2. [ScriptHookRDR2DotNet V2 — official releases](https://github.com/Halen84/ScriptHookRDR2DotNet-V2/releases) — **v2.2.0 or newer** per enRAGE's requirements.
3. [enRAGE v0.9.5 — Files](https://www.nexusmods.com/reddeadredemption2/mods/10967?tab=files) — obtain ZIP using your Nexus account.

## Manual installation (condensed from creator's instructions)

1. Close RDR2; back up save files and note existing mods before changing the game folder.
2. Find the directory containing `RDR2.exe`.
   - Steam default: `C:\Program Files (x86)\Steam\steamapps\common\Red Dead Redemption 2`
   - Rockstar default: `C:\Program Files\Rockstar Games\Red Dead Redemption 2`
   - Epic default: `C:\Program Files\Epic Games\RedDeadRedemption2`
3. From ScriptHookRDR2's `bin` directory, put `ScriptHookRDR2.dll` and `dinput8.dll` beside `RDR2.exe`.
4. From ScriptHookRDR2DotNet V2, put `ScriptHookRDRDotNet.asi`, `ScriptHookRDRDotNet.ini`, and `ScriptHookRDRNetAPI.dll` beside `RDR2.exe`.
5. Copy the **scripts** directory from the officially downloaded enRAGE ZIP into the RDR2 root, resulting in:
   - `scripts\NemesisMod.dll`
   - `scripts\Newtonsoft.Json.dll`
6. If Windows blocks downloaded archives/DLLs, creator suggests archive Properties -> Unblock *before extraction*; check the provenance of downloaded files before unblocking.
7. Load an existing **Story Mode** save. The first-run welcome guide should appear. Do **not** use Script Hook mod files in Red Dead Online.

For updates: close the game, use the creator's current installer if included, or update the new `scripts` directory. Preserve saves and back up configurations. Confirm current official instructions before each install.

## Verification checklist

- [ ] Official ZIP downloaded by the user from Nexus Mods (not yet).
- [ ] Script Hook files exist next to `RDR2.exe` (not checked).
- [ ] ScriptHookRDR2DotNet V2 is at least v2.2.0 (not checked).
- [ ] `scripts\NemesisMod.dll` exists (not checked).
- [ ] `scripts\Newtonsoft.Json.dll` exists (not checked).
- [ ] Story Mode boots without crash and enRAGE welcome menu appears (not checked).
- [ ] One NPC identity persists after leaving and returning (not checked).
- [ ] Save/log backup exists (not checked).

## Related plan

See [CROSS_GAME_DESIGN.md](./CROSS_GAME_DESIGN.md) for a **separate original, game-agnostic prototype** built through adapters for individual games. No claim of universal drop-in compatibility.

## Version notes

v0.9.5 adds epilogue/John Marston support, New Austin and new post-1899 factions, expanded camp and town interactions, settings improvements, and fixes. This is a rapid-development early-access release; the latest version may change.

**Source of truth:** [creator's Nexus description/changelog](https://www.nexusmods.com/reddeadredemption2/mods/10967?tab=description), checked 2026-10-20.
