"""Night City Echoes local voice companion. Runs separately from Cyberpunk 2077.

No continuous listening, cloud APIs, game writes or game process hooks.
A CET hotkey writes a small JSON request; this worker records one microphone
segment (or accepts a typed test line), uses local Ollama, and optionally
speaks the reply through the Windows default audio device.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys
import time
import urllib.error
import urllib.request
from typing import Any


PROTOCOL = 1
REQUEST_NAME = "voice_request.json"
RESPONSE_NAME = "voice_response.json"
HISTORY_NAME = "voice_history.json"
MAX_REQUEST_BYTES = 64_000
MAX_HISTORY_LINES = 20


def load_json(path: Path, max_bytes: int = 2_000_000) -> Any:
    if not path.exists() or path.stat().st_size > max_bytes:
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, UnicodeError, ValueError):
        return None


def save_json_atomic(path: Path, obj: Any) -> None:
    """Replace only this companion's JSON file, not a game binary or save."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    os.replace(tmp, path)


def validate_request(value: Any) -> dict:
    if not isinstance(value, dict) or value.get("schema") != PROTOCOL:
        raise ValueError("Invalid request schema")
    key = value.get("npc_key")
    name = value.get("npc_name")
    req_id = value.get("id")
    if not all(isinstance(v, str) and 0 < len(v) <= 200 for v in (key, name, req_id)):
        raise ValueError("Invalid request identity")
    mode = value.get("mode", "microphone")
    if mode not in ("microphone", "text"):
        raise ValueError("Unsupported mode")
    player_line = value.get("player_line", "")
    if not isinstance(player_line, str) or len(player_line) > 1000:
        raise ValueError("Invalid player text")
    if mode == "text" and not player_line.strip():
        raise ValueError("Typed test request needs player_line")
    reputation = value.get("reputation", 0)
    if not isinstance(reputation, (int, float)) or isinstance(reputation, bool):
        raise ValueError("Invalid reputation")
    return {
        "id": req_id,
        "npc_key": key,
        "npc_name": name,
        "mode": mode,
        "player_line": player_line.strip(),
        "reputation": max(-100, min(100, int(reputation))),
        "disposition": str(value.get("disposition", "neutral"))[:40],
    }


def capture_microphone(seconds: float, whisper_model: str, device: str) -> str:
    """Capture only on an explicit CET request; never keep mic open at idle."""
    try:
        import numpy as np
        import sounddevice as sd
        from faster_whisper import WhisperModel
    except ImportError as exc:
        raise RuntimeError(
            "Microphone support missing. Install voice/requirements.txt "
            "(faster-whisper, sounddevice, numpy)."
        ) from exc
    rate = 16000
    print(f"[NCE] Recording microphone for {seconds:.1f}s (one shot)...", flush=True)
    samples = sd.rec(int(rate * seconds), samplerate=rate, channels=1, dtype="float32")
    sd.wait()
    audio = np.asarray(samples).reshape(-1)
    if len(audio) < rate // 2 or float(np.max(np.abs(audio))) < 0.006:
        raise RuntimeError("No usable microphone audio detected")
    model = WhisperModel(whisper_model, device=device, compute_type="int8" if device == "cpu" else "float16")
    segments, _ = model.transcribe(audio, language="en", beam_size=3, vad_filter=True)
    transcript = " ".join(s.text.strip() for s in segments).strip()
    if not transcript:
        raise RuntimeError("Speech was not recognized")
    return transcript[:1000]


def local_chat(model: str, npc_name: str, reputation: int, disposition: str,
               memory: list[dict], player_line: str, endpoint: str = "http://127.0.0.1:11434/api/chat") -> str:
    """Calls *only* a loopback Ollama endpoint. No uploaded game telemetry."""
    system = (
        "You are a fictional Night City resident for a fan-made Cyberpunk 2077 mod. "
        f"NPC name: {npc_name[:120]}. Relationship score: {reputation}. "
        f"Disposition: {disposition}. "
        "Stay in character, reply in 1 to 3 short spoken sentences, and reflect known prior "
        "conversation if present. Do not pretend you performed a game-engine action, "
        "spawned anything, changed quests, or actually remembered events not supplied. "
        "Avoid claiming you can see or hear the player beyond the conversation text. "
        "No labels or stage directions."
    )
    messages = [{"role": "system", "content": system}]
    for row in memory[-MAX_HISTORY_LINES:]:
        if isinstance(row, dict) and row.get("role") in ("user", "assistant"):
            value = row.get("content")
            if isinstance(value, str):
                messages.append({"role": row["role"], "content": value[:1000]})
    messages.append({"role": "user", "content": player_line[:1000]})
    body = json.dumps({"model": model, "messages": messages, "stream": False}).encode("utf-8")
    request = urllib.request.Request(endpoint, data=body, headers={"Content-Type": "application/json"}, method="POST")
    try:
        with urllib.request.urlopen(request, timeout=90) as response:
            parsed = json.loads(response.read(100_000).decode("utf-8"))
    except (urllib.error.URLError, TimeoutError, OSError, ValueError) as exc:
        raise RuntimeError(f"Local Ollama unavailable or model missing: {exc}") from exc
    output = parsed.get("message", {}).get("content", "")
    if not isinstance(output, str) or not output.strip():
        raise RuntimeError("Ollama returned no response")
    return output.strip()[:1000]


