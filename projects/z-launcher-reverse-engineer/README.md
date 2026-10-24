# Z Launcher — Reverse Engineer Edition

An original, local-first, Netflix-inspired **Windows PC game catalog and launcher**, independent of Steam and the REA tool showcased in the video.

## Implemented (v0.1.0)
- Discover installed Steam games from libraryfolders.vdf and appmanifest files.
- Launch scanned Steam games with Steam's steam://rungameid/<id> protocol.
- Manually add and launch trusted .exe or .lnk games from Windows.
- Search, Steam/local filters, favorites, and recent games.
- Browse the official Steam, Epic Games and GOG stores.
- Steam cover thumbnails fetched at runtime from Steam's image CDN, not redistributed.
- No account, tracking, game downloads, DRM bypass, ROMs, or storefront purchase integration.

## Install and run on your Windows desktop
1. Install [Node.js LTS](https://nodejs.org/en/download) if needed.
2. Download this project's files with their folder structure intact.
3. From this directory, open PowerShell and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\START-Z-LAUNCHER.ps1
```

Or run `npm install`, `npm run check`, then `npm start`.
Click **Sync Steam** or **Add game**. Game ownership, installation, and authentication remain with the original stores.

**Status:** Code syntax and Steam parser tests passed in a Linux test environment. Not yet run against the user's Windows PC, Steam install, or real game executable. The PowerShell setup script is prepared but has **not** been run on the user's computer.

## Reverse engineering reference (OPTIONAL)
User-provided video: https://youtu.be/qFEuYUfauNY (Low Level's REA investigation).
REA official repository: https://github.com/morluto/rea
Install guide: https://github.com/morluto/rea/blob/main/docs/installation.md

Use `npx rea-agents@latest setup` on your own machine if you want to inspect software you are legally permitted to investigate. **Review REA's interactive setup and proposed agent configuration changes** before approving. Ghidra/Hopper/IDA may be needed only for native binary analysis. REA is not required for this game launcher.

See docs/REVERSE-ENGINEERING.md for provenance and acceptance tests.

## Future work
Epic/GOG installed-library integration, edit metadata, user-selected custom cover images, controller UI, Windows installer/portable build, richer collections and play history. These are planned, **not implemented**.

All code in this directory is original. No proprietary executable, game assets, or REA repository source are included.
