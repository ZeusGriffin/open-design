# BLINK Connected Portal — End-to-End Build

## Outcome

When finished, power on the device and it will:

1. Join Wi-Fi.
2. Start the local portal service.
3. Open Chromium full-screen to the portal.
4. Show app tiles.
5. Open approved web apps and local Linux apps.
6. Connect to Spotify and play/control music through the portal.
7. Output sound through your chosen speaker.

## Hardware

Recommended:
- Raspberry Pi 4 (2 GB+) or Pi 5.
- 32 GB+ microSD.
- 4-7 inch HDMI or DSI touchscreen.
- Correct power supply for the Pi.
- Speaker: USB, HDMI, Bluetooth, or I2S.

Smaller option:
- Pi Zero 2 W. It works for a compact build, but Chromium and Spotify are slower.

## A. Assemble the hardware

1. Leave power disconnected.
2. Mount the Pi behind or inside the enclosure.
3. Connect the touchscreen video cable:
   - DSI screen -> Pi DSI connector, or
   - HDMI screen -> Pi micro-HDMI/HDMI output.
4. Connect touchscreen USB if the display requires USB for touch.
5. Connect the speaker.
6. Insert the microSD only after Raspberry Pi OS has been written.
7. Connect power last.

Do not finalize an enclosure until the reference video's visual layout and your exact screen dimensions are approved.

## B. Install Raspberry Pi OS

Use Raspberry Pi Imager and install Raspberry Pi OS with Desktop.

Before writing the card, configure:
- device name: `blink-portal`
- Wi-Fi SSID/password
- username/password
- SSH: optional but useful

Boot the Pi and let the desktop finish first-run setup.

## C. Verify Wi-Fi and audio first

Open Terminal.

```bash
ping -c 3 spotify.com
```

You need successful replies.

Test the selected sound output before doing portal work. Use Raspberry Pi audio settings to select HDMI, USB, Bluetooth, or the correct output device.

## D. Install software

```bash
sudo apt update
sudo apt install -y git nodejs npm chromium
node --version
npm --version
```

If Raspberry Pi OS names the browser `chromium-browser` instead of `chromium`, use that name in the autostart command later.

## E. Clone the repository

```bash
cd ~
git clone https://github.com/ZeusGriffin/open-design.git
cd ~/open-design/projects/blink-connected-portal
npm install
```

## F. Configure Spotify

Follow `docs/SPOTIFY_SETUP.md`.

At minimum:

```bash
cp .env.example .env
nano .env
```

Add your Spotify Client ID. Never add a client secret.

## G. Test the portal manually

```bash
npm start
```

Open Chromium and go to:

```text
http://127.0.0.1:4173
```

Check:
- PORTAL title appears.
- network status says online.
- app tiles appear.
- YouTube and ChatGPT tiles open.
- local Files/Terminal tiles work if those app commands exist.
- Connect Spotify completes login.
- BLINK Portal appears as the Spotify playback device.
- play/pause/previous/next work.

Stop the test server with Ctrl+C after verification.

## H. Add or remove app tiles

Edit:

```bash
nano config/apps.json
```

Web app example:

```json
{
  "id": "maps",
  "label": "Maps",
  "kind": "url",
  "url": "https://maps.google.com/"
}
```

Local app example:

```json
{
  "id": "calculator",
  "label": "Calculator",
  "kind": "local",
  "command": "galculator",
  "args": []
}
```

Only put fixed trusted commands in this file.

## I. Make the server start automatically

Create a systemd service:

```bash
sudo nano /etc/systemd/system/blink-portal.service
```

Paste:

```ini
[Unit]
Description=BLINK Connected Portal
After=network-online.target graphical.target
Wants=network-online.target

[Service]
Type=simple
User=YOUR_PI_USERNAME
WorkingDirectory=/home/YOUR_PI_USERNAME/open-design/projects/blink-connected-portal
ExecStart=/usr/bin/npm start
Restart=on-failure
Environment=NODE_ENV=production

[Install]
WantedBy=graphical.target
```

Replace `YOUR_PI_USERNAME`.

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now blink-portal.service
systemctl status blink-portal.service
```

You want `active (running)`.

## J. Make Chromium open the portal at login

Create the autostart directory if needed:

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/blink-portal.desktop
```

Paste:

```ini
[Desktop Entry]
Type=Application
Name=BLINK Portal
Exec=chromium --app=http://127.0.0.1:4173 --start-fullscreen --no-first-run
X-GNOME-Autostart-enabled=true
```

If your system uses `chromium-browser`, replace the executable name.

Reboot:

```bash
sudo reboot
```

## K. Physical finishing

After software passes:
- confirm touch targets are easy to hit,
- confirm speaker openings are not blocked,
- provide airflow around the Pi,
- strain-relieve HDMI/USB-C cables,
- keep the microSD accessible,
- keep the power button/connector accessible,
- only then lock the enclosure design.

For a 3D-printed version, use the user's normal screwless/magnet-first approach where practical.

## L. Final verification

Power the unit completely off and back on.

PASS means:
- Wi-Fi reconnects without opening settings.
- portal service starts by itself.
- Chromium opens the portal by itself.
- touch works.
- web app tiles open.
- local app tiles open.
- Spotify login survives normal restart or can refresh cleanly.
- Spotify device is visible.
- audio plays from the intended speaker.
- no passwords, tokens, or `.env` are present in GitHub.

## Important limitation

The reference YouTube Short is saved as the visual baseline, but the exact physical dimensions, screen model, and frame-by-frame UI cannot be guaranteed until the reference is available as still images or screenshots. Do not redesign the visual shell from guesses; use this repository as the working functional base and lock the visual after approval.
