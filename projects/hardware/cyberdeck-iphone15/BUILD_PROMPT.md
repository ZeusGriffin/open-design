# Reusable build prompt — iPhone 15 CyberDeck

Use Karpathy-style small changes, baseline lock, and evidence-first verification.

Inspect https://github.com/cobanov/cyberdeck and preserve original files and license notices. Pin a specific upstream commit before modifying. Build a separate parametric adapter for the **standard iPhone 15**, nominal dimensions 147.6 x 71.6 x 7.8 mm. First create a slate prototype, then a clamshell variant. Account for camera island, buttons, speaker, USB-C plug clearance, optional case, MagSafe alignment, and 3D printing tolerance. Confirm keyboard model and physical measurements from the upstream BOM before designing a cradle. Avoid blocking antennas, ports, or camera. Never assume a print fits without a physical test.

Deliver: editable CAD source, build script, STL test tray, assembly/BOM notes, README, screenshots/renders, license attribution, and fit-test checklist. Share common parameters with future Whisplay/Pi Zero, Cardputer ADV, ESP32 and BASE variants but keep hardware-specific configurations separate.

Verification gate: syntax/import check; export succeeds; measured model bounds match design; physical test fit; port and button access; keyboard pairing; clamshell hinge clearance. Report blockers explicitly. Do not claim tested until actual hardware test.
