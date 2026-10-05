# Local AI

Practical local-AI project guide based on Tina Huang's **Every Size Local AI In 24 Minutes**.

Source video: https://youtu.be/rPGJhrunbxo

## Goal

Use small devices as interfaces and stronger local hardware as the AI brain.

The project is organized around:
- ESP32 / Cardputer-class tiny AI and remote clients
- Raspberry Pi / Whisplay physical interfaces
- iPhone on-device vision, speech, detection, and small models
- RTX desktop local inference for chat, code, speech, vision, and image generation
- Future always-on local AI server

## Start here

1. Build **Cardputer Local-AI Terminal**.
2. Build **Whisplay Pocket Voice AI**.
3. Turn the RTX PC into a reusable **Local AI Hub**.
4. Add vision, object detection, image generation, and hardware control after the base endpoint works.

## Files

- `VIDEO-CAPABILITIES.md` - everything demonstrated or explained in the video
- `15-PROJECT-IDEAS.md` - 15 projects matched to our hardware/projects
- `START-HERE.md` - smallest useful build sequence

## Core rule

Weak device = interface/client.

Strong local machine = model host.

Verify one end-to-end function before adding UI, extra models, sensors, or automation.
