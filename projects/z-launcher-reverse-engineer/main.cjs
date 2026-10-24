'use strict';
const { app, BrowserWindow, ipcMain, dialog, shell } = require('electron');
const fs = require('node:fs');
const path = require('node:path');
const { randomUUID } = require('node:crypto');
const { scanSteamGames } = require('./lib/steam.cjs');

let mainWindow;
let database = { customGames: [], favorites: [], recent: {} };
let scannedSteam = [];
const storeUrl = Object.freeze({
  steam: 'https://store.steampowered.com/',
  gog: 'https://www.gog.com/',
  epic: 'https://store.epicgames.com/'
});
function dataFile() { return path.join(app.getPath('userData'), 'z-launcher.json'); }
function loadDatabase() {
  try {
    const parsed = JSON.parse(fs.readFileSync(dataFile(), 'utf8'));
    database = {
      customGames: Array.isArray(parsed.customGames) ? parsed.customGames : [],
      favorites: Array.isArray(parsed.favorites) ? parsed.favorites : [],
      recent: parsed.recent && typeof parsed.recent === 'object' && !Array.isArray(parsed.recent) ? parsed.recent : {}
    };
  } catch { database = { customGames: [], favorites: [], recent: {} }; }
}
function saveDatabase() {
  const target = dataFile(), temporary = target + '.tmp';
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.writeFileSync(temporary, JSON.stringify(database, null, 2), { encoding: 'utf8', mode: 0o600 });
  fs.renameSync(temporary, target);
}
function catalog() {
  const favorites = new Set(database.favorites);
  return [...scannedSteam, ...database.customGames].map(game => ({
    ...game, favorite: favorites.has(game.id), lastPlayed: database.recent[game.id] || null
  }));
}
function findGame(id) { return catalog().find(g => g.id === id); }
function createWindow() {
  mainWindow = new BrowserWindow({
    title: 'Z Launcher', width: 1370, height: 880, minWidth: 900, minHeight: 600,
    backgroundColor: '#090b10', autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      sandbox: true, contextIsolation: true, nodeIntegration: false
    }
  });
  mainWindow.webContents.setWindowOpenHandler(() => ({ action: 'deny' }));
  mainWindow.webContents.on('will-navigate', e => e.preventDefault());
  mainWindow.loadFile(path.join(__dirname, 'renderer', 'index.html'));
}
app.whenReady().then(() => {
  loadDatabase();
  scannedSteam = scanSteamGames();
  ipcMain.handle('games:list', () => catalog());
  ipcMain.handle('games:rescan', () => { scannedSteam = scanSteamGames(); return catalog(); });
  ipcMain.handle('games:add', async () => {
    const chosen = await dialog.showOpenDialog(mainWindow, {
      title: 'Choose the game executable or shortcut',
      properties: ['openFile'], filters: [{ name: 'Games and shortcuts', extensions: ['exe', 'lnk'] }]
    });
    if (chosen.canceled || !chosen.filePaths.length) return catalog();
    const executable = chosen.filePaths[0];
    if (!/\.(exe|lnk)$/i.test(executable) || !fs.existsSync(executable)) return catalog();
    const title = path.basename(executable, path.extname(executable)).replace(/[-_]+/g, ' ');
    if (!database.customGames.some(g => g.executable.toLowerCase() === executable.toLowerCase())) {
      database.customGames.push({ id: 'local-' + randomUUID(), title, source: 'local', genre: 'My PC', executable });
      saveDatabase();
    }
    return catalog();
  });
  ipcMain.handle('games:favorite', (_e, id) => {
    if (typeof id !== 'string' || !findGame(id)) return catalog();
    const favorites = new Set(database.favorites);
    if (favorites.has(id)) favorites.delete(id); else favorites.add(id);
    database.favorites = [...favorites];
    saveDatabase(); return catalog();
  });
  ipcMain.handle('games:remove', (_e, id) => {
    if (typeof id !== 'string' || !id.startsWith('local-')) return catalog();
    database.customGames = database.customGames.filter(g => g.id !== id);
    database.favorites = database.favorites.filter(v => v !== id);
    delete database.recent[id];
    saveDatabase(); return catalog();
  });
  ipcMain.handle('games:launch', async (_e, id) => {
    if (typeof id !== 'string') return { ok: false, error: 'Invalid game.' };
    const game = findGame(id);
    if (!game) return { ok: false, error: 'Game not found.' };
    try {
      if (game.source === 'steam' && /^\d{1,12}$/.test(game.steamId)) {
        await shell.openExternal('steam://rungameid/' + game.steamId);
      } else if (game.source === 'local' && typeof game.executable === 'string' && /\.(exe|lnk)$/i.test(game.executable)) {
        if (!fs.existsSync(game.executable)) return { ok: false, error: 'Game file has moved. Remove and re-add it.' };
        const error = await shell.openPath(game.executable);
        if (error) return { ok: false, error };
      } else return { ok: false, error: 'Unsupported game type.' };
      database.recent[game.id] = new Date().toISOString();
      saveDatabase();
      return { ok: true };
    } catch (error) { return { ok: false, error: error.message || 'Unable to launch game.' }; }
  });
  ipcMain.handle('stores:open', async (_e, name) => {
    if (typeof name !== 'string' || !Object.hasOwn(storeUrl, name)) return false;
    await shell.openExternal(storeUrl[name]); return true;
  });
  createWindow();
  app.on('activate', () => { if (BrowserWindow.getAllWindows().length === 0) createWindow(); });
});
app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit(); });
