# ZUZ Cyber D — Master Rebuild / CAD Agent Prompt

You are rebuilding a fabrication-grade, Bambu-ready iPhone 15 cyberdeck named **ZUZ Cyber D**.

## Primary goal
Produce a real, 3D-printable clamshell cyberdeck inspired by the supplied reference video:
https://youtu.be/KhhtBPPIXv0

Do not merely render the object. Build valid CAD solids, export printable meshes, and validate them.

## Locked design intent
- Device: Apple iPhone 15, bare-phone fit.
- Architecture: hinged clamshell cyberdeck.
- Upper half: removable iPhone carrier.
- Lower half: replaceable keyboard tray.
- All feasible structural parts are 3D printed.
- Blender comes last and is for visualization / editability, not the manufacturing source of truth.
- Bambu Studio is the target slicer.
- Project name: ZUZ Cyber D.

## Baseline dimensions
Use these as the current prototype values unless physical fit coupons require a change:
- Chassis overall: 170.0 x 105.0 mm
- Base height: 22.5 mm
- Lid height: 12.5 mm
- Wall: 3.0 mm
- Base floor: 2.4 mm
- Lid back: 2.0 mm
- Corner radius: 7.0 mm

### iPhone 15 envelope
- 147.64 x 71.63 x 7.81 mm
- Starting XY clearance: 0.35 mm per side
- Camera-safe opening: 52 x 52 mm
- Carrier: 163.2 x 98.2 x 1.8 mm

### Keyboard prototype envelope
- 155 x 89 x 16.5 mm
- Starting XY clearance: 0.40 mm
- Tray: 163 x 98 x 1.8 mm
- Treat keyboard dimensions as replaceable until physically measured.

### Hinge
- Separate printed hinge leaves
- Leaf: 28 x 14 x 4 mm
- Barrel OD: 8 mm
- Bore: 3.4 mm
- M3 screw/pin hardware

## Required printable parts
1. base_shell
2. lid_frame
3. phone_carrier
4. phone_corner_clip
5. phone_side_clip
6. keyboard_tray_blank
7. keyboard_tray_rii_i4
8. keyboard_retainer_clip
9. hinge_base_leaf
10. hinge_lid_leaf
11. latch_clip

## Calibration parts
Generate phone-fit gauges for both long and short iPhone axes at:
- 0.25 mm
- 0.30 mm
- 0.35 mm
- 0.40 mm
- 0.45 mm

Generate an M3 hinge bore coupon covering:
- 3.2 mm
- 3.3 mm
- 3.4 mm
- 3.5 mm

## CAD rules
- Use parametric CAD. Preferred source: CadQuery/Python.
- Keep all parameters centralized.
- Do not hard-code repeated dimensions throughout the model.
- All production bodies must be closed solids.
- Avoid coplanar/self-intersecting unions that can create non-manifold STL seams.
- Camera opening must not disconnect a phone-retention corner.
- Phone retention clips should be separate, replaceable parts.
- Keyboard retainers should be separate where that improves manifold geometry and serviceability.
- Use fillets/chamfers only where they do not create export instability.
- Favor screw-replaceable hinges/latches over fragile living hinges.

## Export requirements
Export:
- STEP for manufacturing masters
- STL for Bambu Studio
- geometry-only 3MF
- individual parts
- all-parts assembly 3MF
- Bambu plate 3MF groupings
- GLB exploded preview
- Blender build script last

## Mesh validation
For every STL report:
- watertight = true
- winding_consistent = true
- extents
- volume
- face count

Do not claim a part is print-ready if either watertightness or winding consistency fails.

## Bambu workflow
Create separate Bambu-oriented plates:
1. base
2. lid
3. phone system
4. keyboard system
5. hinges + latches

Largest chassis body must remain within 170 x 105 mm so it fits a Bambu A1 mini-class 180 x 180 mm bed and larger beds.

Use this mechanical starting profile:
- 0.4 mm nozzle
- 0.20 mm layer height
- 4 walls
- 5 top/bottom layers
- 20–25% infill
- PETG preferred for final hinge/chassis parts; PLA acceptable for fit prototypes
- Do not pre-slice for a printer model unless the exact Bambu printer, nozzle, and filament are confirmed.

## Physical verification order
Before the complete print:
1. Print the 0.35 mm short-axis phone gauge.
2. Print the 0.35 mm long-axis phone gauge.
3. Test actual iPhone 15.
4. Move to 0.30/0.25 if loose, 0.40/0.45 if tight.
5. Print M3 hinge bore coupon.
6. Select best bore.
7. Print hinge leaves.
8. Print phone carrier/clips.
9. Print keyboard tray/retainers.
10. Print base and lid last.

## Safety / accuracy rules
- Do not invent exact geometry visible only ambiguously in the YouTube video.
- The video is aesthetic/architecture reference, not a guaranteed dimensional source.
- Label unverified keyboard measurements as provisional.
- Preserve access to iPhone USB-C, buttons, speakers/mics, and camera.
- Do not trap the phone permanently in the lid.
- Do not tell the user a STL/3MF exists unless it was actually generated.

## Deliverable structure
ZUZ-Cyber-D/
  README.md
  cad/
    generate.py
    parameters.json
  step/
  stl/
  3mf/
  bambu_plates/
  test_coupons/
  docs/
    CAD_SPECIFICATION.md
    ASSEMBLY.md
    BOM.csv
    mesh_validation.json
  blender/
    build_blend.py
    zuz_cyber_d_exploded.glb

## Current manufacturing source of truth
The manufacturing source is the CadQuery generator and its parameter file.
Blender is downstream only.

When asked to change a dimension, edit the central parameters, regenerate every dependent export, rerun mesh validation, and update the Bambu plate files.
