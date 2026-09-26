import "dotenv/config";
import express from "express";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawn } from "node:child_process";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
const port = Number(process.env.PORT || 4173);

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

function loadApps() {
  return JSON.parse(
    fs.readFileSync(path.join(__dirname, "config", "apps.json"), "utf8")
  );
}

app.get("/api/health", (_req, res) => {
  res.json({ ok: true, service: "blink-connected-portal" });
});

app.get("/api/config", (_req, res) => {
  res.json({
    spotifyClientId: process.env.SPOTIFY_CLIENT_ID || "",
    spotifyRedirectUri:
      process.env.SPOTIFY_REDIRECT_URI || `http://127.0.0.1:${port}/`
  });
});

app.get("/api/apps", (_req, res) => {
  const safe = loadApps().map(({ command, args, ...item }) => item);
  res.json(safe);
});

app.post("/api/launch/:id", (req, res) => {
  const item = loadApps().find((entry) => entry.id === req.params.id);
  if (!item) return res.status(404).json({ error: "Unknown app" });

  if (item.kind === "internal") {
    return res.json({ kind: "internal", id: item.id });
  }

  if (item.kind === "url") {
    return res.json({ kind: "url", url: item.url });
  }

  if (item.kind === "local") {
    try {
      const child = spawn(item.command, Array.isArray(item.args) ? item.args : [], {
        detached: true,
        stdio: "ignore"
      });
      child.unref();
      return res.json({ kind: "local", launched: true });
    } catch (error) {
      return res.status(500).json({ error: "Launch failed" });
    }
  }

  return res.status(400).json({ error: "Unsupported app kind" });
});

app.listen(port, "127.0.0.1", () => {
  console.log(`BLINK Connected Portal: http://127.0.0.1:${port}`);
});
