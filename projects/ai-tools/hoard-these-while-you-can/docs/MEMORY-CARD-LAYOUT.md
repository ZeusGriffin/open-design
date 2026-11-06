# Memory-Card Layout

Use separate cards by job so one corrupted or full card does not take out the whole kit.

## CARD A — CORE

Best for the smallest/reliable card.

```text
EMERGENCY-AI-CORE/
  README-FIRST.txt
  installers/
    ollama/
    whisper/
    kiwix/
    comfyui/
  whisper-models/
  checksums/
  docs/
  scripts/
```

Purpose: installers, small transcription model, docs, scripts, hashes.

## CARD B — LLM MODELS

```text
EMERGENCY-AI-MODELS/
  ollama-models/
  huggingface-snapshots/
  model-manifest/
  checksums/
```

Purpose: large local chat/coding models.

Do not choose the final models until the laptop's RAM, GPU, VRAM, and free disk space are checked.

## CARD C — KNOWLEDGE

```text
EMERGENCY-AI-KNOWLEDGE/
  kiwix/
    wikipedia/
    stackexchange/
    docs/
  checksums/
```

Purpose: Kiwix ZIM archives. Full Wikipedia archives can be very large, so keep them separate from the core installers.

## CARD D — IMAGE / MEDIA

```text
EMERGENCY-AI-MEDIA/
  comfyui/
  models/
    checkpoints/
    vae/
    clip/
  workflows/
  checksums/
```

Purpose: ComfyUI and image-model files.

## Recommended rule

**One clean CORE card + separate heavy-content cards.**

The CORE card should remain bootstrappable even if the model/media cards are missing.

## Filesystem

For large model/ZIM files, use exFAT or NTFS rather than FAT32 because FAT32 cannot store files larger than 4 GB.

## Verification

After copying to any card, build or compare SHA-256 hashes before relying on it offline.
