# Emergency AI Kit — "Hoard These While You Can"

Source video: https://youtu.be/w48AF0xgWQY

## Goal

Prepare a portable, offline-first AI kit that can be copied to memory cards and tested on a Windows laptop. The target capabilities are:

- local chat / coding models
- offline model storage
- speech-to-text
- image generation
- offline reference knowledge (including Wikipedia)
- repeatable verification and backup

The source video is **The Emergency AI Kit Everyone Should Build**. Public indexing confirms its premise: a normal 24 GB laptop can still code, generate images, transcribe audio, and query offline knowledge without relying on the internet.

## Evidence status

The video transcript is not currently retrievable from the indexed source, so the exact identity of all six thumbnail tools is not yet treated as verified.

Visible/strongly identifiable from the supplied thumbnail:
- Hugging Face
- Ollama

The baseline kit below is built from official upstream projects that satisfy the video's stated offline capabilities. Exact video-tool matching will be added only when verified.

## Baseline portable stack

| Job | Tool | Upstream |
|---|---|---|
| Local model runtime | Ollama | https://github.com/ollama/ollama |
| Model archive / snapshots | Hugging Face Hub | https://huggingface.co/docs/huggingface_hub/en/guides/download |
| Offline transcription | whisper.cpp | https://github.com/ggml-org/whisper.cpp |
| Image generation | ComfyUI | https://github.com/Comfy-Org/ComfyUI |
| Offline Wikipedia / web archive | Kiwix | https://github.com/kiwix/kiwix-desktop |
| Portable manifests + verification | This project | local scripts in this folder |

## Caveman flow

1. Run `scripts/windows/01-download-core.ps1` while online.
2. Put the downloaded `payload` folder on the memory card(s).
3. Run `scripts/windows/02-build-checksums.ps1`.
4. At home, copy the payload to the laptop.
5. Install one component at a time.
6. Test each component before moving to the next.
7. Only after the core works, download larger models and Wikipedia/image archives.

## Karpathy flow

- Baseline first.
- One change at a time.
- Smallest model first.
- Verify output before adding complexity.
- Keep working installers/models untouched.
- Record versions, hashes, failures, and fixes.
- Never replace a working offline copy until the new copy passes the same test.

## Folders

- `docs/` — setup and memory-card plan
- `manifest/` — upstream sources and status
- `scripts/windows/` — downloader, checksum, and copy helpers
- `obsidian/` — vault-ready markdown
- `payload/` — generated locally; intentionally not committed because installers/models are large

## Current state

- [x] Source video identified
- [x] Offline capability map verified
- [x] Official upstream projects selected
- [x] Memory-card layout prepared
- [x] Windows downloader prepared
- [x] Checksum workflow prepared
- [x] Obsidian-ready note prepared
- [ ] Exact six video tools verified
- [ ] Laptop hardware profiled
- [ ] Heavy model files downloaded
- [ ] Offline laptop smoke test completed

**Do not commit large model weights, installers, ZIM files, or generated payloads to GitHub.**
