# Be More Agent — Local AI Device Build Kit

Status: **SOURCE ARCHIVED / DEPLOYMENT PREPARED / NOT INSTALLED / NOT HARDWARE TESTED**

Video: https://youtu.be/l5ggH-YhuAw
Original source: https://github.com/brenpoly/be-more-agent
Upstream snapshot: 5fb755809583c8338b1205075b2d465baa9b49ef (2026-11-03 inspected)
Owner: ZeusGriffin/open-design; this is a project subfolder, **not another Obsidian vault**.

## What it does
A Raspberry Pi-based, offline-first conversational companion with wake-word capture, Whisper.cpp transcription, Gemma 3 text inference through Ollama, optional Moondream vision, Piper speech, and animated faces.

**The optional DuckDuckGo web search uses the internet.** Local model inference does not require an API key, but first installation and model downloads require internet access.

## Original software archive
The unmodified MIT-licensed text source is mirrored under 'upstream/' for audit and offline code inspection. The upstream audio/face media, ONNX model binaries, compiled engines, and downloaded LLM weights are **not copied into this public repository**; they are obtained by cloning the pinned original repository and following the installers. The original project's hardware case files, if found separately, have CC BY-NC-SA 4.0 licensing. See 'UPSTREAM_MANIFEST.md'.

## Hardware target
Recommended: Raspberry Pi 5 with **8 GB or 16 GB** RAM, 64-bit Raspberry Pi OS, cooling, power, storage (prefer SSD), microphone, speaker, and a DSI/HDMI screen. Camera optional. The original repo says Pi 4 with at least 4 GB RAM may work with reduced performance. A Pi Zero 2 W is NOT a supported target for the entire local vision+voice+LLM stack; do not replace the existing Whisplay project.

## Quick start — after choosing a separate Pi
1. Install 64-bit Raspberry Pi OS and connect keyboard/display/network.
2. Install **Ollama** using its official ARM64 Linux instructions: https://docs.ollama.com/linux or https://ollama.com/download . Review the installer before running it.
3. Clone this repo (or download this project folder), then on the Raspberry Pi:
   ~~~bash
   cd projects/hardware/be-more-agent-local
   bash scripts/prepare-pi.sh
   ~~~
   This defaults to **preflight only** and does not change anything.
4. After inspecting the script and choosing hardware:
   ~~~bash
   bash scripts/prepare-pi.sh --install
   bash scripts/check-device.sh
   cd ~/be-more-agent
   source venv/bin/activate
   python agent.py
   ~~~

Do not run the install script on a Pi Zero 2 W or on your Windows gaming PC. There is no autostart or background service configured by this kit.

## Why an extra install helper?
Upstream 'agent.py' directly calls 'whisper.cpp/build/bin/whisper-cli' with 'whisper.cpp/models/ggml-base.en.bin', but upstream 'setup.sh' does not build/download those Whisper dependencies. Our helper fills the gap using the official whisper.cpp build commands. The main text model pinned by the original 'config.json' and 'setup.sh' is **gemma3:1b** (not the outdated README example gemma:2b).

## Obsidian
Open 'obsidian/Be More Agent - Local AI Device.md'. The included Windows helper 'scripts/SAVE_TO_OBSIDIAN.ps1' imports that Markdown into an EXISTING Obsidian vault, after you select its folder. It refuses to create a new vault, skips identical copies, and sends conflicts into Needs Review rather than overwriting anything.

## Validation gate
Code and README inspected; the device image, audio hardware, microphone driver, display, models, and system integration have **not** been tested. See 'VALIDATION.md'.