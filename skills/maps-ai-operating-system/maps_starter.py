#!/usr/bin/env python3
"""Local, dependency-free MAPS starter. This is a demo scaffold, not an agent."""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

DEFAULT_ROOT = Path("maps-workspace")
FOLDER_NAMES = ("memory", "agent", "pulse/runs", "screen")


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def iso_now() -> str:
    return utc_now().isoformat(timespec="seconds")


def write_json_if_missing(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def initialize(root: Path) -> None:
    root.mkdir(parents=True, exist_ok=True)
    for name in FOLDER_NAMES:
        (root / name).mkdir(parents=True, exist_ok=True)

    write_json_if_missing(root / "memory/canonical.json", {
        "updated_at": iso_now(),
        "items": []
    })
    write_json_if_missing(root / "agent/policy.json", {
        "mode": "local_demo",
        "allow": ["read_project_files", "write_run_records", "render_local_screen"],
        "deny": ["send", "share", "publish", "delete", "purchase", "external_network"],
        "note": "Documentation only; configure real agent permissions separately."
    })
    write_json_if_missing(root / "pulse/routines.json", {
        "routines": [{
            "id": "validate_memory",
            "enabled": True,
            "description": "Check that canonical memory is valid JSON with an items list.",
            "max_consecutive_failures": 3
        }]
    })
    write_json_if_missing(root / "pulse/state.json", {
        "consecutive_failures": 0,
        "halted": False
    })
    print(f"Initialized MAPS workspace at {root.resolve()}")


def record_run(root: Path, status: str, message: str) -> Path:
    runs = root / "pulse/runs"
    runs.mkdir(parents=True, exist_ok=True)
    stamp = utc_now().strftime("%Y%m%dT%H%M%SZ")
    path = runs / f"{stamp}.json"
    path.write_text(json.dumps({
        "routine": "validate_memory",
        "timestamp": iso_now(),
        "status": status,
        "message": message,
        "source": "memory/canonical.json"
    }, indent=2) + "\n", encoding="utf-8")
    return path


def run_pulse(root: Path) -> None:
    initialize(root)
    state_path = root / "pulse/state.json"
    state = json.loads(state_path.read_text(encoding="utf-8"))
    if state.get("halted"):
        record_run(root, "blocked", "Routine is halted at its failure cap; run reset to re-enable.")
        print("Blocked: routine is halted. Use the reset command after fixing the cause.")
        return

    try:
        data = json.loads((root / "memory/canonical.json").read_text(encoding="utf-8"))
        if not isinstance(data, dict) or not isinstance(data.get("items"), list):
            raise ValueError("canonical.json must be an object containing an items list")
        state = {"consecutive_failures": 0, "halted": False}
        state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
        path = record_run(root, "ok", f"Validated {len(data['items'])} canonical item(s).")
        print(f"Pulse succeeded; record: {path}")
    except Exception as exc:
        count = int(state.get("consecutive_failures", 0)) + 1
        config = json.loads((root / "pulse/routines.json").read_text(encoding="utf-8"))
        cap = int(config["routines"][0].get("max_consecutive_failures", 3))
        halted = count >= cap
        state = {"consecutive_failures": count, "halted": halted}
        state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
        path = record_run(root, "failed", f"{type(exc).__name__}: {exc}")
        print(f"Pulse failed ({count}/{cap}); record: {path}")
        if halted:
            print("Failure cap reached; routine halted until reset.")


def render_screen(root: Path) -> None:
    initialize(root)
    runs_dir = root / "pulse/runs"
    runs = sorted(runs_dir.glob("*.json"))
    latest = json.loads(runs[-1].read_text(encoding="utf-8")) if runs else None
    memory_path = root / "memory/canonical.json"
    memory = json.loads(memory_path.read_text(encoding="utf-8"))
    state = json.loads((root / "pulse/state.json").read_text(encoding="utf-8"))

    lines = [
        "# MAPS status",
        "",
        f"Generated: {iso_now()}",
        "",
        "This screen is a disposable view. Canonical data stays in Memory and run records stay in Pulse.",
        "",
        "## Memory",
        f"- Source: [canonical.json](../memory/canonical.json)",
        f"- Items: {len(memory['items'])}",
        "",
        "## Pulse",
    ]
    if latest:
        lines.extend([
            f"- Latest status: **{latest['status']}** at {latest['timestamp']}",
            f"- Record: [run record](../pulse/runs/{runs[-1].name})",
            f"- Detail: {latest['message']}",
        ])
    else:
        lines.append("- No run records yet. Run the pulse command.")
    lines.extend([
        f"- Consecutive failures: {state.get('consecutive_failures', 0)}",
        f"- Halted: {state.get('halted', False)}",
        "",
        "## Agent boundary",
        "- See [policy.json](../agent/policy.json). This file documents intended rules; enforce permissions in the agent itself.",
        ""
    ])
    output = root / "screen/status.md"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Rendered disposable screen at {output}")


def reset_pulse(root: Path) -> None:
    initialize(root)
    path = root / "pulse/state.json"
    path.write_text(json.dumps({
        "consecutive_failures": 0,
        "halted": False
    }, indent=2) + "\n", encoding="utf-8")
    print("Pulse failure cap reset. Fix the cause before running again.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Local MAPS starter scaffold")
    parser.add_argument("command", choices=("init", "run", "render", "reset"))
    parser.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    args = parser.parse_args()

    if args.command == "init":
        initialize(args.root)
    elif args.command == "run":
        run_pulse(args.root)
    elif args.command == "render":
        render_screen(args.root)
    elif args.command == "reset":
        reset_pulse(args.root)


if __name__ == "__main__":
    main()
