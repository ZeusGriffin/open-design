# Reticulum HF Radio / CrossTalk Build Kit

Status: Research and procurement planning — no hardware purchased, installation or radio test verified.

## Source
- Video: https://youtu.be/5vbl5FL-nsI
- CrossTalk: https://github.com/buildwithparallel/crosstalk
- HF bridge: https://github.com/buildwithparallel/reticulum-hf-bridge
- Hermes Lite 2: https://github.com/softerhardware/Hermes-Lite2
- HF codec: https://github.com/buildwithparallel/crosstalk/blob/master/docs/hf_codec.md

## Goal
Reproduce the video’s experimental long-range HF messaging setup with a staged, easy-to-test implementation. Do not treat 1,600 miles as a verified message range.

## Hardware checklist (verify exact specifications before ordering)
- Windows PC for first software test (existing hardware)
- Hermes Lite 2 SDR transceiver for eventual HF transmit station
- Compatible HF antenna tuned for the chosen permitted band
- Feed line, correct connectors, antenna mount and grounding/lightning protection as appropriate
- Compatible power supply for the radio
- Ethernet cable and network interface
- Optional RTL-SDR with HF receive capability or suitable upconverter for receive-only experiments
- Optional NanoVNA for antenna measurement
- Second participating station for end-to-end tests
- Optional Raspberry Pi 5 for field station (Pi Zero 2 W not presumed sufficient)

## Implementation stages
1. Read upstream CrossTalk install guide and release notes. Install packaged Windows release on test PC.
2. Run CrossTalk locally; verify application launch and basic Reticulum interface status without transmitting.
3. Set up second software node and validate message delivery over a permitted local/IP interface.
4. Build receive-only HF station; log received frames.
5. Confirm amateur radio license, local band privileges, station identification and plaintext on-air limitations before any transmission.
6. Connect Hermes Lite 2 using the HF bridge’s documented configuration; verify antenna match and power.
7. Conduct controlled over-the-air messaging with second station and record signal, range, delivery and failures.

## Safety and architecture
- CrossTalk describes optional 10 m HF hop as **plaintext**; encrypted Reticulum traffic is not sent over that radio hop.
- Amateur transmissions require compliance with applicable licensing and operating rules. Do not assume general-purpose encrypted private messaging is legal on amateur bands.
- HF radio is not a drop-in replacement for an internet connection.
- ESP32 LoRa / RNode is a separate alternative transport, not a replacement for an HF SDR transceiver.

## Next action
Confirm whether to target the full Hermes Lite 2 build or a lower-cost LoRa/RNode version using existing ESP32 and Raspberry Pi equipment. Then create a verified, vendor-linked BOM with costs and a reproducible setup script.

## Verification
- [ ] Software installed on Windows
- [ ] Local Reticulum message delivered
- [ ] Receive-only HF tested
- [ ] License/band eligibility verified
- [ ] Hardware purchased and connected
- [ ] OTA message delivered
