# Everything the video shows you can do

## Tiny boards / Arduino-class

- A board too small for an AI model can still use Wi-Fi to connect to a stronger local-AI machine.
- Use it as a display, button box, light controller, sensor node, or remote terminal.

## ESP32-S3 class

- Run TinyStories-sized language models directly.
- Generate tiny stories or short text.
- Build scrambled-vs-not-scrambled grammar games.
- Drive LEDs based on generated text or mood.
- Add buttons, displays, sensors, and other modules.

Limits:
- Not a normal conversational LLM.
- Not suited to audio, image, music, or video generation.

## Raspberry Pi 5 class

- Run small local chat models.
- Chain **speech-to-text + LLM + text-to-speech** for a local voice assistant.
- Use Whisper for speech recognition.
- Use a Qwen-class small LLM for reasoning/replies.
- Use Piper for text-to-speech.
- Add a webcam.
- Use a tiny vision-language model such as Moondream-class models to describe camera images.
- Run tiny vision, small speech, and lightweight code models.
- Connect sensors, cameras, speakers, displays, and robotics hardware.

Limits:
- Midsize LLMs are difficult/slow.
- Image, music, and video generation are generally too slow without stronger GPU acceleration.

## iPhone class

- Run small local LLMs through supported apps.
- Run small vision-language models for image analysis.
- Run local image generation with apps such as Draw Things.
- Run Whisper-class speech-to-text.
- Run text-to-speech.
- Run object detection such as YOLO through Ultralytics-supported apps.

## Laptop / desktop

With enough RAM/GPU resources:
- Local chat
- Coding models
- Visual-language analysis
- Image generation
- Video generation
- Speech-to-text
- Text-to-speech
- Audio generation
- Voice cloning
- Music generation
- Local AI agents
- Local coding assistants

Software examples mentioned:
- Hermes Agent
- OpenCode
- Qwen 3 family
- Qwen 3 Coder
- FLUX Dev

## Always-on home server

- Keep local models and agents running 24/7.
- Serve models to smaller devices over the local network.
- Run larger models.
- Keep multiple model services available without depending on a laptop being open.

## High-memory workstation

- Run very large chat/coding models.
- Load several models at once.
- Run coding + chat + image/video workflows simultaneously.
- High memory capacity is useful even when bandwidth limits generation speed.

## Discrete GPU / gaming PC

- Much faster image generation.
- Faster video generation.
- Faster music/audio generation.
- High-throughput local inference.
- GPU VRAM determines how much model can stay on the GPU.

## Multi-GPU / H100-class server

- Ultra-large LLMs.
- Ultra-large coding models.
- Large vision-language models.
- High-end multimodal generation.
- Large memory capacity plus high memory bandwidth.

## Open model customization

- Fine-tune open models on your own data.
- Deploy models as local or hosted services.
- Connect devices/apps to model endpoints.

## Hardware concepts

- **RAM**: how much model can fit.
- **Memory bandwidth**: how quickly model data moves.
- **CPU**: general flexible compute.
- **GPU**: parallel compute; especially important for image/video/music.
- **NPU**: specialized low-power AI acceleration.
- **Storage**: where model files live before loading.

The video's rough RAM fit estimate:
1. Take installed RAM.
2. Reserve about 25% for system overhead.
3. Divide remaining RAM by about 0.6 to estimate an upper model-parameter size.

This is only a rough estimate. Quantization, context length, VRAM/unified memory, app limits, and runtime overhead change the real result.
