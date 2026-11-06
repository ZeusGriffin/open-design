# Checkpoint - 2026-11-06

## Overall readiness

**55%**

`[███████████░░░░░░░░░] 55%`

This is project-preparation readiness, not a claim of completed hardware validation.

## What we established

- The source video demonstrates distributed LLM inference, not a general-purpose wireless GPU.
- Pooled is the preferred first open-source backend for mixed devices.
- Pooled uses WebGPU for compute, WebRTC between participating devices, and can expose a room through an OpenAI-compatible local API.
- Current Pooled docs explicitly say Safari on an iPhone can join a room and hold layers; devices without WebGPU become ask-only guests.
- Qwen3 1.7B is the first baseline model: about 4 GB combined room memory for 8K context and about 5.6 GB for 16K.

## What is already in this repository

- Windows preflight script.
- Pooled source bootstrap script.
- Local API bridge launcher.
- API verification script using `PHONE-CLUSTER-OK`.
- Pinned Pooled upstream commit.
- Architecture and source research.
- Reusable master prompt.
- Progress tracker.
- Hardware benchmark template.
- Mobile-first Z Cluster compatibility/PWA shell.

## Mobile design

### GPU Worker Candidate
If the browser exposes WebGPU and returns a usable GPU adapter, the device is a candidate to contribute model layers.

### Controller
If WebGPU is unavailable or no usable adapter is returned, the device still remains useful as a control/chat device.

## Resume point

Do not restart research.

Next physical milestone:

> PC + one iPhone/iPad -> open the same Pooled room -> select Qwen3 1.7B -> ask for `PHONE-CLUSTER-OK`.

After that:

1. Run the local API bridge.
2. Verify OpenAI-compatible chat completion.
3. Connect AnythingLLM or a coding agent.
4. Add a second mobile device.
5. Benchmark.
6. Test a larger model.
7. Expand the Z Cluster dashboard.

## Build method

### Karpathy / evidence-first
- Smallest measurable baseline first.
- One variable at a time.
- Verification after each change.
- Rollback path preserved.
- Never mark hardware tested without a real device result.

### Caveman mode
- One objective per step.
- Simple language.
- Obvious buttons and commands.
- Visible PASS / FAIL.
- Reduce the system when troubleshooting.

### Engagement
- Always show device role.
- Show model and download state.
- Show room/API status.
- Show the single next action.
- Avoid dead screens or unexplained waiting.

## PDF artifact

Generated file name:

`Phone_Cluster_AI_Checkpoint_2026-11-06.pdf`

Verified render: 4 pages.

SHA-256:

`fbb9ab97d8cd9db0d7a744e9957cb2a0f9fe88cdfc69a71882732bb4c228efe1`

The repository keeps this checkpoint source plus the project files needed to resume. The PDF attachment was generated from the same checkpoint state.

## Sources

- https://github.com/Nehanth/pooled
- https://pooled.run
- https://www.youtube.com/watch?v=reOeczuEzOA
