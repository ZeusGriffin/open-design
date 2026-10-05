# Start Here

## Architecture

**Clients**
- Cardputer ADV
- Pi Zero 2 W + Whisplay HAT
- iPhone
- Camera/sensor nodes
- Web apps

**Local AI host**
- RTX desktop

**Services**
- Chat / reasoning model
- Coding model
- Whisper speech-to-text
- Text-to-speech
- Small vision-language model
- YOLO object detection
- Image generation

## First build: Cardputer -> Local AI Host

### Phase 1 - Prove the PC endpoint

1. Run one local chat model.
2. Expose one LAN-only endpoint.
3. Send a fixed prompt from the PC.
4. Confirm a valid response.
5. Record model name, quantization, RAM/VRAM use, and response speed.

### Phase 2 - Prove the Cardputer connection

1. Connect Cardputer to the same Wi-Fi.
2. Hard-code the PC LAN IP and endpoint.
3. Send one fixed prompt.
4. Display one returned response.
5. Save this as the baseline.

### Phase 3 - Add keyboard input

1. Read Cardputer keyboard input.
2. Send entered text to endpoint.
3. Display response.
4. Add scrolling only after basic response works.

## Second build: Whisplay Pocket Voice AI

1. Record a short audio sample on Pi Zero 2 W.
2. Send audio to PC.
3. Transcribe with Whisper.
4. Send transcript to local LLM.
5. Generate TTS on PC.
6. Return audio/text to Whisplay.
7. Only after this works, add wake words, animation, memory, or extra UI.

## Rule

One working end-to-end path first.

Do not add multiple models, UI polish, or automation until the baseline is verified.
