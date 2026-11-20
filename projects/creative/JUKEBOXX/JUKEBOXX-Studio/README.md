# JUKEBOXX Studio

A portable, local creative workspace with a PS1/PS2 game-menu aesthetic. Every station uses the same cobalt/cyan interface and slowly drifting sky background. The original JUKE View source is preserved alongside the expanded studio.

## Open the studio

1. Install Node.js if it is not already installed (tested with the local Node runtime).
2. Run **Start-Studio.cmd** on Windows, or run `node server/studio-server.cjs` from this folder.
3. Open [JUKEBOXX Studio](http://127.0.0.1:18767/studio.html). Keep the local server running.

No package installation is required. The server binds only to 127.0.0.1. If port 18767 is already serving this studio, use the existing preview.

## Stations

- **Website Maker:** editable sections, sandboxed preview, saved draft, HTML export.
- **Vision Board:** image and note cards, editable titles/colors, browser persistence, JSON export. Includes the recovered research references for a new browser.
- **Progress:** a checklist whose completion calculates the progress bar.
- **Rollout Timeline:** editable milestones and statuses, date validation, Gantt chart and exact-date table.
- **Cover Art:** 1024-square canvas, type/colors/background/image controls, PNG export.
- **GitHub Repository:** live public repository browsing and text previews; separate local project drafts. No automatic GitHub writes.
- **Image Chat:** real image/character analysis through a locally signed-in Codex CLI. The image is sent only when Analyze is selected. If sign-in is unavailable, setup-needed status is shown.
- **Character Station:** recovered polygon-head reference and a place to use the original character artwork. The blue armored robot is an earlier style experiment, not the artist's approved mascot.
- **JUKE View:** original annotation workflow plus a themed copy with pen, shapes, highlights, pins, undo, JSON and image exports.

Use the game menu, arrow keys/Enter, and Back to Main Menu. Escape returns to the menu when a form field is not being edited. Cloud movement respects reduced-motion preferences.

## Saving and backup

Drafts, boards, tasks, and milestones are stored in this browser's IndexedDB for this local origin. Export from each station to make portable project files. The source bundle does not contain credentials, CLI authentication files, model-session logs, or unrelated computer files. A reference-board snapshot and exported cover example are included.

## Design and provenance

See [design direction](docs/DESIGN-DIRECTION.md), [validation](docs/VALIDATION.md), and [preservation notes](docs/PRESERVATION.md).

This folder is a standalone archived project prototype under `projects/creative/JUKEBOXX`, not a change to Open Design's application runtime, shared contracts, or root commands. Its existing JavaScript/CommonJS files are preserved compatibility artifacts so the original no-build prototype can run directly in a browser/Node; no root workspace scripts or dependencies are added.

Snapshot prepared 2026-11-17.
