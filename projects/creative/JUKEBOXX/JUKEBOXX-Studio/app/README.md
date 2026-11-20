# JUKE View — JUKEBOXX Design Album Rollout

**Artist / identity:** Johnny Jukebox  
**Project:** JUKEBOXX — Design Album Rollout  
**Tool:** JUKE View, an offline, single-file HTML visual annotation and review board.

## Quick start
1. Download **index.html** from this folder, then open it in Chrome, Edge, or Safari.
2. Upload images, PDFs, HTML mockups, or text/Markdown references.
3. Use **Pen / Circle / Box / Highlight / Note / Erase** with a mouse, pen or touch.
4. Type feedback in the right sidebar, click **Place note on design**, and tap the area.
5. Export **review JSON** for all supported formats, or **marked-up PNG** for image boards.

The **sample concept** is only a placeholder, not the approved Johnny Jukebox identity. Original media and finished assets will be added after visual approval.

## Files
- `index.html`: working local HTML annotation studio.
- `obsidian/JUKEBOXX — Project Hub.md`: project dashboard, templates and source policy.
- `obsidian/JUKE View — Review Workflow.md`: instructions to annotate and hand off designs.
- `Install-to-Obsidian.ps1`: opt-in script copying only the two notes into the existing master vault.
- `.gitignore`: excludes unpublished audio, high-resolution originals, and sensitive files.

## Suggested structure for later album assets
- `assets/source/` — untouched photos, logos, documents and rights metadata (not committed by default)
- `assets/approved/` — locked visual outputs
- `assets/working/` — drafts and annotated review bundles
- `rollout/` — cover art, singles, digital promos, press, merchandise and launch deck

## Current limits
- Boards are **in-memory until exported**; reopening the HTML does not reload previously uploaded source files.
- Exported JSON stores markup and notes, but **not the actual image/PDF/HTML binaries**. Re-upload originals with matching filenames before importing saved review.
- Browser-local HTML/PDF previews may not permit interaction while annotation mode is active. This is intentional so drawings land on the overlay.
- PNG export works for image boards, not embedded documents or the built-in demo.
- No cloud account, server, or automatic AI edits. AI changes are a later step after feedback is collected.

## Obsidian
The optional PowerShell installer targets the established master vault at `C:\Users\zeegr\Documents\Obsidian Master Vault`; it **refuses to create a new vault** and requires the existing `.obsidian` directory. It changes only the named JUKEBOXX notes. Read the script before running it.

## Version and safety
v0.1, 2026-11-06. Open locally; preview files are not uploaded by this app. Review project artwork rights, artist likeness consent, font licenses and release permissions before publishing.
