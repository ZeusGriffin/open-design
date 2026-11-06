# Phone Cluster AI Lab

Recreate the **behavior** shown in the video **"I Turned My Spare Phones Into a Wireless GPU for AI Agents (It Actually Works)"** using open-source components.

## Current checkpoint

**Overall readiness: 55%**

`[███████████░░░░░░░░░] 55%`

- Progress tracker: [PROGRESS.md](./PROGRESS.md)
- Dated checkpoint: [CHECKPOINT_2026-11-06.md](./CHECKPOINT_2026-11-06.md)
- GitHub checkpoint PDF: [docs/Phone_Cluster_AI_Checkpoint_2026-11-06.pdf](./docs/Phone_Cluster_AI_Checkpoint_2026-11-06.pdf)
- Mobile compatibility PWA shell: [app/index.html](./app/index.html)
- Hardware benchmark record: [BENCHMARK_TEMPLATE.md](./BENCHMARK_TEMPLATE.md)

The next unverified milestone is still **PC + one iPhone/iPad + Qwen3 1.7B -> PHONE-CLUSTER-OK**. Do not restart research when resuming.

## Goal

Pool compute and memory across a Windows PC plus phones/tablets so one open-weight LLM can be split across devices, then expose the cluster through a local OpenAI-compatible API for tools such as AnythingLLM, coding agents, and custom apps.

## What the video is actually doing

The video demonstrates Private LLM's Phone Cluster feature. It does **distributed LLM inference**, not a general-purpose CUDA/GPU replacement. Different devices hold different model layers, and the hidden state is passed between devices over the local network for each token.

Private LLM's implementation is proprietary, so this project recreates the architecture using open-source software.

## Recommended first implementation: Pooled

Pooled is the best first target for a mixed-device setup because it:

- runs in browser tabs using WebGPU;
- splits model layers across desktops, laptops, and phones;
- communicates over WebRTC;
- has published iPhone + computer demos;
- exposes OpenAI Chat Completions, OpenAI Responses, and Anthropic Messages through a local bridge;
- requires no native app install on each phone for the first test.

Upstream: https://github.com/Nehanth/pooled

### Starter model

Start with **Qwen3 1.7B**.

Pooled documents approximately:
- ~4 GB combined room memory for 8K context;
- ~5.6 GB combined room memory for 16K context.

Do not begin with the 27B/35B models. First prove that the cluster, model download, layer assignment, and API bridge all work.

## Quick test

### 1. Run preflight on the Windows PC

From this project folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\00-preflight.ps1
```

### 2. Open a Pooled room

On the Windows PC, open:

https://pooled.run/room

Create a room and select **Qwen3 1.7B**.

### 3. Add the phone/tablet

Use the room's invite link or QR code on the second device.

Keep both devices:
- on the same fast Wi-Fi when possible;
- awake;
- charging;
- with the room page open.

Wait until the room reports that the model is ready.

### 4. Prove distributed chat works

Ask:

```text
Reply with exactly: PHONE-CLUSTER-OK
```

If the room answers correctly, the distributed-inference path is working.

### 5. Expose it as a local API

Copy the room invite link and run:

```powershell
.\scripts\02-serve-api.ps1 -RoomLink "PASTE_ROOM_LINK_HERE"
```

The bridge should expose:

```text
http://127.0.0.1:8080/v1
```

### 6. Verify the API

Open a second PowerShell window:

```powershell
.\scripts\03-verify-api.ps1
```

Expected result:

```text
PHONE-CLUSTER-OK
```

## AnythingLLM / OpenAI-compatible clients

Use:

- Base URL: `http://127.0.0.1:8080/v1`
- API key: `pooled` unless you enabled a custom token
- Model: `pooled`

## Self-hosted study copy

To inspect and run the open-source Pooled code locally:

```powershell
.\scripts\01-clone-pooled.ps1
```

Then:

```powershell
cd .\vendor\pooled
npx -y serve -l 8080 .
```

Open:

```text
http://localhost:8080/room
```

For the first phone-to-PC test, use the public Pooled room. Local cross-device browser hosting may require HTTPS / network configuration before mobile browsers expose every required API reliably.

## Alternative implementations

### DistAI
Android + PC / Raspberry Pi. Uses llama.cpp RPC to pool RAM and CPU across Android phones.

https://github.com/alex8819/DistAi

### Infer Ring
iOS + macOS. Uses MLX and combines RAM across Apple devices over Wi-Fi or wired links.

https://github.com/N1k1tung/infer-ring

### llama.cpp RPC
Low-level native building block for distributed model execution.

https://github.com/ggml-org/llama.cpp/tree/master/tools/rpc

### PhoneBorg
Android-oriented multi-phone cluster with provisioning, OpenAI-compatible gateway, monitoring, and larger-model modes.

https://github.com/dzaczek/phoneborg

## Project phases

1. **Proof:** Windows PC + one phone/tablet + Qwen3 1.7B.
2. **API:** expose the room on `127.0.0.1:8080/v1`.
3. **Agent:** connect AnythingLLM or a coding agent.
4. **Scale:** add another device and re-run the benchmark.
5. **Bigger model:** move to the 27B/35B class only when combined memory is sufficient.
6. **Self-host:** host the room stack yourself once the device proof is stable.
7. **Original UI:** build a dedicated "Z Cluster" control panel around the working backend.

## Important limitations

- Splitting a model increases usable combined memory; it does not automatically make inference faster.
- Each token must cross device boundaries, so network latency matters.
- Fast Wi-Fi or a wired link is preferable.
- Model weights may be large downloads.
- Keep API bridges bound to localhost unless you deliberately add authentication and network controls.
- Only join rooms you trust; model prompts and coding-agent content can be visible to the room host and participating devices.

## Next milestone

Do only this first:

> Create one room on the PC, join one phone/tablet, load Qwen3 1.7B, and get **PHONE-CLUSTER-OK** back.

That gives us a clean baseline before we change anything else.
