# Architecture

## Goal

Use a small Linux computer as the actual portal, not an ESP32 pretending to be a desktop.

```text
Wi-Fi
  |
Raspberry Pi 4/5 or Pi Zero 2 W
  |
  +-- Node launcher server (127.0.0.1:4173)
  |     +-- serves portal UI
  |     +-- returns app allowlist
  |     +-- launches approved local programs
  |
  +-- Chromium in app/kiosk mode
  |     +-- app tiles
  |     +-- Spotify Web Playback SDK
  |     +-- web apps
  |
  +-- Audio output
        +-- HDMI / USB / I2S / Bluetooth speaker
```

## Why this split

A browser by itself should not be allowed to run arbitrary shell commands. The local Node process exposes only a tiny allowlisted launcher API. Every local app must exist in `config/apps.json`.

Spotify runs in Chromium through Spotify's Web Playback SDK. The user signs in through OAuth Authorization Code with PKCE, so a client secret does not need to live in the portal source.

## App types

`internal`
: A feature that is already inside the portal, such as the Spotify panel.

`url`
: A web app. The backend returns the approved URL and the browser opens it.

`local`
: A native Linux application. The backend launches the exact command stored in the allowlist.

## Security boundary

Do not add an endpoint such as `/api/run?command=...`. Do not accept shell text from the browser. Add a new fixed app entry instead.

## Optional ESP32/Cardputer companion

An ESP32 or Cardputer can be added later as a remote controller for volume, next/previous track, shortcuts, or status. It should call a restricted local API on the Pi. The Pi remains the application and Spotify host.
