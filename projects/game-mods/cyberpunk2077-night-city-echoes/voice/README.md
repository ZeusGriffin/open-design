# Night City Echoes — local NPC voice prototype (v0.1 / first game test)

**Status: source implementation prepared; no Windows install or in-game verification completed.**
Branch: `night-city-echoes-ai-voice-20261106`.
This is separate from the original memory-only game prototype and from DLSS5/VR graphics modifications.

## What this implementation does

- **Push-to-talk** using a normal Windows microphone or gaming headset. It does not listen continuously.
- **Local speech recognition** using `faster-whisper`; a six-second clip is captured after each Talk hotkey press.
- **Local conversation model** using Ollama `llama3.2:3b` on `127.0.0.1:11434`.
- **Local spoken replies** using Windows text-to-speech (`pyttsx3`) through the default speakers/headphones.
- **Individual NPC dialogue histories** stored in `voice_history.json` in the NightCityEchoes CET mod directory, keyed by the captured in-game NPC identifier.
- **Context from the memory journal:** reputation, disposition and up to six previous manual actions (helped, spared, threatened, robbed, betrayed, reconciled).
- **CET overlay feedback:** last recognized words, AI reply and errors; two distinct hotkeys for Capture NPC and Talk.

**Important limitations:** This makes a companion voice speak on your PC; it does **not** inject speech into Cyberpunk's dialogue pipeline, animate the NPC's lips, add dynamic quests, change NPC combat AI, or guarantee stable identities for generated pedestrians. The mod has not yet been verified in the running game. AI dialogue may invent details; only our supplied journal events are authoritative.

## Prerequisites — verify before installing

