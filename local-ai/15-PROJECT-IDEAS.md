# 15 Local AI Projects Worth Building

## 1. Whisplay Pocket Voice AI

**Hardware:** Pi Zero 2 W + Whisplay HAT + RTX PC.

Pi handles microphone, speaker, buttons, and display. PC runs Whisper + local LLM + TTS.

**Smallest verification:** press button -> record 3 seconds -> PC transcribes -> text returns to display.

## 2. Cardputer Local-AI Terminal

Cardputer ADV becomes a pocket keyboard/display client for a local model on the PC.

**Smallest verification:** type one prompt -> receive one local reply over Wi-Fi.

## 3. TinyStories Cardputer Mode

Run a TinyStories-sized model directly on the ESP32-S3/PSRAM device.

**Smallest verification:** fixed prompt -> generate 20-40 tokens with Wi-Fi disabled.

## 4. Camera Scene Narrator

Camera captures one frame -> local vision model describes it -> TTS reads it aloud.

**Smallest verification:** one photo -> one sentence description.

## 5. Offline Object Finder

Use YOLO on iPhone or PC for local object detection and bounding boxes.

**Smallest verification:** detect person, chair, and cup in one camera frame.

## 6. Private Voice Memo Transcriber

Run Whisper locally on recorded voice memos.

**Smallest verification:** 30-second memo -> accurate searchable text.

## 7. Local Coding Copilot

Use a local coding model for Arduino, ESP32, Raspberry Pi, Python, and web projects.

**Smallest verification:** explain one existing sketch and generate one safe patch.

## 8. Local Project Build Agent

Give a local agent a project folder, build commands, and tests.

**Smallest verification:** read project -> identify one bug -> make one diff -> run build/test.

## 9. Projector Mockup Generator

Use local image generation for Projector Putty masks, frame ideas, shapes, and scene studies.

**Smallest verification:** create four variants and save the winning prompt/settings.

## 10. Door App Visual Research Helper

Use local vision + OCR to classify door photos by style, period, material, country, and visible features.

**Smallest verification:** 10 photos -> stable repeatable tags.

## 11. VR180 Preflight Assistant

Sample frames before conversion and flag orientation, crop, exposure, obvious stitching, and scene changes.

**Smallest verification:** sample 10 frames -> simple pass/fail report.

## 12. Govee Mood Controller

Classify a text/voice request into a lighting mood and map it to one deterministic scene.

**Smallest verification:** "calm blue room" -> one known lighting command.

## 13. Local Hardware Help Desk

Index wiring notes, pin maps, build logs, firmware notes, and READMEs for private troubleshooting.

**Smallest verification:** load one project guide -> answer three known questions correctly.

## 14. Always-On Local AI Hub

One local LAN endpoint serves Cardputer, Pi, phone tools, cameras, and web apps.

**Smallest verification:** one /chat endpoint works from two devices.

## 15. Multi-Model Studio

One launcher routes work to Chat / Code / Vision / Transcribe / TTS / Image models.

**Smallest verification:** five buttons route to five working local services.

# Recommended order

1. Cardputer Local-AI Terminal
2. Whisplay Pocket Voice AI
3. Local AI Hub
4. Camera Scene Narrator
5. Local Coding Copilot
6. Add image generation and other multimodal services
