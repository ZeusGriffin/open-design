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
