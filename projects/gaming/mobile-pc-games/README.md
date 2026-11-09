# Mobile PC Gaming — source and porting research

Source video: https://youtu.be/0uKdbDqiuYs
Screenshot title: “Your Phone Can Actually Run Steam Games Now” (Switch and Click).

## Verified open-source references
- Android GameNative: https://github.com/rtmtree/GameNative-iOS (repository name is misleading; project README describes Android).
- iOS Playport: https://github.com/playportdev/playport
- Android Winlator: https://github.com/brunodev85/winlator

## Architecture
Windows games require an x86 translation/compatibility runtime (e.g. FEX or Box64), Wine, graphics translation (DXVK/VKD3D) and GPU drivers. Do not mistake Steam Link streaming for local execution.

## Targets
1. Android phone / handheld: assess GameNative source, build instructions and license; test one owned DRM-compatible game.
2. iPhone 15 Pro: evaluate Playport's actual iOS version and device support before trying to build; separate implementation from Android.
3. Raspberry Pi Zero 2 W: hardware insufficient for modern Windows Steam games; only consider lightweight native ports/streaming.
4. ESP32 / LILYGO / Cardputer ADV: cannot run Windows Steam games; can serve as external controller/display accessory.

## Next steps
- Confirm exact app demonstrated in the linked video from transcript/description (not verified).
- Audit source licensing and dependencies before forking.
- Build a device capability matrix and an original launcher UI prototype.
- Test on physical target devices before claiming compatibility.

Status: research note only; no executable port built or tested. Obsidian sync pending (no connected Obsidian writer available).
