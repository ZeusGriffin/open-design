# NIGHT CITY ECHOES — Cyberpunk 2077 NPC Memory Prototype

**By 9 to 5 Studios / ZeusGriffin | v0.1 | 2026-10-20**

An independently written **Cyberpunk 2077 PC single-player** prototype for persistent NPC memories and simulated reputation. Inspired by the general idea of a world that remembers what the player does, **not a copy, modification, or port of enRAGE**.

> **Ready-to-install Windows kit:** See [INSTALL-KIT.md](./INSTALL-KIT.md) for the one-click installer, readiness check, safe uninstall, CET/RED4ext prerequisites, and verification steps. Install scripts are in [installer/](./installer/). The game installation has **not** been tested on the user's PC.

## What is implemented

- [x] Cyber Engine Tweaks (CET) Lua mod entry point (`mod/init.lua`).
- [x] Capture the NPC under the crosshair through the game's targeting system (runtime verification still needed).
- [x] CET overlay journal showing selected NPC and reputation.
- [x] Explicitly record helped, spared, threatened, robbed, betrayed, and reconciled encounters.
- [x] Per-NPC relationship levels: neutral, suspicious, ally, nemesis.
- [x] Faction-score data model (v0.1 uses **unaffiliated**; automatic faction recognition is not implemented).
- [x] Save/load JSON via CET sandbox, inside the mod directory.
- [x] Bounded event and memory history.
- [x] Local pure-Lua regression tests passed (11 assertions) plus a mocked CET startup, capture, overlay and save test (9 checks).
- [ ] **NOT YET:** Automatic encounter detection, AI reactions, revenge pursuit, faction wars, persistent actual NPC spawns, dialogue, voice, save-slot separation, or confirmed in-game runtime compatibility.

The reputation affects this mod's **journal only** at v0.1. It **does not** modify NPC behavior in the running game. NPC IDs for generated pedestrians may not be stable across streaming/game restarts; this needs in-game verification.

## Install — Windows PC

1. Install a current compatible **[Cyber Engine Tweaks](https://github.com/maximegmd/CyberEngineTweaks/releases/latest)** release for your Cyberpunk 2077 game version, following the [official installation guide](https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing). CET's dependencies, including any required RED4ext version, must match your game patch.
2. Locate your **Cyberpunk 2077** install folder (the one with `bin` and `archive`).
3. Create folder:
   `Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes\`
4. Copy **both** [mod/init.lua](./mod/init.lua) and [mod/core.lua](./mod/core.lua) into that folder. Do not copy the tests.
5. Launch an **offline Story Mode** save. Open CET overlay with your configured overlay key.
6. In CET **Bindings**, assign a hotkey to **Night City Echoes: Capture NPC** and Save.
7. In-game, aim at an NPC and press that hotkey; then open CET overlay to see the **Night City Echoes - Memory Journal** window.
8. Record an example **Helped** event, close/reopen CET, and verify it appears in the journal.
9. Restart the game and capture the **same persistent named NPC**, checking whether its reputation and memories reload. If the game generated a fresh entity ID, it may not map back to the prior profile.
10. Back up `night_city_echoes.json` before reinstalling or changing mod versions.

### Folder layout

```text
Cyberpunk 2077/
  bin/x64/plugins/cyber_engine_tweaks/mods/
    NightCityEchoes/
      init.lua
      core.lua
      night_city_echoes.json    <-- generated on first recorded encounter
```

## Testing

The core runs outside Cyberpunk with regular Lua 5.1+ (we tested using the TeX Lua interpreter):

```bash
cd projects/game-mods/cyberpunk2077-night-city-echoes/mod
texlua --luaonly ../tests/test_core.lua
```

Expected: `PASS: 11 Lua core assertions (including bounded history and invalid-save handling)`

To test a mock CET adapter without launching the game, from the `mod` folder:

```bash
texlua --luaonly ../tests/test_adapter.lua
```

Expected: `PASS: 9 mocked CET adapter checks (not tested inside Cyberpunk 2077)`

**Evidence:** Local Lua core and mocked CET tests passed on 2026-10-20; files committed to GitHub. CET actual gameplay integration, controls, target API, save serialization and game compatibility **have NOT been tested** on the user's Windows machine.

## Roadmap toward real nemesis gameplay

**Milestone A:** user verifies mod loads and capture works; inspect CET log for errors.

**Milestone B:** implement audited engine events (combat threats, deaths, mercy), stable identity across sessions, and real gang/faction mapping — test on one specific game version.

**Milestone C:** use game-supported scripts to change NPC reactions/attitudes under controlled conditions. Require a specific end-to-end test proving an NPC changes in-game behavior.

**Milestone D:** encounter schedules, world simulations, rivalries, named enemy return visits and narrative consequences, with safe rollback.

Each milestone has to be verified in game; an overlay score is not yet a complete nemesis AI system.

## References and legal boundary

- [enRAGE on Nexus Mods](https://www.nexusmods.com/reddeadredemption2/mods/10967) — reference for broad *idea only*. Author nicklovin99 prohibits uploading its files elsewhere and converting them for other games. No enRAGE binaries, assets, scripts, texts or data are included.
- [Local enRAGE reference / install instructions](../enrage-living-world/README.md)
- [CET official repository](https://github.com/maximegmd/CyberEngineTweaks)
- [CET documentation](https://wiki.redmodding.org/cyber-engine-tweaks)
- [Cyberpunk modding docs](https://wiki.redmodding.org/cyberpunk-2077-modding)

**Distribution:** This folder has only original project code and documentation. 9 to 5 Studios / ZeusGriffin — all rights reserved for this independently authored prototype; third-party frameworks/games retain their own licenses.
