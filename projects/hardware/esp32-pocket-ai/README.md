# ESP32 Pocket AI — Offline 14.9 MB LLM

Status: research/prep only. Do not flash existing boards until hardware is verified.

Video reference: https://youtu.be/M24yg6ZM7-I
Reference implementation: https://github.com/slvDev/esp32-ai
Alternative portable implementation: https://github.com/manjunathshiva/esp32-tinyllm

## Goal
Run a small fully offline language model on a compatible ESP32-S3; test serial text output first, then integrate a screen and controls.

## Hardware gate
- ESP32-S3 with **16 MB flash and 8 MB PSRAM** (N16R8) required for the cited 14.9 MB model.
- Confirm exact board SKU, flash size, PSRAM, pinout, and partition layout before flashing.
- Existing Cardputer ADV / LILYGO devices are candidates **only after** checking actual memory and board compatibility. Do not overwrite working firmware.
- Optional SSD1306/SH1106 I2C OLED; pin assignments must be confirmed for each board.

## Preparation on computer
1. Install git, git-lfs (if using LFS alternative), Arduino CLI, Python/uv, and ESP32 board support as required by upstream.
2. Clone upstream into a separate workspace; inspect LICENSE and README.
3. Use upstream `scripts/fetch_model.sh tinystories` to download and checksum-verify the pretrained model, where available.
4. Use upstream `scripts/deploy.sh tinystories` **only after** confirming supported hardware and backing up firmware.
5. Capture serial log, model partition check, token generation rate, memory usage and screen output.

## Verification gates
- PASS 1: board reports ESP32-S3, >=16 MB flash and >=8 MB PSRAM.
- PASS 2: model asset verified by checksum and partition layout fits.
- PASS 3: firmware compiles without errors for the exact board.
- PASS 4: offline text generation works over serial, with Wi-Fi disabled.
- PASS 5: optional display renders generated text reliably.

## Important limits
The TinyStories model is for short text generation; it is not a general-purpose assistant, factual QA model or code-writing AI. Published ~9.88 tokens/sec is an upstream benchmark, not a verified result on our hardware.

## Next action
Identify the exact LILYGO ESP32-S3 and other ESP32 board flash/PSRAM specifications. Choose the first N16R8-compatible test device; avoid touching current working firmware until verified.
