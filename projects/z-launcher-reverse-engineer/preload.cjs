'use strict';
const { contextBridge, ipcRenderer } = require('electron');
contextBridge.exposeInMainWorld('zLauncher', Object.freeze({
  listGames: () => ipcRenderer.invoke('games:list'),
  rescanSteam: () => ipcRenderer.invoke('games:rescan'),
  addGame: () => ipcRenderer.invoke('games:add'),
  favorite: id => ipcRenderer.invoke('games:favorite', id),
  removeGame: id => ipcRenderer.invoke('games:remove', id),
  launchGame: id => ipcRenderer.invoke('games:launch', id),
  openStore: name => ipcRenderer.invoke('stores:open', name)
}));