1. Cyberpunk 2077 **patch 2.5** on Windows. Installer is version-gated to 2.5.
2. Working [Cyber Engine Tweaks](https://github.com/maximegmd/CyberEngineTweaks/releases/tag/v1.38.1) with its documented [RED4ext](https://github.com/WopsS/RED4ext/releases/tag/v1.31.0) prerequisite. **Do not blindly overwrite any installed frameworks.** First prove CET overlay opens in-game. A file-existence check alone is not proof.
3. Windows **Python 3.11 or 3.12** (64-bit), pip/venv. The `py` launcher is preferred.
4. [Ollama for Windows](https://ollama.com/download/windows), running locally; the manager downloads model `llama3.2:3b` when Setup is explicitly run.
5. A Windows default recording microphone and audio playback device. Initial Python package, Whisper-model and Ollama-model setup requires an internet connection. After downloads, chat/STT/TTS stay local. No external model API key is used.

## Quick-start — after reviewing the actual PC

**Do not run from the previous v0.2/v0.3 test ZIP**: it does not contain this voice integration. Download/clone this **exact voice GitHub branch** as a complete folder, preserving both the `mod/` and `voice/` directories.

1. **Read-only installation check:** double-click `voice/CHECK_VOICE.cmd` and provide the actual Cyberpunk game folder. If your installed game is not patch 2.5, STOP.
2. **Read-only install preview:** double-click `voice/INSTALL_VOICE.cmd`, supply game folder and read preview. It will require user confirmation before any copying. The script copies only `mod/init.lua`, `mod/core.lua` and `mod/voice_bridge.lua` after verifying no third-party edits, preserving the older journal and making a dated backup in `Documents/NightCityEchoes-Backups`.
3. **Python/model setup:** double-click `voice/SETUP_VOICE.cmd`. This creates `voice/.venv` and downloads Python dependencies, Ollama model and faster-whisper base model. It does not modify the game. You must install Ollama for Windows separately if missing.
4. **Start the local companion:** double-click `voice/START_VOICE.cmd` and enter the same game folder. Leave the foreground terminal open during the test. Closing the window shuts down the voice service.
5. **No-microphone typed test:** in a *second* terminal, double-click `voice/TEST_TEXT.cmd`; it sends one local request and waits for an AI response. This verifies file bridge + Ollama + response without microphone or Cyberpunk. It can be run after installing the bridge even before launching the game.
6. **Game voice test:** start Cyberpunk, open CET, bind **Night City Echoes: Capture NPC** and **Night City Echoes: Talk to selected NPC** to different keys. Aim at an NPC; press Capture, then Talk with the overlay closed. Speak once during the six-second recording window. Reopen the CET overlay to see `You:` and the NPC reply. Listen through your Windows output device.
7. **Persistence test:** log **Helped** in the memory journal; talk again; confirm the response has access to that journal action. Quit the game, restart the foreground voice worker, restart the game, select the same persistent named NPC and check the stored history. **Random passerby IDs may change across sessions.**

If any step fails, stop; capture CET log `bin/x64/plugins/cyber_engine_tweaks/cyber_engine_tweaks.log`, red4ext log if present, Windows console output, game build, and exact file paths. Do not reinstall graphics DLLs, replace `dxgi.dll`, delete saves, downgrade the game, or overwrite any other mods.

## Direct PowerShell usage

From the repository's `voice/` folder:

```powershell
# Read-only status
powershell -NoProfile -File .\Manage-Voice.ps1 -Action Check -GamePath 'C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077'

# Explicit install preview; no writes
powershell -NoProfile -File .\Install-VoiceBridge.ps1 -GamePath 'C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077'

# Install after user has verified CET overlay; prompts for two confirmations
powershell -NoProfile -File .\Install-VoiceBridge.ps1 -GamePath 'C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077' -Install

# Python and model setup
powershell -NoProfile -File .\Manage-Voice.ps1 -Action Setup

# Foreground service
powershell -NoProfile -File .\Manage-Voice.ps1 -Action Run -GamePath 'C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077'

# Typed test in a second window
powershell -NoProfile -File .\Manage-Voice.ps1 -Action TextTest -GamePath 'C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077'
```

The game folder path is an **example**, not a verified local path.

## Local data and security

- Request/response files: `voice_request.json` and `voice_response.json`; stored in CET NightCityEchoes mod directory. They contain NPC key, name, reputation and the text of the current conversation.
- Persistent memory: `voice_history.json`; local and game-independent; **not backed up by Steam/GOG game saves**. Back it up separately. No credentials/API keys are stored.
- Recorded microphone audio is captured in memory for a single on-demand transcription window; the prototype does not write microphone audio recordings to disk.
- Speech model downloads may access the internet once during setup; normal inference uses loopback Ollama and locally cached Whisper.
- Rollback: stop game and local worker, restore the 3 Lua scripts from the dated backup; if there were no originals, remove only the newly installed 3 Lua scripts. The installer writes a `manifest.json` recording what existed previously; preserve the JSON journal and voice history.
- Never run this repo's installers as administrator unless independently required by your Windows permissions; do not disable antivirus or Windows Defender.

## Offline automated checks (no actual game)

```bash
python -m unittest discover -s voice/tests -v
python -m py_compile voice/bridge_service.py voice/send_text_test.py
cd mod
lua ../tests/test_core.lua
lua ../tests/test_adapter.lua
lua ../tests/test_voice_bridge.lua
```

These simulate an Ollama HTTP reply, the Python file protocol, Lua bridge, and original memory journal. **They do not verify Windows audio capture/playback, CET API compatibility in patch 2.5, stable NPC identities, or game runtime.** CI runs the offline tests on GitHub Actions; check its actual status before stating they passed.

## Scope after first verified game test

1. Improve selection of stable, named NPC identities to avoid attaching conversations to respawned pedestrians.
2. Optional custom voice/TTS and captions, then game-integrated audio positioning/lip-sync only if a supported game API exists.
3. Verified NPC reactions and faction behavior require separate engine event hooks and game tests; **not implemented in this voice milestone**.

**Handoff:** see `CLAUDE_COWORK_HANDOFF.md` in the project root for the precise follow-on PC installation and test instructions.
