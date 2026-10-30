# BASE — iPhone 15 Case

**Status:** parametric mechanical prototype v0.1, not yet physically fit-tested. **First target: standard iPhone 15**, not the Pro, Plus or Pro Max.

BASE is an original iPhone case inspired by Pamir AI's **Lapis One** computer: white body, orange angled display housing, black screen, rounded corners and circular detail. BASE is not affiliated with Pamir and does not reproduce its computer hardware or AI functionality.

## Variants

- **BASE 01:** protective case + decorative wedge + black blank screen insert + rear USB access aperture. The access aperture is **not a working second USB-C port** without separate electronics.
- **BASE 02:** the same case, but the wedge has a recessed pocket and black bezel for a **prospective Waveshare 1.9-inch LCD**. LCD integration is mechanical only and has not been fit- or power-tested.

## Verified source dimensions
- Apple standard iPhone 15: **147.6 × 71.6 × 7.8 mm**, USB-C at bottom.
- Pamir AI Lapis One: **85 × 85 × 28 mm**. Its exact full-size form cannot fit on a 71.6-mm-wide iPhone without an overhang.
- Waveshare 1.9-inch LCD Module SKU 23822: **51.2 × 27.3 mm** board footprint; visible display **42.72 × 22.70 mm**, resolution 170 × 320. Thickness, pins and cable exit must still be measured.

## CAD

Main source: [cad/BASE_iPhone15.scad](cad/BASE_iPhone15.scad). Load it in [OpenSCAD](https://openscad.org). Change `version` to `BASE01` or `BASE02`, and `part` to `shell`, `wedge`, `insert`, `bezel`, or `fit_coupon`. Press F6 to render and export STL.

Design assumptions: initial 0.5mm clearance per side, 2mm TPU shell walls, provisional camera cutout 36×36mm, provisional button reliefs, rear USB access 15×8mm. None of these unverified values should be treated as production tolerances.

## Print and verification sequence

1. Print `fit_coupon` and check fit on a **regular iPhone 15**.
2. Check rear lens, flash, buttons, mic/speaker and bottom USB-C clearance. Update SCAD fit variables without changing style.
3. Print white **TPU** main shell; avoid forcing a rigid prototype around the glass.
4. Print orange **PETG** wedge and black dummy insert for BASE 01; attach after a dry fit.
5. For BASE 02, **measure the actual LCD**, connector and thickness before designing final mount, cable path, power, MCU firmware and iPhone control.

**Mechanical caution:** no functional rear USB-C connector is in this design. For one, choose a real right-angle extension and add an isolated cable channel and strain relief so the phone's native USB-C socket is not side-loaded. Likewise, an LCD panel needs its own controller and power scheme; do not assume the iPhone directly drives a bare SPI panel. No drop or thermal safety certification exists.

## Obsidian
Suggested note in existing master vault:
`Projects/Hardware/BASE/BASE - iPhone 15 Case.md`.

The separate [BASE project ZIP](sandbox:/mnt/data/BASE_iPhone15_Project_Kit.zip) produced in ChatGPT contains generated, verified STLs, the Obsidian-ready Markdown note, and `Install-to-Obsidian.ps1`. A sandbox URL is session-bound; this repository source is canonical.

## Sources
- https://www.pamir.ai/
- https://shop.pamir.ai/products/lapis-one-white
- https://support.apple.com/en-us/111831
- https://www.waveshare.com/1.9inch-LCD-Module.htm
