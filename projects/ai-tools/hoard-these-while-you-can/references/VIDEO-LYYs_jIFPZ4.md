# Supplemental Video — Uncensored / Local AI Workflow

Source:
https://youtu.be/LYYs_jIFPZ4

## Why it matters to this project

This video is useful for the Emergency AI Kit because it demonstrates three ways to use a less-restricted/open-weight model, including a fully local LM Studio path.

Useful pieces for our build:

1. **LM Studio as an alternate local runtime / GUI**
   - Runs GGUF/local models on Windows, macOS, and Linux.
   - Can expose an OpenAI-compatible local API.
   - Useful when we want a graphical model manager instead of only Ollama.

2. **Model portability**
   - The DeepSeek V4.1 Flash model page exposes quantized variants usable by llama.cpp, Ollama, and LM Studio.
   - This reinforces our plan to keep model files on separate memory cards.

3. **Local tool / agent harness ideas**
   - The video uses an agent harness plus browser/security tooling.
   - We can reuse the architecture concept later for offline coding agents and app testing.

4. **Security testing tools**
   - Nuclei and Playwright can be useful for testing apps we own or are authorized to test.
   - Keep these in a separate SECURITY-TOOLS add-on, not in the base offline AI card.

## What NOT to copy directly

- Do not make DeepSeek V4.1 Flash our default laptop model before hardware profiling.
  It is a very large 552B-backbone MoE model even though only a subset of parameters activate per token.
- Do not depend on RunPod or hosted providers for the emergency/offline card.
- Do not mix security scanners into the minimal CORE install.
- Only test systems we own or have explicit authorization to test.

## Recommended integration

### CORE
- Ollama
- whisper.cpp
- Kiwix
- ComfyUI (hardware dependent)
- checksums / manifests

### OPTIONAL LOCAL-GUI
- LM Studio
- selected GGUF models

### OPTIONAL SECURITY-TOOLS
- Playwright
- Nuclei
- local agent harness
- isolated test targets only

## Status
- [x] Video purpose identified
- [x] LM Studio relevance confirmed
- [x] DeepSeek V4.1 Flash model page confirmed
- [x] Nuclei official repository confirmed
- [ ] Add LM Studio installer to download script after target laptop profile
- [ ] Choose a laptop-sized GGUF model
- [ ] Build authorized local security test lab
