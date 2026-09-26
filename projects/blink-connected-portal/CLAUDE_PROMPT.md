# Claude / Coding Agent Prompt — BLINK Connected Portal

You are working in:

`ZeusGriffin/open-design/projects/blink-connected-portal`

Reference:
`https://youtube.com/shorts/vN_KR73SPIQ?is=9OwamTzgErHi73cJ`

Goal:
Build and maintain a small internet-connected portal that preserves the approved visual direction from the reference while adding real connectivity, app launching, and Spotify playback.

Non-negotiable rules:
1. Preserve the current approved visual baseline. Do not redesign unrelated elements.
2. Make only requested changes.
3. Keep the main host as a Raspberry Pi/Linux browser kiosk unless the user explicitly changes hardware.
4. Use the existing Node launcher API for native apps. Never expose arbitrary shell execution.
5. Use Spotify Authorization Code with PKCE for browser-side user authorization. Never commit a Spotify client secret, access token, refresh token, password, SSH key, or .env.
6. Spotify playback must use supported Spotify Web Playback/Web API behavior. Do not fake playback.
7. App entries must be allowlisted in config/apps.json.
8. Keep the portal usable by touch and landscape/portrait tolerant.
9. Test the target at 127.0.0.1:4173 before delivery.
10. Verify: service starts, portal renders, app launcher works, Spotify login works, player becomes ready, and audio controls work.
11. If a change affects the enclosure or physical layout, stop at a visual mock/spec until approved.
12. Keep the source video URL in the documentation.

Start by reading:
- README.md
- docs/END_TO_END_BUILD.md
- docs/ARCHITECTURE.md
- docs/SPOTIFY_SETUP.md

When making changes, report:
- files changed,
- behavior changed,
- verification performed,
- anything still blocked by missing hardware or visual reference.
