# Architecture

## Mental model

This project is **distributed inference**, not a universal wireless GPU.

```text
                    ┌───────────────────────────────┐
                    │          Host / Room          │
                    │ tokenization + scheduling     │
                    └──────────────┬────────────────┘
                                   │ hidden state
                                   ▼
          ┌──────────────────────────────────────────────┐
          │                 Device pipeline              │
          │                                              │
          │ PC GPU     -> iPhone/iPad -> another device  │
          │ layers A      layers B        layers C       │
          └──────────────────────────────────────────────┘
                                   │
                                   ▼
                    ┌───────────────────────────────┐
                    │ next-token sampling / output  │
                    └───────────────────────────────┘
```

For every generated token, each participating device runs the layers assigned to it and forwards a relatively small activation/hidden-state payload to the next device.

## Why this helps

The main benefit is **combined usable memory**.

A model too large for one device can fit when different groups of layers are stored on different devices.

## Why this can be slower

Generation is sequential through the layer pipeline. Each extra hop adds:

- network latency;
- serialization / transfer time;
- synchronization overhead.

The cluster therefore trades some speed for the ability to fit larger models.

## First backend: Pooled

Pooled uses:

- WebGPU for model compute in the browser;
- WGSL kernels;
- WebRTC for peer-to-peer data movement;
- layer splitting across devices;
- a Node CLI bridge for OpenAI-compatible and Anthropic-compatible APIs.

The local API bridge does not do the model inference itself. It joins the room as an API client and relays requests to the distributed room.

## Native alternatives

### llama.cpp RPC / DistAI

A native coordinator can run `llama-server` and place remote layers on `ggml-rpc-server` workers.

This is attractive for Android and PCs because it avoids browser limitations and uses llama.cpp directly.

### Infer Ring

For Apple-only clusters, Infer Ring uses MLX and supports pipeline/tensor parallelism between iOS and macOS.

## Security boundary

Treat every participating device as part of the inference trust boundary.

For coding agents in particular, prompts may contain:

- source code;
- file contents;
- environment details;
- secrets accidentally included by tools.

Use trusted devices and trusted rooms only. Keep the API bridge on localhost unless you intentionally add authentication and network controls.
