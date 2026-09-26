# BLINK Connected Portal

Source reference: https://youtube.com/shorts/vN_KR73SPIQ?is=9OwamTzgErHi73cJ

A small internet-connected portal inspired by the reference Short, upgraded so the home screen can launch apps and act as a Spotify player.

## What this build does

- Boots directly into a full-screen portal UI.
- Connects to Wi-Fi through Raspberry Pi OS.
- Shows large touch-friendly app tiles.
- Opens web apps or whitelisted local Linux apps.
- Runs Spotify inside the portal using Spotify Web Playback SDK.
- Can appear as a Spotify Connect playback device.
- Keeps secrets out of GitHub.
- Is designed for a Raspberry Pi + small HDMI/DSI touchscreen, but the software also runs on a normal Linux PC.

## Recommended hardware

- Raspberry Pi 4 (2 GB+) or Pi 5 for the smoothest browser/audio experience.
- Pi Zero 2 W can be used for a smaller build, but Chromium + Spotify will be slower.
- 4-7 inch HDMI or DSI touchscreen.
- USB-C power supply.
- Small USB or I2S speaker, Bluetooth speaker, or HDMI audio.
- microSD card, 32 GB+.
- Optional: ESP32/Cardputer as a remote control surface. Do not use ESP32 as the main Spotify player.

## Repository map

- `docs/END_TO_END_BUILD.md` - full build instructions.
- `docs/ARCHITECTURE.md` - how the device pieces connect.
- `docs/SPOTIFY_SETUP.md` - Spotify developer setup and OAuth scopes.
- `server.js` - local launcher/API server.
- `config/apps.json` - safe app-launch allowlist.
- `public/` - portal UI.
- `.env.example` - Spotify settings template.
- `CLAUDE_PROMPT.md` - reusable build/repair prompt.

## Fast start

```bash
cd projects/blink-connected-portal
cp .env.example .env
npm install
npm start
```

Open `http://127.0.0.1:4173`.

Then follow `docs/SPOTIFY_SETUP.md` before pressing **Connect Spotify**.

## Design direction

Keep the reference video's portal feeling, but use a BLINK / By Zeus treatment: dark, minimal, large tiles, low visual clutter, touch-first targets, clear connection state, and a dedicated now-playing surface.

The exact visual recreation is intentionally not locked here; preserve the reference as the baseline and approve the visual mock before making style changes.

## Security

Only apps listed in `config/apps.json` can be launched. Never expose a generic shell endpoint. Never commit `.env`, Spotify tokens, passwords, SSH keys, or API secrets.
