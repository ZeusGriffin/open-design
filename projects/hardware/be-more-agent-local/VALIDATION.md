# Validation status — 2026-11-03

- [x] Identified video and creator's public GitHub source
- [x] Located local LLM/stt/tts/wake-word components
- [x] Located original agent.py and setup.sh; archived their unmodified text
- [x] Corrected deployment preparation to account for missing Whisper.cpp compilation/model step
- [x] Prepared default read-only hardware/preflight flow
- [x] Prepared Obsidian note and safe import helper
- [ ] Run bash syntax checks on actual deployment system
- [ ] Choose target hardware, OS image, display and power
- [ ] Install Ollama and download weights on device
- [ ] Build Whisper.cpp and test transcription on device
- [ ] Test Piper/audio mic and speaker
- [ ] Test UI animations / camera / end-to-end conversation
- [ ] Confirm persistent startup/battery behavior (not enabled)

This is a SOURCE + PREPARATION milestone, not a functional hardware test.