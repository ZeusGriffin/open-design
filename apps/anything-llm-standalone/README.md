# AnythingLLM — Standalone App Launcher

**An independently runnable deployment of the upstream AnythingLLM application, not a mockup or rewritten clone.**

- Original source: https://github.com/Mintplex-Labs/anything-llm
- Official downloads: https://anythingllm.com/download
- Documentation: https://docs.anythingllm.com
- Upstream Docker instructions: https://github.com/Mintplex-Labs/anything-llm/blob/master/docker/HOW_TO_USE_DOCKER.md
- Upstream license: MIT — see https://github.com/Mintplex-Labs/anything-llm/blob/master/LICENSE

## Requirements

- Docker Desktop (Windows/macOS) or Docker Engine + Compose plugin (Linux), running.
- Internet connection to pull the upstream image and first model, and enough disk space (upstream recommends at least 10 GB for the Docker deployment; models can use more).
- A supported local model or a separately configured external provider. This package enables the *optional built-in local model engine*; first-run onboarding lets you choose/download a model.

## Start the app

**Windows:** Unzip the entire folder to a normal location, start Docker Desktop, and double-click `start.cmd`. Or run `start.ps1` in PowerShell. Wait for the service to finish starting, then open http://localhost:3001.

**Linux/macOS:** From the extracted folder, run `bash start.sh`, then open http://localhost:3001.

**Stop:** Run `stop.cmd` on Windows, or `bash stop.sh` on Linux/macOS. Alternatively, `docker compose -f compose.yaml down`.

**Update image:** Run the start script again to pull the current upstream image and restart it. Before major upgrades, back up the `data` folder. The `latest` image may introduce breaking changes; pin the image to a tested release for reproducible production setups.

## Data, compatibility, and safety

- All app state, uploaded documents, downloaded models, and configuration live in `./data` and persist across restarts. **Back up this folder.** Do not commit it; `.gitignore` excludes it.
- This package only binds the app to **127.0.0.1:3001** (this computer). It is not accessible from your phone or home network by default. Do not expose it publicly without setting up authentication and appropriate network security.
- A fresh, random `JWT_SECRET` is generated into `data/.env` on first start; do not publish that file.
- Upstream's Docker example gives the container `SYS_ADMIN` for additional functionality. **This launcher intentionally does not grant that elevated capability by default.** Some advanced agent/browser features may require changes. Review their risk before adding permissions.
- On Windows Docker Desktop, NVIDIA GPU acceleration of the built-in engine may require Docker Desktop's WSL2 GPU passthrough and a Compose GPU configuration; this starter works with CPU by default. Alternatively use the official Windows desktop build for simplest local installation.
- `host.docker.internal` lets the container reach an AI service hosted on the same PC if you configure one; the container itself uses `localhost:3001` for its UI.
- No app was installed on your PC by creating these files: installation occurs only when you run a launcher with Docker active.

## What is actually included?

This is a runnable **deployment/launcher bundle**. It pulls the official `mintplexlabs/anythingllm` container image at runtime. It does *not* embed the upstream app's full source code, models, installer binaries, or a running hosted service. To modify the source code, clone/fork upstream separately while preserving its MIT license and attribution.
