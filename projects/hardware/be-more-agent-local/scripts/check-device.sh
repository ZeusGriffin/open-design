#!/usr/bin/env bash
set -u
APP_DIR="$HOME/be-more-agent"
echo "Be More Agent device checks (no installer actions)"
echo "OS: $(uname -s)  CPU: $(uname -m)"
if [ -f /proc/meminfo ]; then grep '^MemTotal:' /proc/meminfo; fi
for exe in git python3 cmake ollama; do
  if command -v "$exe" >/dev/null 2>&1; then echo "OK command: $exe"; else echo "MISSING command: $exe"; fi
done
for file in "$APP_DIR/agent.py" "$APP_DIR/venv/bin/python" "$APP_DIR/whisper.cpp/build/bin/whisper-cli" "$APP_DIR/whisper.cpp/models/ggml-base.en.bin" "$APP_DIR/wakeword.onnx"; do
  if [ -f "$file" ]; then echo "OK file: $file"; else echo "MISSING file: $file"; fi
done
if [ -f "$APP_DIR/agent.py" ]; then
  python3 -c 'import ast,sys; ast.parse(open(sys.argv[1], encoding="utf-8").read()); print("OK: Python parse")' "$APP_DIR/agent.py" || echo "FAIL Python parse"
fi
if command -v ollama >/dev/null 2>&1; then
  echo "Ollama models:"
  ollama list || echo "Ollama service unreachable or model list unavailable."
fi
echo "Manual tests still required: microphone, speaker, Whisper WAV, Piper audio, camera, Tkinter display and wake word."
echo "Not proof of full functional operation."