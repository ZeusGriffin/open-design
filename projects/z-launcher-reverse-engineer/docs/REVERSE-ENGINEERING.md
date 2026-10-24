# REA research and Z Launcher build

Video: https://youtu.be/qFEuYUfauNY (Low Level: I Tested The Viral Reverse Engineering Repo).
REA source: https://github.com/morluto/rea
Official install: https://github.com/morluto/rea/blob/main/docs/installation.md

**Purpose:** Use REA only for lawful investigation of software the user owns or is authorized to analyze. Z Launcher is a clean-room, independently coded game-launcher prototype; it does not contain decompiled proprietary source, copied commercial game assets, or REA's source code.

## Workflow
1. Confirm authorized target and state one narrow feature.
2. Prefer publicly documented formats and interoperability APIs.
3. Use upstream REA interactive setup only when needed; review every proposed configuration change.
4. Record version, observations, limitations, relevant evidence, and unknowns.
5. Write independent behavior specification and tests, then implement.
6. Validate on the actual Windows PC before claiming compatibility.

## Checks
- Node syntax check and 3 Steam parser tests pass: validated in preparation environment.
- Windows actual game launch: NOT YET VERIFIED.
- Windows Steam discovery: NOT YET VERIFIED.
- Optional REA setup and decompiler installation: NOT YET RUN ON PC.
- No auto-download of games, ROMs, or DRM bypass.
- Steam/Epic/GOG buttons are store links, not purchasing integration.
