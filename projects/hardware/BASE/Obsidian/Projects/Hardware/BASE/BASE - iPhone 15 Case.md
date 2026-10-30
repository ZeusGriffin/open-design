---
title: BASE — iPhone 15 Case
aliases: [BASE, BASE 01, BASE 02]
tags: [hardware, phone-case, iphone15, CAD, 3d-printing, projects]
status: prototype-cad
version: 0.1
updated: 2026-10-30
---
# BASE — iPhone 15 Case

> [!important] Fit not verified
> Initial **standard iPhone 15** concept CAD; measurements for camera/buttons and electronics require a real-device fit test.

## Intent
An iPhone 15 case closely evoking the white/orange sloped-screen industrial design of **Pamir AI Lapis One**, with a rear USB opening and an optional screen variant. Independent design, not an official Pamir product.

## Versions
- **BASE 01**: white case, orange sloped rear pod, dark dummy display, small circular detail, bottom charging access, rear USB *access aperture only*.
- **BASE 02**: same, with LCD recess and black bezel for potential Waveshare 1.9-inch SPI display, plus future microcontroller and power design.

## Fit and engineering facts
- Apple iPhone 15: **147.6 × 71.6 × 7.8 mm**, USB-C.
- Original Lapis One: **85 × 85 × 28 mm**. Exact external replication is impossible without exceeding the width of the phone, so BASE scales/adapts the form.
- Proposed screen: Waveshare 1.9-inch, **51.2 × 27.3 mm module**, 170×320, **42.72 × 22.70 mm visible**; board thickness + pin header needs measuring.
- Rear USB port is **not yet functional**. Cutout included only; matched hardware and strain relief not chosen.

## CAD
`cad/BASE_iPhone15.scad` in `ZeusGriffin/open-design/projects/hardware/BASE` or the local BASE project kit.

## Current checklist
- [x] Verify original styling and primary source specs
- [x] Verify iPhone 15 published envelope
- [x] Draft editable parametric CAD for both BASE versions
- [x] Draft rear USB aperture and LCD pocket
- [ ] Physical fit test on standard iPhone 15 / dimensioned dummy
- [ ] Confirm accurate camera + buttons + speaker cutouts
- [ ] Confirm USB-C extender specification & strain relief
- [ ] Test Waveshare 1.9-inch board thickness + connector
- [ ] Select controller, screen firmware and powering approach
- [ ] Finalize 3D print dimensions and colors

## Research
- [Pamir official](https://www.pamir.ai/)
- [Pamir shop](https://shop.pamir.ai/products/lapis-one-white)
- [iPhone 15 tech specs](https://support.apple.com/en-us/111831)
- [Waveshare LCD](https://www.waveshare.com/1.9inch-LCD-Module.htm)

## Next smallest test
Print the **fit coupon**, check it against a normal iPhone 15, and mark any clash. Then adjust the SCAD variables only (baseline lock).
