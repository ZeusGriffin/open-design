# MASTER SETUP PROMPT — Emergency AI Kit

Use this prompt when we are back at the computer and ready to work through the kit.

---

You are working inside the Emergency AI Kit project.

## Objective

Build and verify a portable local-AI setup for this Windows laptop and memory cards. Preserve working states and make the smallest useful system work before adding larger models or optional tools.

## Source projects

Core:
- Ollama
- whisper.cpp
- ComfyUI
- Kiwix Desktop
- Hugging Face model snapshots

Optional agent/testing lane:
- DeepSeek Harness
- Playwright
- Firecrawl
- dsh-firecrawl
- Nuclei
- LM Studio

## Method

### Caveman
Explain actions in plain language.
One step at a time.
Show exactly what command to run.
Show what success looks like.
If a step fails, stop there and fix it.

### Karpathy
Start with the smallest working baseline.
Make one change at a time.
Test immediately.
Keep a last-known-good state.
Do not add complexity until the current layer passes.
Prefer direct, inspectable scripts over hidden automation.

## First actions

1. Read `hardware-profile.txt`.
2. Inventory free disk space and attached memory cards.
3. Read `manifest/upstream-code.json`.
4. Confirm cloned repositories and current commit hashes.
5. Inspect installation instructions from the upstream repositories.
6. Choose a small local model appropriate for the actual RAM/VRAM.
7. Install/test Ollama or LM Studio with that one model.
8. Run one local prompt with networking disabled.
9. Test whisper.cpp on one short WAV file.
10. Test Kiwix with one small ZIM archive.
11. Only test ComfyUI after GPU compatibility is confirmed.

## Optional local-agent lane

After the core system passes:

1. Start DeepSeek Harness locally.
2. Add browser tooling only in an isolated profile.
3. Use Playwright against a local/disposable test app.
4. Add Firecrawl only when web retrieval is intentionally required.
5. Add Nuclei only for defensive testing of systems we own or have explicit authorization to test.
6. Use fake/synthetic data in the test app.
7. Keep network-facing services bound to localhost unless there is a documented reason not to.

## Verification requirements

For every component record:
- upstream URL
- version or commit SHA
- license
- install command
- storage used
- RAM/VRAM used where measurable
- network requirement
- test command
- pass/fail result
- rollback instructions

For model files record:
- model repository ID
- exact revision
- quantization
- file size
- license
- SHA-256
- runtime used
- measured load/inference result

## Safety / integrity

- Do not execute unknown scripts merely because a repository contains them.
- Do not disable endpoint protection globally.
- Do not expose local model servers to the LAN by default.
- Do not test third-party systems without permission.
- Do not overwrite the only verified copy of a model or installer.
- Do not upload private files to hosted model providers while testing the offline kit.

## Done signal

Return a concise status table:

Component | Version | Offline | Test | Result | Next action

Then give exactly one next step.
