# Xorytin HY300 Ultra — Compatibility Notes

Product reference:
https://www.amazon.com/Xorytin-Projector-WiFi-Bluetooth-Built/dp/B0GG4F9DLB

## Identified model family

Public listings for ASIN B0GG4F9DLB identify this projector as the Xorytin HY300 Ultra family.

Reported characteristics:
- Android 11
- Wi-Fi 6
- Bluetooth 5.4
- HDMI + USB
- built-in streaming apps
- native 1280×720 projection
- roughly 170–200 ANSI brightness depending on listing
- 5 W built-in speaker

Important: HY300/HY300 Ultra projectors are commonly sold as white-label hardware, so units with the same retail name may still use different internal boards or software builds.

## Will it work for the BLINK portal?

Yes.

### Best first setup

Use the projector as the display and keep the existing Raspberry Pi BLINK portal as the computer:

Raspberry Pi -> HDMI -> Xorytin projector

Why:
- no projector software changes required
- portal code remains fully under our control
- Spotify/Web Playback runs in a known Chromium environment
- easy rollback and debugging
- projector still keeps its stock streaming apps

### Direct-on-projector test

Because listings report Android 11, the BLINK portal may also run directly in a browser on the projector.

Treat that as a second-stage test because the exact bundled browser/WebView version is not yet known.

## Firmware research plan

Before changing anything on the projector, record:
- Settings > About screen
- Android version
- Build number
- Kernel version
- model / board identifier shown by the device
- storage size
- firmware/update version
- whether Developer Options are available

Photograph these screens first.

Do not install third-party HY300 firmware until the exact hardware revision of the actual unit is confirmed.

## Preferred modification order

1. Test BLINK over HDMI.
2. Test BLINK directly in the projector browser.
3. Test whether a launcher/kiosk app can be used.
4. Only consider deeper firmware changes after the exact hardware/software build is identified and a recovery path is available.

## Spotify

Spotify currently documents Web Playback SDK support in major Android and desktop browsers and requires Spotify Premium for music streaming through that SDK.

If the projector browser has playback, DRM, or autoplay problems, keep Spotify on the Raspberry Pi/Chromium build over HDMI.

## First test checklist

1. Boot the projector normally.
2. Connect Wi-Fi.
3. Photograph Settings > About and the update screen.
4. Test HDMI from the Pi.
5. Open the BLINK portal.
6. Test projector speakers.
7. Test Bluetooth audio.
8. Check Developer Options.
9. Check whether Chrome or another modern browser is available.
10. Test the BLINK portal directly on Android.

## Current recommendation

**Use it:** yes.

**Primary BLINK architecture:** Raspberry Pi over HDMI.

**Secondary option:** run the portal directly on the projector's Android browser.

**Firmware changes:** wait until the actual unit's board/software identity is confirmed.
