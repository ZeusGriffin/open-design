# Verification ledger (2026-10-20)

## Completed

- Original Lua memory model constructed; does not import or reuse enRAGE.
- Local Lua test runner output: `PASS: 11 Lua core assertions (including bounded history and invalid-save handling)`.
- Tests cover positive and negative events, reputation bands, faction event counting, invalid event/save protection, maximum journal size and reputation clamping.
- CET interface created using documented callbacks: `registerForEvent`, `registerHotkey`, `ImGui` and CET-local `json` + `io`.

## Not verified — do not misrepresent

- No direct access to the user's Cyberpunk installation, game runtime, save games or CET version.
- Does not yet confirm `GetLookAtObject` returns a stable NPC entity on the user's patch.
- Does not confirm `GetDisplayName` yields a localized human-readable name.
- Does not confirm a random crowd actor uses the same entity ID after streaming out/in.
- Does not automatically classify gangs; all currently map to `unaffiliated`.
- Does not hook combat AI, cause revenge behavior, or produce NPC respawns.

## First live smoke test

1. Check Cyberpunk exe version; install matching CET.
2. Verify CET overlay launches unmodified before placing new mod.
3. Copy `mod/init.lua` and `mod/core.lua` into CET's NightCityEchoes mod folder.
4. Load Story Mode; open CET console and check for `Night City Echoes v0.1 started`.
5. Bind Capture NPC in CET Bindings, then look at a known NPC and press it while overlay closed.
6. Open overlay, record 'Helped', confirm positive score.
7. Relaunch game, recapture the same NPC, check memory persistence.
8. If anything fails, preserve CET log and remove NightCityEchoes folder (no game binaries are edited).
