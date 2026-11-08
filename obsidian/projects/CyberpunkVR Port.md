# CyberpunkVR Port — Quest 3 motion-controller VR

Status: Research / install pending (2026-11-08)
Upstream: https://github.com/dariulone/cyberpunk-vr-port
Releases: https://github.com/dariulone/cyberpunk-vr-port/releases
Nexus: https://www.nexusmods.com/cyberpunk2077/mods/30093
Hardware target: Meta Quest 3 + Windows PC + RTX 4070 Super

## Goal
Play Cyberpunk 2077 in PCVR with tracked hand/controller movement, aiming, physical reload interactions and immersive driving. This is NOT the older Luke Ross head-aimed VR mod.

## Existing baseline — preserve
Existing custom Night City Echoes install kit: https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/cyberpunk2077-night-city-echoes/INSTALL-KIT.md. Its current status warns against installing unverified combinations on Cyberpunk patch 2.5. Do not overwrite or install over an active mod stack without compatibility verification.

## Before installation
1. Check upstream release README, requirements and supported game version on installation day; do not assume current versions are compatible.
2. Record Cyberpunk game build, RED4ext and CET versions, Steam/GOG/Epic location, OpenXR runtime and existing mod list.
3. Back up saves and relevant mod directories; preserve Night City Echoes and rollback route.
4. Compare VR mod hooks/plugins with existing VR injectors, graphics mods and Night City Echoes.
5. Test first with a clean or isolated profile; avoid modifying working installation until verified.
6. Install official release only after checks, launch via Quest 3 PCVR, verify tracked hands, weapon aiming, reload, driving, performance and save loading.
7. Log results and revert if any test fails.

## Verification
- [ ] Official upstream requirements reviewed
- [ ] Game/mod version compatibility checked
- [ ] Backup and rollback documented
- [ ] VR mod installed on PC
- [ ] Quest 3 headset connects
- [ ] Both hands track independently
- [ ] Aim/reload/driving work
- [ ] Night City Echoes still works (if combined)
- [ ] No critical crashes; rollback tested

## Blockers
No PC access or live game test in this session. No installation performed. Obsidian note is stored as Markdown in GitHub for import/sync; this is not confirmation of a write to the local Obsidian vault.

## Release verification — 2026-11-08
- Official latest: **v0.2.2**, released 2026-11-05: https://github.com/dariulone/cyberpunk-vr-port/releases/tag/v0.2.2
- New: immersive physical weapon holsters, dual wielding, hands-only avatar, optional OpenXR finger tracking and Vive tracker full-body tracking, improved steering and stereo performance.
- Release notes state v0.2.0 reduced mandatory framework dependencies to RED4ext 1.31.0; verify current README and requirements again before installing.
- Keep Night City Echoes installation isolated until compatibility and rollback checks pass. No local installation or testing performed.

## Preferred installer: MrSurviv0r's VR HUB (2026-11-08)
- User-selected workflow: use MrSurviv0r's VR HUB to install/manage dariulone CyberpunkVR Port with motion-controlled hands on Quest 3.
- Hub repository/releases: https://github.com/MrSurviv0r/MRSURVIV0R-S-VR-HUB/releases
- Official website: https://mrsurvivor-installers.com/
- Upstream VR mod: https://github.com/dariulone/cyberpunk-vr-port/releases
- Hub website says it integrates Cyberpunk VR Port and handles downloads, verification and updates. Verify exact port version selected by HUB at install time; it may lag upstream.
- Safety: keep Night City Echoes and existing mod installation backed up; check game version 2.5, installed dependencies, other VR injectors, and HUB compatibility before running installer. Prefer an isolated install/backup. No local installation or testing performed.
- Acceptance test: Quest 3 connects, independent hands track, weapon aiming/reload work, and Night City Echoes is not damaged.

## Installation kit — GitHub source of truth (2026-11-08)
- [All source and release links](https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/cyberpunk2077-vr-port/LINKS.md)
- [Reusable full installation prompt](https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/cyberpunk2077-vr-port/INSTALL-PROMPT.md)
- [Read-only Windows preflight script](https://github.com/ZeusGriffin/open-design/blob/main/projects/game-mods/cyberpunk2077-vr-port/scripts/Check-CyberpunkVR.ps1)

Run script after downloading it from GitHub with: `powershell -NoProfile -File .\Check-CyberpunkVR.ps1 -GamePath "C:\path\to\Cyberpunk 2077"`. Replace the placeholder with the actual game folder. Script inventories only; no installation performed. Obsidian local vault sync remains pending.

## Official HUB release source — 2026-11-08
User-supplied official installer release page: https://github.com/MrSurviv0r/MRSURVIV0R-S-VR-HUB/releases
Before running: confirm the current release tag, included CyberpunkVR Port version, supported Cyberpunk patch and dependencies from official release notes. Download only official release assets; do not run automatically. Compatibility and PC installation remain unverified.
