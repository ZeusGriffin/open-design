# Master Build Prompt — Tap Wallpaper Maker

Build a polished mobile-first application named **Tap Wallpaper Maker** for **925 Studios**, credited **Made by ZUZ**.

## Product goal

Create an easy wallpaper studio where a person can upload or generate an original image, separate it into depth layers, add refined touch or parallax movement, preview it on a phone, and export everything needed to use or continue editing the wallpaper.

The reference link is https://youtu.be/ijF3A3pl8NE. Treat it only as inspiration. Do not copy protected artwork, branding, layouts, or source code. If the video cannot be inspected, say so and rely only on this written specification.

## Audience

People who want premium interactive-looking phone wallpapers without animation, masking, or coding experience.

## Required flow

### 1. Start screen
- Large “Create Wallpaper” action.
- Options: Upload Image, Start From Layers, Generate Background, Open Saved Project.
- Small 925 Studios mark.
- “Made by ZUZ” credit in the About panel.

### 2. Canvas
- Default preset: iPhone 15 portrait, 1179 × 2556.
- Also support common phone portrait ratios and a custom size.
- Keep the safe area, clock area, Dynamic Island area, and crop boundary visible as toggles.
- Use non-destructive edits.

### 3. Layer preparation
- Suggest foreground, middle, and background layers.
- Include masking brush, erase, feather, refine edge, restore, rename, reorder, duplicate, hide, lock, and delete.
- Never pretend automatic masks are exact; make correction fast.
- Fill revealed gaps behind moving layers with an original generative fill or a user-selected background treatment.
- Preserve the original source image.

### 4. Motion designer
Provide these effects:
- Tap Pulse: a soft ripple, light bloom, or depth push from the tapped point.
- Touch Follow: selected layers move slightly toward or away from the finger.
- Parallax Tilt: layers shift using device orientation when permission is available.
- Cloud Drift: slow independent movement for cloud or fog layers.
- Light Sweep: a restrained highlight moves across selected regions.
- Living Still: subtle breathing zoom and depth motion.

Controls:
- Strength
- Speed
- Direction
- Depth
- Damping
- Return spring
- Loop on/off
- Interaction area
- Focus point
- Layer participation
- Motion blur
- Reduced Motion preview

Motion should be elegant and restrained. Default maximum displacement should be roughly 1–3% of the canvas dimension. Avoid jerky movement and excessive zoom.

### 5. Live phone preview
- Show a realistic phone-frame preview and a full-screen preview.
- The preview must be directly editable: tap a layer to select it, drag the focus point, and adjust the visible crop.
- Support pointer, touch, and mouse input.
- Provide a permission-aware device tilt preview plus a manual simulation fallback.
- Include before/after and still/motion toggles.
- Keep the preview responsive at 60 fps on a modern phone when practical.
- Do not claim performance until measured on a real device.

### 6. Export
Export:
- High-resolution still wallpaper in PNG or HEIC when supported.
- Layered ZIP with transparent PNG layers.
- JSON motion recipe containing canvas dimensions, layer order, transforms, motion parameters, and safe-area data.
- MP4 or WebM preview loop.
- Shareable project file for reopening in the app.

Branding behavior:
- “Made by ZUZ” is an optional small export credit, on by default.
- “925 Studios” appears in project metadata and the About screen.
- Never burn branding into the user’s source image without showing it in preview first.

## Visual direction

Use a quiet premium interface:
- Near-black, warm gray, cloud white, and restrained silver.
- Large image-led canvas.
- Thin dividers, soft rounded panels, minimal shadows.
- Clean geometric sans-serif type with compact technical labels.
- Controls should recede while the artwork remains dominant.
- Avoid crowded dashboards, neon cyberpunk styling, and fake Apple branding.

## Technical approach

Use a modern TypeScript web stack suitable for installation as a PWA. Use WebGL or a performant canvas renderer for compositing and animation. Keep image processing in a worker where practical. Store projects locally first; cloud sync must be optional. Ask for motion-sensor permission only after the user chooses tilt preview.

Build with reusable modules:
- Project model
- Asset importer
- Layer/mask editor
- Motion engine
- Preview renderer
- Export pipeline
- Local project storage
- Accessibility and reduced-motion support

## Privacy and safety

- Do not upload images unless the user explicitly enables a cloud-dependent feature.
- Explain when generative fill or image generation requires an external service.
- Strip location metadata from exports by default.
- Do not scrape or redistribute assets from the reference video.
- Only use artwork the user owns, generated originals, or properly licensed assets.

## Acceptance checks

1. A user can start with one image and produce a three-layer project.
2. Touching the preview visibly moves selected layers and they settle smoothly.
3. Device tilt works after permission, with a manual fallback when unavailable.
4. The iPhone 15 crop and safe-area overlays are accurate for the chosen canvas preset.
5. Exported still dimensions exactly match the selected preset.
6. The layered ZIP reopens without losing order or transparency.
7. The JSON recipe reproduces the same motion settings.
8. Reduced Motion disables continuous movement while preserving editing.
9. Branding is visible in preview before export and can be turned off.
10. No source image is overwritten.

## Verification

Run unit tests for motion math, serialization, canvas sizes, and export naming. Run touch interaction tests in mobile Safari and Chrome. Visually compare exports with the in-app preview. Measure frame rate and input latency on an actual iPhone 15-class device. Report any unverified behavior instead of calling it complete.

## Deliverables

- Working PWA source
- README and setup instructions
- Sample project using original placeholder artwork
- Reusable design tokens
- Automated tests
- Export compatibility notes
- Short device-test checklist
