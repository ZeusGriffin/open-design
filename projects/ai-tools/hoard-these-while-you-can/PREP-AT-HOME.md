# At-Home Test — Caveman Version

## Before you leave the internet connection

Run PowerShell from this project folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\01-download-core.ps1
.\scripts\windows\02-build-checksums.ps1
```

This creates a `payload` folder and a SHA-256 list.

## Put it on memory cards

Use the card plan in `docs/MEMORY-CARD-LAYOUT.md`.

Do **not** try to cram every model onto every card. Keep one clean CORE card and put the heavy files on separate cards.

## Laptop test order

### Test 1 — files
Run:

```powershell
.\scripts\windows\03-verify-payload.ps1
```

Pass = every recorded file hash matches.

### Test 2 — Ollama
Install Ollama, then open PowerShell:

```powershell
ollama --version
```

Pass = a version prints.

Do not download a huge model first. Start with a small model after we check the laptop RAM/GPU.

### Test 3 — whisper.cpp
Extract the whisper ZIP. Confirm `whisper-cli.exe` exists.

Pass = the executable launches and the supplied Whisper model is detected.

### Test 4 — Kiwix
Extract Kiwix Desktop.

Pass = Kiwix opens without internet.

Wikipedia content is a separate ZIM download and can be much larger than the application.

### Test 5 — ComfyUI
Only use the NVIDIA portable package if the laptop has a compatible NVIDIA GPU. Otherwise use the official Desktop path documented in this project.

Pass = the UI launches locally.

## Stop condition

If any test fails, stop there. Fix that layer before adding a model or another tool.

That is the Karpathy rule for this kit: preserve the last known-good state.
