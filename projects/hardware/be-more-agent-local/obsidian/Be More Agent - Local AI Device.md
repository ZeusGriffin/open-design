---
title: Be More Agent - Local AI Device
aliases:
  - BMO Local AI
  - Raspberry Pi Offline AI Companion
tags:
  - ai/local-model
  - hardware/raspberry-pi
  - project/prepared
  - github/open-design
created: 2026-11-03
status: prepared-not-installed
source_video: https://youtu.be/l5ggH-YhuAw
original_source: https://github.com/brenpoly/be-more-agent
github_project: https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/be-more-agent-local
---

# Be More Agent — Local AI Device

**Objective:** Build a voice-controlled on-device companion on a SEPARATE Raspberry Pi while preserving existing Pi Zero 2 W + Whisplay work.

## Source and code
- Video: https://youtu.be/l5ggH-YhuAw
- Upstream creator repository: https://github.com/brenpoly/be-more-agent
- Exact upstream snapshot: '5fb755809583c8338b1205075b2d465baa9b49ef'
- My archived source and hardware scripts: https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/be-more-agent-local
- Source is MIT; branded visuals, voice model, and separate hardware designs have their own rights/licensing.

## Local AI stack
- Gemma 3 1B via Ollama: text reasoning
- Moondream via Ollama: camera/vision (optional)
- Whisper.cpp 'base.en': speech to text
- Piper: text to speech
- OpenWakeWord: activation
- Python/Tkinter: animated expression display

No cloud API is required for the core local model. Optional internet search is NOT offline.

## Hardware
Recommended Raspberry Pi 5 (8 GB or 16 GB), 64-bit OS, cooled, USB microphone, speaker, LCD; optional camera. Pi Zero 2 W is too constrained for this full build.

## Setup when separate device is ready
1. Obtain this project folder from GitHub.
2. Install Ollama from its official ARM64 instructions.
3. Run 'bash scripts/prepare-pi.sh' for read-only hardware inspection.
4. Review and run 'bash scripts/prepare-pi.sh --install' to clone pinned source, build Whisper, install Python/Piper deps and fetch models.
5. Run 'bash scripts/check-device.sh'; start agent manually from '~/be-more-agent'.
6. Record exact test results here before enabling autostart.

## Status
- [x] Video mapped to verified original repo
- [x] Source code and install preparation added to GitHub
- [x] Obsidian-ready note prepared
- [ ] Imported to master vault on Windows
- [ ] Target hardware selected
- [ ] Deployed on target device
- [ ] Mic/speaker/display/vision tested

## Separate project links
- [[Whisplay AI Next Step]] (preserve existing priority; do not overwrite)
- [[Code Vault]] (optional later index)

## Follow-up
Select a dedicated Raspberry Pi 5 and accessories, perform first wall-powered verification, then decide on the enclosure and battery.