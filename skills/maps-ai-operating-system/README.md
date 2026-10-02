# MAPS Operating System Starter

Source: Pav Rusovs, “Turn Claude Code Into Your AI Operating System (4 Layers)” — https://youtu.be/Zs3faMCDYNs

## What the video teaches

MAPS separates an AI working system into four connected layers:

- **Memory:** canonical knowledge in files the owner can inspect and move.
- **Agent:** the model and its permissions, available in the environments the owner chooses.
- **Pulse:** scheduled routines that can run unattended, with run records and failure limits.
- **Screen:** a disposable view of canonical files and run records; it does not become a second source of truth.

The video describes limiting an unattended agent so it can retrieve information and prepare drafts, while blocking send, share, and delete actions. It also describes routines with schedules, run records, and failure caps. This starter demonstrates those ideas locally; it does not set up a server, scheduler, network access, or Claude/Codex permissions.

## Reusable prompt for ChatGPT or Claude

Copy everything inside this block into ChatGPT or Claude Code:

> Help me build a small, safe MAPS (Memory, Agent, Pulse, Screen) system for my actual project.
>
> **Source principle:** Treat project files as the source of truth. Keep the agent's permissions explicit. Make unattended routines narrow, scheduled only after I approve their purpose and cadence, capped after repeated failures, and recorded. Make every screen a read-only view of source files or run records so deleting the screen loses no underlying facts.
>
> **Work in this order:**
>
> 1. Inspect the current project, its instructions, files, tools, and existing automation. Do not modify anything yet. Report what is confirmed, what is missing, and the likely source of truth.
> 2. Map the project into four layers:
>    - Memory: canonical files, ownership, naming, and how facts link to sources.
>    - Agent: environments, tools, access, and explicit allow/deny rules.
>    - Pulse: each proposed routine's purpose, input, output, cadence, machine, timeout/failure cap, and recovery.
>    - Screen: the smallest view needed, with every displayed value traceable to its source file or run record.
> 3. Draft a minimal implementation plan with at least three milestones. Define a concrete verification check and rollback for each change. Do not invent devices, integrations, permissions, schedules, credentials, or project state.
> 4. Apply only reversible local changes that are within my request. Do not send, publish, share, delete, spend money, install software, create external automations, or expose private files. Treat those as blocked unless I explicitly authorize the specific action.
> 5. Verify the result: inspect changed files, run relevant checks, run one sample pulse, confirm the screen points back to source records, then remove/regenerate the screen and confirm source data remains intact. Distinguish checks you performed from checks that still need my device/account.
> 6. Report the exact files changed, commands to run, verification results, remaining assumptions, and the next smallest useful step.
>
> **Safety rules:** No unattended routine may perform an external side effect. Drafting is allowed; sending, sharing, publishing, purchasing, or deleting is not. Use least privilege. Do not place secrets in Memory files. Stop a routine after its configured consecutive-failure cap and record the stop. Never claim cross-device, scheduler, or runtime behavior is working unless it was tested in that environment.
>
> **First task:** Start with an inventory and propose one narrow MAPS slice. Wait for my approval before adding a schedule, enabling an always-on agent, or changing access permissions.

## Local starter code

Run with Python 3.10+; it uses only the standard library.

```bash
python maps_starter.py init --root ./maps-workspace
python maps_starter.py run --root ./maps-workspace
python maps_starter.py render --root ./maps-workspace
```

Then open `maps-workspace/screen/status.md`. Delete that screen file and regenerate it with `render`; the canonical Memory file and Pulse run records remain.

The included pulse only validates that the canonical JSON file exists and has the expected shape. It does not call an LLM, access the network, schedule itself, or send/share/delete anything. The policy JSON documents the intended boundary; it is not a substitute for configuring and testing the actual tool permissions of Claude Code or another agent.

## Source anchors

The transcript-backed lesson page identifies the four layers around 0:27, describes blocked send/share/delete tools and draft-only behavior around 8:30, and explains schedules, run records, failure caps, and screens reading source files around the 9:45–14:18 section. Use the video itself for full context: https://youtu.be/Zs3faMCDYNs

Creator's companion guide announcement: https://www.patreon.com/pavrus/posts/build-your-own-170513593
