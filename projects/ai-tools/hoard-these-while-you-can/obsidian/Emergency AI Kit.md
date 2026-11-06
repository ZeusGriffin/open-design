---
project: Emergency AI Kit
source: https://youtu.be/w48AF0xgWQY
status: prep
date: 2026-11-06
tags:
  - local-ai
  - offline-ai
  - memory-card
  - ollama
  - whisper
  - kiwix
  - comfyui
---

# Emergency AI Kit

## Why this exists

Build a portable offline AI setup that can be stored on memory cards and tested on a Windows laptop.

Target jobs:
- code/chat locally
- transcribe audio locally
- generate images locally
- keep models offline
- browse offline reference knowledge
- verify every copied file

## Baseline stack

- Ollama — local model runtime
- Hugging Face — model snapshots/archive source
- whisper.cpp — speech-to-text
- ComfyUI — image generation
- Kiwix — offline Wikipedia/web archives

## Home test

1. Verify hashes.
2. Install Ollama.
3. Check laptop hardware before choosing large LLMs.
4. Test whisper.cpp with the small base model.
5. Open Kiwix offline.
6. Test ComfyUI only after confirming GPU compatibility.
7. Add heavy models one at a time.

## Rules

- Keep CORE separate from heavy models.
- Never overwrite the only working copy.
- SHA-256 after every card copy.
- Record model revision/license when archiving a Hugging Face repository.
- Smallest working model first.
- If a layer fails, stop and repair it before adding another layer.

## Exact-video verification

The video title and offline capability claim are confirmed, but its complete transcript is currently unavailable. Do not label all six thumbnail tools as exact matches until verified.
