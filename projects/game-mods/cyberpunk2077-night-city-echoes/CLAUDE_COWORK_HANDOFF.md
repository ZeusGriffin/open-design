# Night City Echoes — Claude Cowork handoff (do not execute until the user authorizes it)

**Prepared:** November 6, 2026
**Owner:** ZeusGriffin / 9 to 5 Studios
**GitHub:** https://github.com/ZeusGriffin/open-design
**Implementation branch:** `night-city-echoes-ai-voice-20261106`
**Project path:** `projects/game-mods/cyberpunk2077-night-city-echoes/`
**Local implementation notes:** [voice/README.md](voice/README.md)

## Task for Claude when the user starts the handoff

Inspect the user's actual Windows PC, determine the precise Cyberpunk 2077 game install and game patch, inspect existing CET and RED4ext versions/logs, preserve ALL existing mods and the DLSS5/RenoDX/ReShade/OptiScaler/Streamline/VR stack, and make a read-only manifest of relevant file paths, hashes and existing NightCityEchoes files. Do **not** assume the user's older Steam location still exists. Do not downgrade the game, replace any graphics DLL, alter saves, or touch unrelated mod folders.

Audit the isolated GitHub voice branch against main; run its offline Python tests and mock Lua tests. If there are unexpected changes or already installed custom NightCityEchoes Lua files, stop and describe a minimal safe merge; do not overwrite blindly.

For **patch 2.5 only**, after checking CET 1.38.1 and RED4ext 1.31.0 according to their official release notes, launch flat game and confirm CET overlay works before installation. Do not assume that framework file presence equals a working installation. If hardware/game access is not available, report that explicitly.

Then follow `voice/README.md`: run the voice installer **preview first**, confirm source hashes and backup plan, install memory+voice Lua files only with explicit user authorization, install local Python environment + Ollama + Whisper models, run typed text request test, then try microphone push-to-talk and Windows TTS. Finally, test NPC capture, manual Helped/Threatened event, prior-encounter context, persisted conversation by NPC key and game restart (prefer a named NPC; generic pedestrian identity may be unstable).

For EVERY test, record **Pass / Fail / Not run**, exact evidence (console, logfile excerpt or game screenshot), framework versions, installed source hashes, and backup/rollback paths. Send a concise completion report and update only the same feature branch or a new review branch with any actual findings. Do not merge to main, claim installation, or say that real NPC lip-sync or autonomous AI reactions are implemented unless demonstrably true.

## Current implementation scope / limits

- `mod/init.lua`, `mod/voice_bridge.lua`: CET capture, overlay, Talk hotkey, local request/response bridge.
- `mod/core.lua`: original independent memory journal/reputation code, unchanged.
- `voice/bridge_service.py`: explicit microphone capture; faster-whisper STT; local Ollama AI; Windows TTS; bounded per-NPC conversation history and journal action context.
- `voice/Install-VoiceBridge.ps1`: guarded game version, frameworks and source integrity checks, preview by default, timestamped backup, copies only 3 Lua files.
- `voice/Manage-Voice.ps1` plus `.cmd` wrappers: local setup, check, foreground run, typed text smoke test.
- `voice/tests/`, `tests/test_voice_bridge.lua`, GitHub Actions: **offline/mocked tests**, not proof of actual Cyberpunk game operation.
- **Not implemented:** game voice lip-sync, game-integrated sound source, changed combat behaviors, autonomous NPC reactions, automatic quest/dialogue trees, guaranteed stable pedestrian identity.
- **No connection to the user's Windows gaming PC has been established from the current ChatGPT conversation.** No installation or microphone/game runtime test has yet been performed through this implementation session.

## Acceptance criteria

- [ ] Real Cyberpunk game patch and install path verified
- [ ] Existing graphics/VR mods inventoried; backups/rollback prepared
- [ ] CET + RED4ext truly load; CET overlay visible
- [ ] Python local companion runs, Ollama model installed, Whisper model cached
- [ ] Typed no-mic test returns a local model reply and local file response
- [ ] Talk hotkey records Windows microphone, identifies spoken words
- [ ] Heard words and AI reply appear in CET; Windows speaker plays the reply
- [ ] Manual encounter reputation informs AI conversation context
- [ ] Saved memory survives game and companion restart for stable named NPC
- [ ] No unrelated mods, saves, game or graphics files changed
- [ ] Working rollback path and test report committed to GitHub

**Do not perform the user-machine steps until they explicitly start the Claude Cowork handoff and grant its computer access.**
