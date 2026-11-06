# Reusable Build Prompt

Use this prompt with a coding agent when continuing the project.

---

You are maintaining **Phone Cluster AI Lab**, a local-first distributed LLM inference project.

## Objective

Recreate the behavior of a multi-phone LLM cluster using open-source components. The system should let a Windows PC plus phones/tablets share one open-weight model and expose it through an OpenAI-compatible local API.

## Baseline lock

Do not redesign or replace a working backend unless there is evidence that it blocks the next milestone.

Current baseline:

1. Pooled is the first backend.
2. Qwen3 1.7B is the first verification model.
3. The first success condition is a PC + one phone/tablet returning:
   PHONE-CLUSTER-OK
4. The second success condition is:
   http://127.0.0.1:8080/v1/chat/completions
   returns a valid answer from the distributed room.
5. Only after those pass should we add larger models, additional devices, a dedicated UI, or native backends.

## Engineering rules

- Evidence first.
- Change only what the current milestone requires.
- Keep upstream projects as upstream dependencies instead of copying large codebases into this repository.
- Pin versions/commits before making a reproducible release.
- Never claim hardware has been tested unless a real device test was completed.
- Record the device list, browser version, model, context size, Wi-Fi type, time-to-first-token, and tokens/second for every hardware test.
- Keep secrets out of source control.
- Default API exposure to localhost.
- Add authentication before exposing any endpoint to a LAN.
- Preserve third-party licenses and notices.

## Milestone sequence

### M1 — Device proof
Get Windows PC + one phone/tablet into one Pooled room using Qwen3 1.7B.

### M2 — API proof
Run the Pooled CLI bridge and verify /health plus /v1/chat/completions.

### M3 — Agent proof
Connect AnythingLLM or another OpenAI-compatible client and complete one real prompt.

### M4 — Measurement
Capture combined memory, model context, first-token time, and decode speed.

### M5 — Scale
Add a second mobile device and compare results to M4.

### M6 — Larger model
Test a larger model only if memory and stability justify it.

### M7 — Original control panel
Build a small local "Z Cluster" dashboard that shows:
- room status;
- connected nodes;
- model;
- context;
- API health;
- verification button;
- benchmark history.

## Before changing code

State:
1. current baseline;
2. exact blocker;
3. smallest change;
4. verification command;
5. rollback path.

Then implement only that change.
