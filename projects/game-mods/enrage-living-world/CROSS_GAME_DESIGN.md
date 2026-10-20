# Portable Living World — original cross-game design brief

**Aim:** Build a NEW, independently authored simulation that lets single-player NPCs remember encounters, modify relationships, and participate in a dynamic world. This is a concept plan, NOT a port of enRAGE and not a claim that the Nexus mod can work in every game.

## Two-layer architecture

1. **Portable simulation core** (no engine or copyrighted game assets)
   - `NPC`: unique ID, faction ID, traits, relationship score and time-stamped memory list
   - `WorldEvent`: normalized occurrence ID, actor, target, place, game timestamp, type and consequences
   - `NPCMemory`: event ID, intensity, retention/expiry model, attribution confidence
   - `Faction`: members, stance, territory budget and conflicts
   - `WorldState`: versioned JSON, deterministic event reducer, save/load
   - `DecisionEngine`: selects eligible behavior from documented rules and game context
2. **Per-game adapter** (required for each game; use officially supported mod interfaces when possible)
   - Poll or receive non-sensitive in-game events
   - Map that game's actor/character IDs to persistent IDs
   - Query safe world state and consented offline save context
   - Trigger behaviors only through supported game APIs/mod tools
   - Avoid online multiplayer, anti-cheat bypass, destructive save rewriting, unsupported memory injection

## First useful prototype (no game needed)

- Run a small standalone test with five fictional NPCs and two fictional factions.
- Simulate encounters: help, theft, threat, reconciliation.
- Store event log and persist JSON through reload.
- Verify event replay produces exactly the same relationships and event count.
- Show a plain text timeline explaining why each NPC changed attitude.
- Keep names/world/data invented; no assets/code copied from any existing mod.

## Adapter qualification — when user picks a game

Check (1) platform Windows PC, (2) game version/store, (3) Story/single-player mode, (4) sanctioned scripting API/SDK, (5) event hooks available, (6) save/version compatibility, (7) mod author permissions, (8) build test/hardware evidence. A generic DLL dropped into arbitrary games will not work.

## Project boundaries

- Reference only: https://www.nexusmods.com/reddeadredemption2/mods/10967
- Do not rehost, modify, decompile, or port enRAGE files without author approval.
- Implement from independently written specifications and documentation.
- Avoid copying unique UI, character bios, in-game texts, art, datasets, code, or compiled binaries.
- Any legal/patent questions on commercial release need separate review.
- Stage gate: prototype first -> tests -> one specific game adapter -> test in game -> expand.

## Suggested build sequence

1. Write `WorldState` and event replay tests in portable TypeScript.
2. Add a small local debug inspector, no game hookup.
3. Choose a specific moddable single-player game and verify adapter feasibility.
4. Wire ONE safe event and ONE observable NPC attitude change.
5. Add factions and narrative consequence logic after validation.

**Current status (2026-10-20):** A minimal, independently authored TypeScript [simulation core and six passing local tests](../portable-living-world/README.md) is committed. No in-game adapter or game compatibility has been established.
