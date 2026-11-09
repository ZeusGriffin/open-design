# PLUG checkpoint PLUG-2026-11-09-02

Live: https://plug-firmware-command.zeusonsora.chatgpt.site

## Added
- Visual screen builder: custom 32–1024 px dimensions, aspect-correct SVG preview, touch/mouse dragging, numeric positions and sizes, text/buttons/panels/image layers.
- Hardware control-layout schematic; example screen sizes require exact device confirmation.
- UI gallery snapshots, reopen as new projects, JSON export.
- LVGL 9 starter C export: text, buttons, panels and geometry. Images, fonts, animation and event integration require additional work. Not an official LVGL editor embed; documentation linked.
- Authenticated browser cloud snapshot save/restore, revision conflict checks, per-user R2 keys.
- MCP /mcp: plug_read_workspace, plug_save_draft, plug_list_drafts. Agents can read an explicitly saved snapshot and create review-only drafts. No autonomous schedule, compile, flash or format tools.
- Existing firmware tracker, design references, SD preparation guide, local checkpoints and templates retained.

## Restore source layout
Copy index.html to source/index.html; plug-api.js to worker/plug-api.js; build-plug.mjs to scripts/build-plug.mjs; hosting.json to .openai/hosting.json for the SAME Site. Do not reuse its project identity when creating another Site. Run node scripts/build-plug.mjs. Worker output: dist/server/index.js. The manifest declares R2 binding BUCKET and MCP capability.

## Verified
JavaScript and Worker syntax; automated builder geometry/gallery checks; mocked API identity isolation, save/read, drafts and stale-revision rejection. Browser preview renders builder and changes to 128x64 successfully. Deployed MCP plugin provisioned and reported installed. Live private browser asked for sign-in, so real signed-in cloud save/restore, R2 concurrency and physical iPhone dragging still require user testing.

## Test next
1. Open Site and choose Screen builder.
2. Choose exact screen dimensions; add and drag an element.
3. Save to UI gallery and reopen a copy.
4. Open Agents, check cloud status, then save workspace.
5. Invoke PLUG agent tools from a connected new chat if they are not visible in the current chat.
6. Review agent drafts in Agents. Export a local backup before restoring cloud data.

## Still not implemented
Actual firmware flashing (USB/Bluetooth/Wi-Fi), hosted compilation, direct SD formatting, firmware image/font conversion, full LVGL runtime simulation and automated design-to-firmware integration.

## Resume
Continue PLUG-2026-11-09-02. Preserve the existing iPhone-first direction and local user data. Start with signed-in cloud/API testing and the exact device+DFU app identification before implementing a real flashing transport. Do not claim generic universal firmware updates.
