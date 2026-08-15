# ZEUS Visual Launch Intro

Reusable cinematic opening system for apps, dashboards, websites, prototypes, device UIs, and other Made by Zeus builds.

## Source Reference

Visual reference supplied by Zee:

`https://youtu.be/WHYV3GjmdZY?is=eaQMuCS-PUkXHIoA`

Use the **opening moments of the reference as the motion/energy target**, while keeping this system original and reusable across projects.

---

## Master Prompt Intro

```text
BEGIN WITH THE ZEUS VISUAL LAUNCH INTRO.

The experience must not open like a normal app splash screen. It should feel like a visual system waking up.

Start from a completely dark, edge-to-edge canvas with no visible browser chrome, cards, buttons, navigation, or unnecessary text.

For the first fraction of a second, hold near-black silence. Then introduce one restrained visual signal at the center: a very faint point, line, glow, or precision marker. It should feel intentional and technical, not decorative.

From that origin, allow the interface to reveal itself in layers:

1. A faint central signal appears.
2. Thin structural guide lines / scan lines / framing geometry resolve around it.
3. The ZEUS/project mark becomes visible with a sharp, controlled fade rather than a pop or bounce.
4. The surrounding interface frame begins to form from the same visual language.
5. The actual app UI emerges underneath or through the intro so the animation feels connected to the product, not like a separate video pasted before it.
6. The launch elements dissolve cleanly as the live interface becomes fully interactive.

Motion should be smooth, premium, and restrained. Think precision-engineered product reveal rather than gaming intro. No cartoon easing, no bouncing, no spinning logo, no excessive particles, no generic neon cyberpunk clutter.

The visual hierarchy should remain extremely clean: darkness -> signal -> structure -> identity -> live interface.

Keep the transition fast enough that it feels intentional on repeated launches. The complete sequence should generally land between 2.5 and 4 seconds, with an optional skip/reduced-motion path.

The final frame of the intro must visually match the first frame of the usable application so there is no hard cut.
```

---

## How the Visual Starts

### 0.00–0.35 sec — Black Field
- Full-screen near-black canvas.
- No card in the middle.
- No visible navigation.
- No loading spinner.
- No text yet.
- Hold just long enough to establish contrast.

### 0.35–0.80 sec — First Signal
- A tiny center point, hairline, or soft glow begins to appear.
- Opacity rises slowly from almost invisible.
- The signal should feel like the system has received power.

### 0.80–1.30 sec — Structure Resolves
- Very thin horizontal/vertical guide lines or corner markers extend outward.
- Optional subtle scan pass or focus sweep.
- Keep line weight extremely fine.
- Nothing should fly wildly across the screen.

### 1.30–1.90 sec — Identity
- Project name, monogram, or ZEUS mark resolves into focus.
- Use a short fade + slight tracking/scale correction.
- Avoid a large logo zoom.

### 1.90–2.70 sec — Interface Reveal
- The app shell begins appearing behind/around the identity.
- Panels, data, imagery, or the main product view fade/slide into their actual final positions.
- Intro geometry should align with real UI edges where possible.

### 2.70–3.30 sec — Handoff
- Launch mark and temporary guide geometry fade away.
- The actual interface remains.
- Controls become active.
- No hard cut.

---

## Visual Rules

```yaml
name: ZEUS Visual Launch Intro
purpose: reusable opening visual system
energy: premium, cinematic, technical, restrained
background: near-black / project-native dark tone
opening_state: empty full-screen field
first_visual: tiny precision signal
motion: smooth, controlled, low-amplitude
transition: intro geometry transforms into live UI
logo_behavior: resolve/focus, never bounce
particles: none by default
glow: minimal
text: minimal
sound: optional low-impact pulse or power-on tone
duration_default: 3.2s
repeat_launch_duration: 1.8-2.4s optional
reduced_motion: required
final_state: live interactive product UI
```

---

## Adaptation Variables

Replace these per project:

```text
[PROJECT_NAME]
[PROJECT_MARK]
[PRIMARY_VISUAL]
[FINAL_SCREEN]
[ACCENT_TONE]
[INTRO_DURATION]
```

Example:

```text
Apply the ZEUS Visual Launch Intro to [PROJECT_NAME].
Use [PROJECT_MARK] as the identity reveal.
Transition directly into [FINAL_SCREEN].
Use [ACCENT_TONE] only for the first signal and tiny interface details.
Keep all other behavior from the ZEUS Visual Launch Intro system.
```

---

## Implementation Notes

- Build the intro as a real UI layer, not a prerecorded full-screen video whenever possible.
- Use CSS transforms and opacity for smooth GPU-friendly animation.
- Keep DOM elements in their final layout positions so the transition into the application is seamless.
- Respect `prefers-reduced-motion`.
- Allow the animation to be disabled after first launch if the product needs instant repeat access.
- Use a single animation clock/timeline so all elements stay synchronized.

A reusable React implementation is stored beside this document:

`ZeusVisualLaunchIntro.jsx`

---

## Archive Tag

`ZEUS-VISUAL-LAUNCH-INTRO / reusable / apps / interfaces / product-openings / visual-system`
