# Separate-device hardware plan

Target not selected or purchased. Recommended baseline:
- Raspberry Pi 5, 8 GB+ RAM; 16 GB if available
- Official compatible power supply and appropriate active cooling
- 64-bit Raspberry Pi OS
- SSD/NVMe preferred; microSD sufficient for initial software test if adequate storage
- USB microphone and speaker (or known-good USB audio interface)
- DSI or HDMI LCD screen for Tkinter face UI
- Camera module optional; vision can be postponed
- Enclosure and battery pack: **not chosen**; do not wire or charge unknown battery circuits

Original creator docs also mention Pi 4 with at least 4 GB RAM. The 512 MB Pi Zero 2 W is excluded for the complete on-device inference pipeline. Leave Whisplay HAT + Pi Zero AI priority untouched.

## Validation checklist
1. Detect ARM64 OS and >= 4GB RAM on device.
2. Confirm microphone and speaker function with ALSA/sounddevice.
3. Confirm Ollama responds and lists gemma3:1b and moondream.
4. Confirm whisper-cli and base.en model exist and a test WAV transcribes.
5. Confirm Piper executable/voice assets exist and play audio.
6. Confirm wakeword and animation face folders exist.
7. Launch agent in foreground only; test wake word, talk/listen, display animation.
8. Connect camera last and test vision, if installed.
9. Consider battery and boot autostart only after a validated wall-powered version.

Status: **unverified on target hardware**.