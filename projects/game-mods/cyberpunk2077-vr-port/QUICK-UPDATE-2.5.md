# Cyberpunk 2077 VR — QUICK UPDATE (2.5 / VR Port 0.2.3)

Source video: https://youtu.be/6sDvHXDF1yM

## What changed
The current CyberpunkVR Port is now a much simpler install. For the VR port itself, the required stack is:
- Cyberpunk 2077 **2.5**
- CyberpunkVR Port **0.2.3**
- RED4ext **1.31.0+**
- OpenXR runtime

The VR plugin now carries its own Lua host, redscript compiler, archive mounting, TweakDB loading and input merge pieces. The old long dependency list is no longer required just to run VR.

## Best route when you get to the PC
**Use MrSurviv0r VR HUB first.**

1. Close Cyberpunk.
2. Update/open the newest HUB.
3. Select **Cyberpunk 2077**.
4. Click **Install Update**.
5. Let the HUB back up/migrate the older VR install.
6. Start Quest Link, SteamVR or Virtual Desktop/VDXR.
7. Launch Cyberpunk.
8. Complete the VR lobby calibration.

## 60-second test
- Look around: true stereo, no one-eye/flat fallback in normal gameplay.
- Move both controllers: both hands should track independently.
- Draw weapon from holster.
- Aim with hand/controller.
- Reload physically.
- Try melee.
- Enter vehicle and test steering.
- Load a save.
- Confirm Night City Echoes / other non-VR mods still load.

## Important
Do **not** blindly delete CET or the other mod frameworks from your game. They are no longer required by CyberpunkVR Port, but another mod may still depend on them.

If you have a leftover older VR injector such as a separate `dxgi.dll`, identify it before launch. Competing VR injectors should not be active together.

## Direct-official fallback
Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Stage-CyberpunkVR-Update.ps1
```

That stages the pinned official CyberpunkVR Port 0.2.3 and RED4ext 1.31.0 packages under Downloads without modifying Cyberpunk.

Then install from the official upstream instructions.

## Rollback
Before changing the game, preserve:
- `red4ext\plugins\cyberpunkvrport\`
- `bin\x64\vrport.ini` if present
- any old VR DLL/proxy you intentionally disabled
- your current mod inventory
- saves (Steam cloud + a manual copy if desired)

The VR port release includes its own uninstall/cleanup instructions. Keep the backup until the new build passes the 60-second test.
