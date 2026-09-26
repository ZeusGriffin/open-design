const state = {
  config: null,
  token: null,
  refreshToken: null,
  player: null,
  deviceId: null,
  isPaused: true
};

const scopes = [
  "streaming",
  "user-read-email",
  "user-read-private",
  "user-read-playback-state",
  "user-modify-playback-state"
].join(" ");

const grid = document.querySelector("#appGrid");
const spotifyConnect = document.querySelector("#spotifyConnect");
const playBtn = document.querySelector("#playBtn");
const prevBtn = document.querySelector("#prevBtn");
const nextBtn = document.querySelector("#nextBtn");
const trackName = document.querySelector("#trackName");
const trackMeta = document.querySelector("#trackMeta");
const netText = document.querySelector("#netText");
const status = document.querySelector(".status");

function base64url(bytes) {
  return btoa(String.fromCharCode(...new Uint8Array(bytes)))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
}

async function sha256(value) {
  return crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
}

function makeVerifier() {
  const bytes = crypto.getRandomValues(new Uint8Array(64));
  return base64url(bytes);
}

async function beginSpotifyLogin() {
  const verifier = makeVerifier();
  const challenge = base64url(await sha256(verifier));
  localStorage.setItem("spotify_code_verifier", verifier);

  const params = new URLSearchParams({
    client_id: state.config.spotifyClientId,
    response_type: "code",
    redirect_uri: state.config.spotifyRedirectUri,
    code_challenge_method: "S256",
    code_challenge: challenge,
    scope: scopes
  });

  location.href = `https://accounts.spotify.com/authorize?${params}`;
}

async function exchangeCode(code) {
  const verifier = localStorage.getItem("spotify_code_verifier");
  const body = new URLSearchParams({
    client_id: state.config.spotifyClientId,
    grant_type: "authorization_code",
    code,
    redirect_uri: state.config.spotifyRedirectUri,
    code_verifier: verifier
  });

  const response = await fetch("https://accounts.spotify.com/api/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body
  });

  if (!response.ok) throw new Error("Spotify token exchange failed");
  const data = await response.json();
  state.token = data.access_token;
  state.refreshToken = data.refresh_token || null;
  sessionStorage.setItem("spotify_access_token", state.token);
  if (state.refreshToken) localStorage.setItem("spotify_refresh_token", state.refreshToken);
  history.replaceState({}, "", "/");
}

async function refreshAccessToken() {
  const refresh = localStorage.getItem("spotify_refresh_token");
  if (!refresh) return null;

  const body = new URLSearchParams({
    client_id: state.config.spotifyClientId,
    grant_type: "refresh_token",
    refresh_token: refresh
  });

  const response = await fetch("https://accounts.spotify.com/api/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body
  });

  if (!response.ok) return null;
  const data = await response.json();
  state.token = data.access_token;
  sessionStorage.setItem("spotify_access_token", state.token);
  return state.token;
}

async function spotifyFetch(url, options = {}) {
  if (!state.token) state.token = sessionStorage.getItem("spotify_access_token");
  if (!state.token) state.token = await refreshAccessToken();
  if (!state.token) throw new Error("Spotify login required");

  let response = await fetch(url, {
    ...options,
    headers: {
      ...(options.headers || {}),
      Authorization: `Bearer ${state.token}`
    }
  });

  if (response.status === 401) {
    state.token = await refreshAccessToken();
    if (!state.token) throw new Error("Spotify login expired");
    response = await fetch(url, {
      ...options,
      headers: {
        ...(options.headers || {}),
        Authorization: `Bearer ${state.token}`
      }
    });
  }

  return response;
}

async function transferPlayback(deviceId) {
  await spotifyFetch("https://api.spotify.com/v1/me/player", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ device_ids: [deviceId], play: false })
  });
}

function enableControls(enabled) {
  playBtn.disabled = !enabled;
  prevBtn.disabled = !enabled;
  nextBtn.disabled = !enabled;
}

function initSpotifyPlayer() {
  if (!window.Spotify || !state.token) return;

  const player = new Spotify.Player({
    name: "BLINK Portal",
    getOAuthToken: async (cb) => {
      let token = state.token || sessionStorage.getItem("spotify_access_token");
      if (!token) token = await refreshAccessToken();
      cb(token);
    },
    volume: 0.6
  });

  player.addListener("ready", async ({ device_id }) => {
    state.deviceId = device_id;
    trackMeta.textContent = "BLINK Portal is available as a Spotify device.";
    spotifyConnect.textContent = "CONNECTED";
    enableControls(true);
    try { await transferPlayback(device_id); } catch {}
  });

  player.addListener("not_ready", () => {
    trackMeta.textContent = "Spotify player went offline.";
    enableControls(false);
  });

  player.addListener("player_state_changed", (s) => {
    if (!s) return;
    state.isPaused = s.paused;
    const current = s.track_window.current_track;
    trackName.textContent = current?.name || "Spotify";
    trackMeta.textContent = current
      ? current.artists.map((a) => a.name).join(", ")
      : "Ready";
    playBtn.textContent = s.paused ? "▶" : "❚❚";
  });

  player.connect();
  state.player = player;
}

window.onSpotifyWebPlaybackSDKReady = () => {
  if (state.token) initSpotifyPlayer();
};

async function loadApps() {
  const apps = await fetch("/api/apps").then((r) => r.json());
  grid.replaceChildren();

  for (const item of apps) {
    const button = document.createElement("button");
    button.className = "tile";
    button.innerHTML = `<span class="icon">${item.icon || "□"}</span><span class="label">${item.label}</span>`;
    button.addEventListener("click", async () => {
      if (item.id === "spotify") {
        document.querySelector("#spotifyPanel").scrollIntoView({ behavior: "smooth" });
        return;
      }

      const result = await fetch(`/api/launch/${encodeURIComponent(item.id)}`, {
        method: "POST"
      }).then((r) => r.json());

      if (result.kind === "url") window.open(result.url, "_blank", "noopener,noreferrer");
    });
    grid.append(button);
  }
}

function updateNetworkState() {
  const online = navigator.onLine;
  status.classList.toggle("online", online);
  netText.textContent = online ? "online" : "offline";
}

async function boot() {
  state.config = await fetch("/api/config").then((r) => r.json());
  updateNetworkState();
  addEventListener("online", updateNetworkState);
  addEventListener("offline", updateNetworkState);
  await loadApps();

  state.token = sessionStorage.getItem("spotify_access_token");
  const code = new URLSearchParams(location.search).get("code");

  if (code) {
    try {
      await exchangeCode(code);
      initSpotifyPlayer();
    } catch (error) {
      trackMeta.textContent = error.message;
    }
  } else if (state.token && window.Spotify) {
    initSpotifyPlayer();
  }
}

spotifyConnect.addEventListener("click", async () => {
  if (!state.config.spotifyClientId || state.config.spotifyClientId.includes("replace")) {
    trackMeta.textContent = "Add your Spotify Client ID to .env first.";
    return;
  }
  await beginSpotifyLogin();
});

playBtn.addEventListener("click", () => state.player?.togglePlay());
prevBtn.addEventListener("click", () => state.player?.previousTrack());
nextBtn.addEventListener("click", () => state.player?.nextTrack());

boot();
