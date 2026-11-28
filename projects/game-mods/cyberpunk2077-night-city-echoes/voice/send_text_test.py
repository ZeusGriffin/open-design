"""Opt-in typed end-to-end test of the local Ollama bridge (no mic/game)."""
import argparse
from pathlib import Path
import secrets
import sys
import time
from bridge_service import (REQUEST_NAME, RESPONSE_NAME,
                            load_json, save_json_atomic)

p = argparse.ArgumentParser()
p.add_argument("--mod-dir", type=Path, required=True)
p.add_argument("--message", default="Hey choom. You remember me?")
args = p.parse_args()
mod_dir = args.mod_dir.expanduser().resolve()
if not mod_dir.is_dir():
    sys.exit(f"No CET mod directory: {mod_dir}")
req_id = "typed-demo-" + secrets.token_hex(6)
request = {
    "schema": 1, "id": req_id, "npc_key": "manual-test-NPC",
    "npc_name": "Demo Night City Resident", "mode": "text",
    "player_line": args.message, "reputation": 0,
    "disposition": "neutral",
}
save_json_atomic(mod_dir / REQUEST_NAME, request)
print("Typed request sent (no mic). Local companion must be running.")
for _ in range(100):
    response = load_json(mod_dir / RESPONSE_NAME)
    if isinstance(response, dict) and response.get("id") == req_id:
        print("Status:", response.get("status"))
        print("Heard:", response.get("heard", ""))
        print("NPC:", response.get("reply", response.get("error", "")))
        sys.exit(0 if response.get("status") == "ok" else 2)
    time.sleep(0.2)
sys.exit("No response within 20 seconds. Check companion console, Ollama, and folder permissions.")
