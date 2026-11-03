#!/usr/bin/env bash
set -euo pipefail

UPSTREAM="https://github.com/brenpoly/be-more-agent.git"
PIN="5fb755809583c8338b1205075b2d465baa9b49ef"
APP_DIR="$HOME/be-more-agent"
mode="preflight"
if [ "$#" -gt 0 ]; then mode="$1"; fi
if [ "$mode" != "preflight" ] && [ "$mode" != "--install" ]; then
  echo "Usage: bash scripts/prepare-pi.sh [--install]"; exit 2
fi

echo "Be More Agent — separate-device preparation ($mode)"
echo "Architecture: $(uname -m)"
if command -v free >/dev/null 2>&1; then free -h | head -n 2; fi
if [ "$(uname -s)" != "Linux" ] || [ "$(uname -m)" != "aarch64" ]; then
  echo "ERROR: Full installation targets Raspberry Pi OS 64-bit (Linux aarch64)."
  exit 1
fi
memkb="$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)"
if [ "$memkb" -lt 3400000 ]; then
  echo "ERROR: Less than ~4 GB RAM detected. Use a separate Pi 4/5, not Pi Zero 2 W."
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "Git is required."; [ "$mode" = "preflight" ] && exit 0 || exit 1
fi
if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. Review/install via https://docs.ollama.com/linux before --install."
  [ "$mode" = "preflight" ] && exit 0 || exit 1
fi
if [ "$mode" = "preflight" ]; then
  echo "Read-only preflight complete. No files changed."
  echo "Next: inspect this script, then run bash scripts/prepare-pi.sh --install."
  exit 0
fi

echo "Installing missing build prerequisites..."
sudo apt-get update
sudo apt-get install -y git cmake build-essential python3-venv python3-dev wget curl pkg-config
if [ -e "$APP_DIR" ] && [ ! -d "$APP_DIR/.git" ]; then
  echo "ERROR: $APP_DIR exists but is not a Git clone; preserving it."
  exit 1
fi
if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$UPSTREAM" "$APP_DIR"
fi
if [ -n "$(git -C "$APP_DIR" status --porcelain)" ]; then
  echo "ERROR: Existing clone has local changes; will not overwrite them."
  exit 1
fi
origin="$(git -C "$APP_DIR" remote get-url origin)"
if [ "$origin" != "$UPSTREAM" ] && [ "$origin" != "https://github.com/brenpoly/be-more-agent" ]; then
  echo "ERROR: Different existing origin. Refusing to change this directory."
  exit 1
fi
git -C "$APP_DIR" fetch origin main
git -C "$APP_DIR" checkout --detach "$PIN"
cd "$APP_DIR"

echo "Building speech recognition engine that upstream setup.sh does not install..."
if [ ! -d whisper.cpp ]; then
  git clone https://github.com/ggml-org/whisper.cpp.git whisper.cpp
fi
if [ ! -f whisper.cpp/models/ggml-base.en.bin ]; then
  (cd whisper.cpp && sh ./models/download-ggml-model.sh base.en)
fi
if [ ! -x whisper.cpp/build/bin/whisper-cli ]; then
  cmake -S whisper.cpp -B whisper.cpp/build
  cmake --build whisper.cpp/build --config Release -j 2
fi

echo "Running original creator's installer (requires network access)..."
bash ./setup.sh
python3 -m py_compile agent.py
echo "Prepared in $APP_DIR; test mic/display and run foreground manually."
echo "cd \"$APP_DIR\" && source venv/bin/activate && python agent.py"