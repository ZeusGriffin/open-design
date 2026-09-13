# ZUZ Cyber D — iPhone 15 Bambu cyberdeck

Revision: **0.2 print prototype**

A Bambu-oriented clamshell cyberdeck inspired by the supplied phone + compact-keyboard YouTube build. This is a new iPhone 15 design, not a claim of exact reverse-engineering of the video's enclosure or keyboard.

## Design target
- Chassis footprint: **170 × 105 mm**
- Bare iPhone 15 engineering envelope used: **147.64 × 71.63 × 7.81 mm**
- Initial phone XY clearance: **0.35 mm per side**
- Base height: **22.5 mm**
- Lid height: **12.5 mm**
- Default keyboard candidate: **Rii i4, 155 × 89 × 16.5 mm** — measure your physical keyboard before freezing the tray
- Intended final shell material: **PETG**; PLA is fine for fit tests
- Fits within the 180 mm A1 mini-class bed envelope; larger Bambu printers are also fine

## Print workflow
1. Print phone fit gauges first at 0.35 mm clearance.
2. Confirm the M3 hinge-bore fit.
3. Generate/export the production STEP/STL/3MF geometry from `cad/generate_core.py`.
4. Open each generated plate in Bambu Studio, choose the exact printer and filament, slice, preview, then Send/Print.
5. Print base, lid, phone system, keyboard system, then hinge/latch hardware.
6. Blender is intentionally last and is only for visualization or non-dimensional cosmetic work.

## Mechanical architecture
- Separate base shell and lid frame
- Removable rigid phone carrier
- Three printable corner retainers plus one camera-side retainer so the camera opening does not weaken a corner
- Removable keyboard tray plus printable retainers
- Two replaceable friction hinges using printed leaves and M3 steel hinge pins
- Replaceable printed front latches
- Broad camera and USB-C/service clearance rather than tiny decorative openings

## Important
The generated meshes were software-checked as watertight in the local build used to create this revision. That does **not** replace physical fit testing on the exact printer, material, and iPhone. Never force the phone into a rigid printed gauge.

The complete ready-to-open 3MF/STEP/STL package is maintained alongside this source workflow; the chat build also includes Bambu plate files for base, lid, phone system, keyboard system, and hinge/latch hardware.