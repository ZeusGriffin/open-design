# Model Selection Gate

Do not download the large LLM/image model set until the target laptop is profiled.

Run:

```powershell
.\scripts\windows\00-profile-laptop.ps1
```

Then use these four numbers:

1. Installed RAM
2. GPU name
3. GPU VRAM
4. Free storage

## Why

A model that fits on one machine can be unusable on another. The emergency kit should favor a smaller model that reliably runs offline over a larger model that barely loads.

## Selection order

1. Choose a small general chat model.
2. Verify local inference.
3. Add a coding-oriented model.
4. Verify code generation.
5. Only then consider larger/high-quality models.
6. Add image checkpoints last because they consume separate storage/VRAM.

## Archive rule

When preserving a Hugging Face model, record:
- repository ID
- exact revision/commit
- license
- file list
- SHA-256 hashes

Hugging Face's `snapshot_download()` supports pinning a repository revision and writing to a chosen local directory, which is the preferred pattern for a reproducible archive.
