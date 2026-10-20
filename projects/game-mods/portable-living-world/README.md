# Portable Living World — original prototype

This is an independently written, game-agnostic **TypeScript simulation core**, not the enRAGE mod and not yet a plug-and-play mod for any game.

## What exists now

- `core.ts`: named NPCs with faction IDs, encounter memory, per-actor affinity scores, deterministic replay, duplicate-event handling and basic dispositions.
- `demo.test.ts`: creates five fictional actors, simulates help/robbery/threat/reconciliation, serializes the log to JSON and verifies the replay.
- Six local checks passed on 2026-10-20 with TypeScript 5.8.3 / Node 22.16.0. This is **local simulator verification only**, **no real game tested**.

## Run the tests

With TypeScript (`tsc`) and Node.js installed, from this folder:

```bash
tsc --strict --target es2020 --module commonjs --skipLibCheck core.ts demo.test.ts --outDir build
node build/demo.test.js
```

Expected:

```text
PASS 6 checks: replay, ally, hostile, journal, idempotence, fresh world
npc-1: ally
npc-2: hostile
```

No third-party dependencies needed for this prototype.

## Next adapter milestone

Choose ONE game that supports offline/single-player modding, confirm its supported scripting API and version, then implement a narrow adapter for one encounter event and one observable reaction. Each game needs its own adapter; this code does not hook, inject into, or modify a game.

For original RDR2 enRAGE download and creator restrictions, see [enRAGE source record](../enrage-living-world/README.md). Do not copy the original mod files into this project.

## Current limitations

No permanent disk storage adapter, in-game event capture, faction diplomacy/wars, schedules, spawning, world map, UI, machine-learning model or NPC dialogue integration yet. Cross-game compatibility remains an engineering goal, not an established result.