def speak_local(text: str) -> bool:
    """Windows SAPI via pyttsx3; voice comes from PC speakers, not NPC lips."""
    try:
        import pyttsx3
        engine = pyttsx3.init()
        engine.setProperty("rate", 178)
        engine.say(text)
        engine.runAndWait()
        engine.stop()
        return True
    except Exception as exc:
        print(f"[NCE] Windows voice playback unavailable: {exc}", file=sys.stderr)
        return False


def handle_request(value: dict, history: dict, *, model: str, whisper_model: str,
                   device: str, mic_seconds: float, enable_tts: bool,
                   endpoint: str = "http://127.0.0.1:11434/api/chat",
                   microphone_fn=None, chat_fn=None, speak_fn=None) -> tuple[dict, dict]:
    """Purely file/HTTP companion logic; dependency injection supports unit tests."""
    req = validate_request(value)
    key = req["npc_key"]
    rows = history.get(key, []) if isinstance(history.get(key), list) else []
    microphone_fn = microphone_fn or capture_microphone
    chat_fn = chat_fn or local_chat
    speak_fn = speak_fn or speak_local
    line = req["player_line"]
    if req["mode"] == "microphone":
        line = microphone_fn(mic_seconds, whisper_model, device)
    reply = chat_fn(model, req["npc_name"], req["reputation"], req["disposition"], rows, line, endpoint)
    updated = dict(history)
    updated[key] = (rows + [
        {"role": "user", "content": line},
        {"role": "assistant", "content": reply},
    ])[-MAX_HISTORY_LINES:]
    # Successful text reply is preserved even if Windows TTS fails.
    spoken = bool(speak_fn(reply)) if enable_tts else False
    return {
        "schema": PROTOCOL,
        "id": req["id"],
        "status": "ok",
        "npc_key": key,
        "npc_name": req["npc_name"],
        "heard": line,
        "reply": reply,
        "spoken": spoken,
    }, updated


def serve(mod_dir: Path, *, model: str, whisper_model: str, device: str,
          mic_seconds: float, enable_tts: bool, poll_seconds: float) -> None:
    if not mod_dir.is_dir():
        raise SystemExit(f"Mod directory does not exist: {mod_dir}")
    request_path = mod_dir / REQUEST_NAME
    response_path = mod_dir / RESPONSE_NAME
    history_path = mod_dir / HISTORY_NAME
    saved = load_json(history_path)
    history = saved if isinstance(saved, dict) else {}
    previous = load_json(response_path)
    last_id = previous.get("id") if isinstance(previous, dict) else None
    print("[NCE] Voice companion ready. Mic is OFF until a CET Talk hotkey request.", flush=True)
    print("[NCE] Press Ctrl+C here to stop. No internet/cloud speech service is used.", flush=True)
    try:
        while True:
            incoming = load_json(request_path, MAX_REQUEST_BYTES)
            if isinstance(incoming, dict) and isinstance(incoming.get("id"), str):
                req_id = incoming["id"]
                if req_id != last_id:
                    last_id = req_id
                    try:
                        response, updated = handle_request(
                            incoming, history, model=model, whisper_model=whisper_model,
                            device=device, mic_seconds=mic_seconds, enable_tts=enable_tts,
                        )
                        save_json_atomic(history_path, updated)
                        history = updated
                        print(f"[NCE] {response['npc_name']}: {response['reply']}", flush=True)
                    except Exception as exc:
                        response = {"schema": PROTOCOL, "id": req_id, "status": "error", "error": str(exc)[:700]}
                        print(f"[NCE] Error: {exc}", file=sys.stderr, flush=True)
                    save_json_atomic(response_path, response)
            time.sleep(poll_seconds)
    except KeyboardInterrupt:
        print("\n[NCE] Voice companion stopped. Microphone is closed.", flush=True)


def cli(argv=None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Night City Echoes local speech companion (opt-in)")
    p.add_argument("--mod-dir", type=Path, required=True, help="Installed CET NightCityEchoes directory")
    p.add_argument("--model", default="llama3.2:3b", help="Locally installed Ollama model")
    p.add_argument("--whisper-model", default="base", help="Offline faster-whisper model")
    p.add_argument("--device", choices=("cpu", "cuda"), default="cpu")
    p.add_argument("--mic-seconds", type=float, default=6.0)
    p.add_argument("--no-tts", action="store_true", help="Disable Windows text-to-speech")
    p.add_argument("--poll-seconds", type=float, default=0.25)
    args = p.parse_args(argv)
    if not 1 <= args.mic_seconds <= 20:
        p.error("mic-seconds must be between 1 and 20")
    if not 0.1 <= args.poll_seconds <= 5:
        p.error("poll-seconds must be between 0.1 and 5")
    return args


if __name__ == "__main__":
    args = cli()
    serve(args.mod_dir.expanduser().resolve(), model=args.model, whisper_model=args.whisper_model,
          device=args.device, mic_seconds=args.mic_seconds,
          enable_tts=not args.no_tts, poll_seconds=args.poll_seconds)
