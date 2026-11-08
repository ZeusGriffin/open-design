# SSH / CyberDeck project progress — 2026-11-08

## Objective
Reusable SSH code separate from iPhone 15 CyberDeck 3D-printing CAD, usable across iPhone, Pi, Windows, ESP32-S3 and Cardputer ADV.

## Verified in this conversation
- GitHub preparation kit saved at https://github.com/ZeusGriffin/open-design/tree/main/projects/software/reusable-ssh-terminal
- CyberDeck CAD prep at https://github.com/ZeusGriffin/open-design/tree/main/projects/hardware/cyberdeck-iphone15
- AI handoff prompt: https://github.com/ZeusGriffin/open-design/blob/main/projects/hardware/cyberdeck-iphone15/AI_HANDOFF_MASTER_PROMPT.md
- Python SSH command client source committed to this folder (not interactive terminal).
- Source candidates: https://github.com/madeye/gterm and https://github.com/sigman78/esperdeck
- Nominal standard iPhone 15 dimensions: 147.6 x 71.6 x 7.8 mm.
- Earlier conversation produced a test-fit STL and ZIP, but their exact print/fit cannot be verified from GitHub and they are not asserted as uploaded there.

## NOT done
- Upstream SSH or CyberDeck full source not copied into this repository.
- No compiled iOS app, embedded firmware, or tested SSH session.
- No validated full keyboard CyberDeck STL/3MF or real-world print test.
- No direct write to local Obsidian vault; this note is Obsidian-compatible Markdown.
- 504 Gateway Timeout reported opening link; cause not independently diagnosed.

## Next
1. Clone/pin upstream CAD, review license and keyboard dimensions.
2. Finish standard iPhone 15 slate CAD and test fit, then clamshell.
3. Build iOS SSH terminal from reviewed maintained source.
4. Validate authorized host connections, key trust and Bluetooth keyboard.
5. Import these Markdown notes into Obsidian; maintain one master vault.

## Security
Never commit credentials or private SSH keys. Verify host keys, never auto-accept unknown hosts in production.
