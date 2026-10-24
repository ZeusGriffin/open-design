'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const { parseLibraryPaths, parseManifest, scanSteamGames } = require('../lib/steam.cjs');
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
test('reads modern and older Steam library paths', () => {
  const source = String.raw`"libraryfolders" { "0" { "path" "C:\\Program Files (x86)\\Steam" "apps" { } } "1" "D:\\SteamLibrary" }`;
  assert.deepEqual(parseLibraryPaths(source), [path.normalize('C:\\Program Files (x86)\\Steam'), path.normalize('D:\\SteamLibrary')]);
});
test('parses installed game manifests and rejects invalid IDs', () => {
  assert.deepEqual(parseManifest('"AppState" { "appid" "12345" "name" "My Fun Game" }'), {
    id: 'steam-12345', steamId: '12345', title: 'My Fun Game', source: 'steam', genre: 'Steam'
  });
  assert.equal(parseManifest('"appid" "1;evil" "name" "Bad"'), null);
  assert.equal(parseManifest('"appid" "12"'), null);
});
test('scans existing libraries only and ignores damaged manifests', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'zlaunch-'));
  try {
    fs.mkdirSync(path.join(root,'steamapps'));
    fs.writeFileSync(path.join(root,'steamapps','appmanifest_9.acf'), '"appid" "9" "name" "Test Game"');
    fs.writeFileSync(path.join(root,'steamapps','appmanifest_10.acf'), 'broken');
    assert.equal(scanSteamGames([root]).length, 1);
    assert.equal(scanSteamGames([root])[0].title, 'Test Game');
  } finally { fs.rmSync(root, { recursive: true, force: true }); }
});
