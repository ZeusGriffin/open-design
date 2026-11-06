# Return-to-Computer Work Session

## Goal

Turn the two source videos into a portable, verifiable local-AI kit that can be copied to memory cards and tested on the laptop.

Sources:
- Emergency AI Kit: https://youtu.be/w48AF0xgWQY
- Local / uncensored AI workflow: https://youtu.be/LYYs_jIFPZ4

## Do this in order

1. Open PowerShell in this project.
2. Run `scripts/windows/00-profile-laptop.ps1`.
3. Save the hardware profile.
4. Run `scripts/windows/05-pull-upstream-code.ps1`.
5. Run `scripts/windows/01-download-core.ps1`.
6. Run `scripts/windows/02-build-checksums.ps1`.
7. Review `prompts/MASTER-SETUP-PROMPT.md`.
8. Install only the smallest baseline first.
9. Test each layer before adding the next one.
10. Copy verified payloads to memory cards.

## Stop points

Stop and fix the current layer if:
- a repository clone fails,
- a checksum fails,
- an installer is unsigned/unexpected,
- the laptop lacks required RAM/VRAM,
- a model does not load,
- a tool attempts unexpected network access during an offline test.

## Defensive-security rule

The DeepSeek Harness / Playwright / Firecrawl / Nuclei lane is for:
- your own apps,
- local test apps,
- disposable lab targets,
- systems you have explicit authorization to test.

Use synthetic/test data by default.

## Done signal

The session is complete when:
- hardware profile is captured,
- upstream repositories are cloned,
- core installers are downloaded,
- checksums are generated,
- one small local model runs,
- Whisper transcribes one local audio file,
- Kiwix opens offline,
- optional browser/security tools work against a local test target only.
