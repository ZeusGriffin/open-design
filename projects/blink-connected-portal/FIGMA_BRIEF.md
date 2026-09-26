# Figma Brief — BLINK Connected Portal

Reference baseline:
https://youtube.com/shorts/vN_KR73SPIQ?is=9OwamTzgErHi73cJ

## Product outcome

A touch-first portal for a small connected display. The home screen must feel like the approved reference, but the working version needs:
- visible online/offline state,
- launchable app tiles,
- a Spotify now-playing surface,
- simple previous / play-pause / next controls,
- portrait and landscape tolerance.

## Required frames

1. Boot / connecting state.
2. Home portal with app tiles.
3. Spotify disconnected.
4. Spotify connected / now playing.
5. App launch transition.
6. Offline state.
7. Settings / Wi-Fi handoff state.

## Interaction rules

- One tap on an app tile launches it.
- Spotify tile scrolls or transitions to the player.
- Web apps open in a dedicated app window or browser view.
- Native apps are launched by the local allowlisted launcher service.
- No hidden long-press requirements for core functions.
- Touch targets should remain generous on a 4-7 inch display.

## Visual constraints

- Preserve the source Short as the visual baseline.
- BLINK / By Zeus signature may be applied without replacing the reference composition.
- Dark, low-clutter, high-contrast treatment.
- Do not finalize a redesign until a source screenshot/mock is approved.
- Once approved, use change-only edits.

## Handoff annotations

Each interactive tile should specify:
- app id,
- app kind: internal / url / local,
- launch behavior,
- offline behavior,
- fallback if launch fails.

Spotify controls should specify:
- disconnected,
- authorizing,
- ready,
- playing,
- paused,
- error,
- offline states.
