# Research Sources

Research captured: 2026-11-06

## Source video

- orailnoor — "I Turned My Spare Phones Into a Wireless GPU for AI Agents (It Actually Works)"
  - https://www.youtube.com/watch?v=reOeczuEzOA

## Product demonstrated in the video

- Private LLM
  - https://privatellm.app/en
  - https://privatellm.app/en/faq
  - https://apps.apple.com/us/app/private-llm-local-ai-chat/id6448106860

Key concept: the proprietary Phone Cluster feature distributes a large model across multiple phones/tablets and can expose an OpenAI-compatible endpoint.

## Open-source implementations researched

### Pooled
- https://github.com/Nehanth/pooled
- Browser WebGPU + WebRTC.
- Splits one model across devices.
- Published iPhone + computer demo.
- OpenAI Chat Completions / Responses and Anthropic Messages bridge.
- Node 22+ required for the CLI bridge.

### DistAI
- https://github.com/alex8819/DistAi
- Android phones + PC/Raspberry Pi.
- Built on llama.cpp RPC.
- Automatic discovery and split planning.
- OpenAI-compatible API.

### llama.cpp RPC
- https://github.com/ggml-org/llama.cpp/tree/master/tools/rpc
- Low-level distributed backend.
- Can distribute model weights and KV cache across local and remote devices.

### Infer Ring
- https://github.com/N1k1tung/infer-ring
- iOS + macOS.
- Built on MLX.
- Cross-device inference over Wi-Fi or wired links.
- Supports pipeline and tensor parallelism.

### PhoneBorg
- https://github.com/dzaczek/phoneborg
- Android multi-phone cluster.
- ADB provisioning, llama.cpp, OpenAI-compatible gateway, monitoring, and multi-phone operating modes.

## Decision

Use **Pooled first** for the proof-of-concept because it is the least-friction mixed-device path and most closely matches the video's user experience.

After the proof works, choose between:

- Pooled self-hosting for mixed browser devices;
- llama.cpp/DistAI for Android/native nodes;
- Infer Ring for an Apple-only cluster.
