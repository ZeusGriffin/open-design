# LESS Control Room — v0.1

A local-first, modular browser prototype implementing a practical starter around seven ideas from Riley Brown's [October 22, 2026 video](https://youtu.be/4PO0x-myitw). Original code; not the presenter's app.

## Open

Open `index.html` in Chrome, Edge, or Safari. For a local HTTP server, from `app/` run `python -m http.server 8000` and visit `http://localhost:8000`.

The prototype uses native HTML/CSS/JavaScript, no dependencies, and `localStorage` on this browser/device. Its five active classes of tool are: URL launcher, review queue, prompt/storyboard builders, transcript rules, and notes/tasks. The device checklist is planning only. No email connections, AI API calls, TV changes, firmware modifications, or video rendering are performed by the app.

## UI adjustments

Select **Tune UI** to edit accent color, density and corner radius. To change layout, edit `style.css`. To change features, edit `app.js`. Use **Export data** to back up notes before resetting browser storage. Use **My workspace > Export for Obsidian** for a Markdown note.

## Tests

Smoke checks: navigate all eight pages; add TV service; save device plan; tick device step; save storyboard; triage item; build agent prompt; analyze sample transcript; save note/task; export Obsidian Markdown and JSON; import backup after confirming. Do not store credentials or confidential company information in this demo. Storage is not encrypted.

## Next phases

1. Visual approval; preserve baseline and change only requested UI.
2. Device-specific launcher research (LG webOS / Android TV etc). Never assume OS flashing or package removal is supported.
3. Optional model adapter for prompt tasks, with opt-in API key and rate limits.
4. Approved read-only inbox integration; no automatic destructive actions.
5. Blender integration and timeline export; keep original media untouched.

Sources and prompts are in neighboring folders of the downloadable project kit.