# Android Steam Linux — Instructions

Source video: https://youtu.be/aAMj92eUJIk

This pack converts the video's "SteamOS is an app now" idea into a repeatable setup guide.

## What it really is

It is not Android being replaced by the full SteamOS operating system.

It is:
- Bannerlator
- a Linux runtime inside Android
- Valve's native ARM64 Linux Steam client
- Valve ARM64 Proton
- Gamescope/Wayland
- Turnip graphics on Snapdragon/Adreno

That gives an Android handheld or phone a Steam Deck-like Steam session without root.

## Fast setup

1. Confirm Snapdragon + Adreno.
2. Install Bannerlator from the official release.
3. Android Settings -> Developer options -> Disable child process restrictions -> ON.
4. Bannerlator -> Contents -> Linux Runtime -> Download.
5. Wait for Steam (Linux) to appear.
6. Launch Steam (Linux).
7. Sign in.
8. Do not install a game yet.
9. Wait for Proton Experimental (ARM64) to download.
10. Let Steam restart itself.
11. After Steam reopens, install a small test game.
12. Keep Steam Deck mode OFF for the baseline test.

## Storage

Plan for at least:
- about 755 MB Linux runtime
- about 2 GB ARM64 Proton
- additional Steam/game storage

## Do not skip

The Proton download + automatic Steam restart is part of setup. Installing a game before that restart can leave the game with the wrong Steam tool chain and cause a silent launch failure.

## Known current limits

- Adreno only for the supported Turnip path.
- Mali/Xclipse/PowerVR can show a black screen with sound.
- Steam Deck mode can break controller input in games.
- Not every Windows game works under the ARM64 Proton path.
- The feature is experimental.

## Baseline test

Start at:
- 720p
- bundled/default Turnip
- default Proton Experimental ARM64
- Steam Deck mode OFF
- frame generation OFF

Change only one setting at a time after the baseline works.

## Reusable AI instruction

Use the `SKILL.md` file in this folder. It tells ChatGPT, Claude, Codex, or another compatible agent how to:
- check compatibility
- guide installation
- troubleshoot
- verify changes
- keep version-specific instructions current

## Repository placement

Category: Android / Gaming / Linux / Steam

Folder:
`skills/android-steam-linux/`
