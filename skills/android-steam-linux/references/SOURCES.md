# Sources and verification

Last verified: 2026-10-05

## Source video

- Video: https://youtu.be/aAMj92eUJIk
- Title at verification: "SteamOS is an app now - It's almost perfect"

The video title is treated as shorthand. The underlying implementation is a native ARM64 Linux Steam client running inside an Android app/runtime, not a full Android-to-SteamOS OS replacement.

## Primary upstream

### Bannerlator

Repository:
https://github.com/The412Banner/Bannerlator

Releases:
https://github.com/The412Banner/Bannerlator/releases

Release documentation used for this skill:
https://github.com/The412Banner/Bannerlator/blob/main/docs/releases/3.1.3-pre3.md

Verified setup facts from upstream:
- Android, no root required.
- Adreno/Snapdragon graphics path.
- Enable "Disable child process restrictions".
- Linux Runtime download is about 755 MB.
- Valve ARM64 Proton download is about 2 GB on first Steam sign-in.
- Wait for the ARM64 Proton download and automatic Steam restart before installing the first game.
- 720p is the default Steam Linux resolution.
- Steam Deck mode remains experimental and can break game controller input.
- GE-Proton and proton-cachyos ARM64 builds are optional.
- session logs live under Download/Bannerlator-LinuxSteam/.

### WinNative

Repository:
https://github.com/WinNative-Emu/WinNative

Used as secondary context because current Bannerlator notes credit WinNative work for parts of the Linux Steam path and related fixes.

## Maintenance rule

Before giving version-specific setup steps, check the newest Bannerlator release notes.

If upstream changes:
- supported GPUs
- child-process setup
- runtime size
- Proton bootstrap behavior
- Steam Deck mode
- controller behavior
- audio behavior

update this reference and SKILL.md together.
