# Spotify Setup

This project uses Spotify Web Playback SDK + Web API.

Current Spotify documentation:
- https://developer.spotify.com/documentation/web-playback-sdk
- https://developer.spotify.com/documentation/web-api/tutorials/code-pkce-flow
- https://developer.spotify.com/documentation/web-api/concepts/authorization

Spotify Web Playback SDK requires a Spotify Premium account.

## 1. Create the Spotify developer app

1. Sign in at the Spotify for Developers dashboard.
2. Create a new app.
3. Enable Web API / Web Playback use as appropriate in the dashboard.
4. Add this exact redirect URI:

```text
http://127.0.0.1:4173/
```

For the on-device portal, keep the browser pointed at the loopback address so the redirect URI stays local to the Pi.

## 2. Copy the Client ID

Do not copy the Client Secret into this project.

On the Pi:

```bash
cd ~/open-design/projects/blink-connected-portal
cp .env.example .env
nano .env
```

Set:

```text
SPOTIFY_CLIENT_ID=YOUR_CLIENT_ID
SPOTIFY_REDIRECT_URI=http://127.0.0.1:4173/
```

Save the file.

## 3. Scopes used

The portal requests:

```text
streaming
user-read-email
user-read-private
user-read-playback-state
user-modify-playback-state
```

These allow the browser player to identify the user, become a playback device, read current playback, and control playback.

## 4. First login

1. Start the portal.
2. Open `http://127.0.0.1:4173`.
3. Press **CONNECT**.
4. Sign in to Spotify.
5. Approve the requested permissions.
6. Spotify returns to the portal.
7. The device should appear as **BLINK Portal** in Spotify Connect.

## 5. If audio does not start

- Confirm the Spotify account is Premium.
- Confirm the Pi has working audio before testing Spotify.
- Confirm the exact redirect URI in Spotify matches the `.env` value.
- Confirm Chromium is not blocking media playback.
- Press a visible play control once; browsers can require user interaction before audio starts.
- Check `http://127.0.0.1:4173/api/health`.
- Reconnect Spotify if the authorization was revoked.

## Token handling

The sample uses Authorization Code with PKCE. It stores the short-lived access token in session storage and the refresh token locally on the single-user device. Do not expose the portal to the public internet.
