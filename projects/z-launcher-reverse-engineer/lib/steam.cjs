'use strict';
const fs = require('node:fs');
const path = require('node:path');

function unescapeVdf(value) {
  return value.replace(/\\\\/g, '\\').replace(/\\"/g, '"');
}
function vdfField(text, key) {
  const match = text.match(new RegExp('"' + key + '"\\s*"((?:\\\\.|[^"\\\\])*)"', 'i'));
  return match ? unescapeVdf(match[1]) : '';
}
function parseLibraryPaths(text) {
  const paths = [];
  const modern = /"\d+"\s*\{[^{}]*?"path"\s*"((?:\\.|[^"\\])*)"/gi;
  for (const m of text.matchAll(modern)) paths.push(unescapeVdf(m[1]));
  const legacy = /"\d+"\s*"((?:\\.|[^"\\])*)"/gi;
  for (const m of text.matchAll(legacy)) {
    const candidate = unescapeVdf(m[1]);
    if (/^[A-Za-z]:[\\/]/.test(candidate)) paths.push(candidate);
  }
  return [...new Set(paths.map(p => path.normalize(p)))];
}
function parseManifest(content) {
  const steamId = vdfField(content, 'appid');
  const title = vdfField(content, 'name').trim();
  if (!/^\d{1,12}$/.test(steamId) || !title) return null;
  return { id: 'steam-' + steamId, steamId, title, source: 'steam', genre: 'Steam' };
}
function directoryIfExists(directory) {
  try { return fs.statSync(directory).isDirectory(); } catch { return false; }
}
function steamRootCandidates() {
  if (process.platform !== 'win32') return [];
  return [
    process.env['ProgramFiles(x86)'] && path.join(process.env['ProgramFiles(x86)'], 'Steam'),
    process.env.ProgramFiles && path.join(process.env.ProgramFiles, 'Steam'),
    process.env.LOCALAPPDATA && path.join(process.env.LOCALAPPDATA, 'Steam')
  ].filter(Boolean);
}
function scanSteamGames(roots = steamRootCandidates()) {
  const libraries = new Set();
  for (const root of roots) {
    if (!directoryIfExists(root)) continue;
    libraries.add(root);
    const libraryFile = path.join(root, 'steamapps', 'libraryfolders.vdf');
    try {
      for (const directory of parseLibraryPaths(fs.readFileSync(libraryFile, 'utf8'))) {
        if (directoryIfExists(directory)) libraries.add(directory);
      }
    } catch {}
  }
  const found = new Map();
  for (const library of libraries) {
    const appDir = path.join(library, 'steamapps');
    let names = [];
    try { names = fs.readdirSync(appDir).filter(name => /^appmanifest_\d+\.acf$/i.test(name)); }
    catch { continue; }
    for (const filename of names) {
      try {
        const game = parseManifest(fs.readFileSync(path.join(appDir, filename), 'utf8'));
        if (game) found.set(game.id, game);
      } catch {}
    }
  }
  return [...found.values()].sort((a,b) => a.title.localeCompare(b.title));
}
module.exports = { parseLibraryPaths, parseManifest, scanSteamGames };
