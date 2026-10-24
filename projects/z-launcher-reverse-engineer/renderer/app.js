'use strict';
const api = window.zLauncher;
const $ = id => document.getElementById(id);
let games = [], view = 'all', filter = 'all', query = '', toastTimeout;
const viewTitles = { all:'Ready to play',steam:'Steam Library',local:'My PC Games',favorites:'Your Favorites',recent:'Recently Played' };
const labels = { all:'Discover',steam:'Steam Library',local:'My PC Games',favorites:'Favorites',recent:'Recently Played' };
function notice(message) {
  const toast = $('toast'); toast.textContent = message;
  toast.classList.add('visible');
  clearTimeout(toastTimeout);
  toastTimeout = setTimeout(() => toast.classList.remove('visible'), 3600);
}
function matches(game, kind) {
  if (kind === 'favorites') return game.favorite;
  if (kind === 'recent') return !!game.lastPlayed;
  if (kind === 'all') return true;
  return game.source === kind;
}
function visibleGames() {
  return games.filter(g => matches(g,view) && matches(g,filter) && g.title.toLowerCase().includes(query))
    .sort((a,b) => view === 'recent'
      ? (b.lastPlayed || '').localeCompare(a.lastPlayed || '')
      : a.title.localeCompare(b.title));
}
function element(tag, className, value) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (value !== undefined) node.textContent = value;
  return node;
}
async function launch(id) {
  const result = await api.launchGame(id);
  if (result.ok) {
    notice('Launching your game…');
    games = await api.listGames(); render();
  } else notice(result.error || 'Could not launch game.');
}
function renderCard(game) {
  const card = element('article','game-card');
  const poster = element('div','poster');
  poster.append(element('div','placeholder','Z'));
  if (game.source === 'steam' && /^\d{1,12}$/.test(game.steamId)) {
    const img = element('img');
    img.src = 'https://cdn.cloudflare.steamstatic.com/steam/apps/' + game.steamId + '/library_600x900.jpg';
    img.alt = ''; img.loading = 'lazy'; img.onerror = () => img.remove();
    poster.append(img);
  }
  poster.append(element('span','source',game.source === 'steam' ? 'STEAM' : 'MY PC'));
  const play = element('button','launch-icon','▶');
  play.title = 'Play ' + game.title; play.setAttribute('aria-label',play.title);
  play.addEventListener('click',() => launch(game.id));
  poster.append(play);
  const info = element('div','card-info'), title = element('div');
  title.style.minWidth = '0';
  const name = element('div','game-name',game.title);
  name.title = game.title;
  title.append(name,element('div','game-subtitle',game.source === 'steam' ? 'Steam Collection' : 'PC Collection'));
  const actions = element('div','card-actions');
  const heart = element('button','icon-btn' + (game.favorite ? ' saved' : ''),game.favorite ? '♥' : '♡');
  heart.title = game.favorite ? 'Remove favorite' : 'Add favorite';
  heart.setAttribute('aria-label',heart.title);
  heart.addEventListener('click',async () => { games = await api.favorite(game.id); render(); });
  actions.append(heart);
  if (game.source === 'local') {
    const remove = element('button','icon-btn','×');
    remove.title = 'Remove from Z Launcher without deleting game files';
    remove.setAttribute('aria-label',remove.title);
    remove.addEventListener('click',async () => {
      if (window.confirm('Remove "' + game.title + '" from Z Launcher? Game files will remain.')) {
        games = await api.removeGame(game.id); render();
      }
    });
    actions.append(remove);
  }
  info.append(title,actions); card.append(poster,info); return card;
}
function render() {
  $('sectionTitle').textContent = viewTitles[view];
  $('crumb').textContent = labels[view];
  $('gameCount').textContent = games.length + ' ' + (games.length === 1 ? 'GAME' : 'GAMES') + ' IN LIBRARY';
  const selected = visibleGames();
  $('sectionCount').textContent = selected.length + ' ' + (selected.length === 1 ? 'TITLE' : 'TITLES');
  $('grid').replaceChildren(...selected.map(renderCard));
  $('empty').hidden = selected.length > 0;
  document.querySelectorAll('[data-view]').forEach(node => node.classList.toggle('active',node.dataset.view === view));
  document.querySelectorAll('[data-filter]').forEach(node => node.classList.toggle('active',node.dataset.filter === filter));
  $('heroPlay').textContent = games.length ? '▶ Launch featured' : '+ Add your first game';
}
async function addGame() {
  games = await api.addGame(); view='all'; filter='all'; render();
}
async function rescan() {
  games = await api.rescanSteam(); render();
  notice('Steam scanned · ' + games.filter(g => g.source === 'steam').length + ' installed games found');
}
function initialize() {
  document.querySelectorAll('[data-view]').forEach(node => node.addEventListener('click',() => {view=node.dataset.view;filter='all';render();}));
  document.querySelectorAll('[data-filter]').forEach(node => node.addEventListener('click',() => {filter=node.dataset.filter;render();}));
  document.querySelectorAll('[data-store]').forEach(node => node.addEventListener('click',async () => {
    try { await api.openStore(node.dataset.store); } catch { notice('Could not open store.'); }
  }));
  $('search').addEventListener('input',e => {query=e.target.value.trim().toLowerCase();render();});
  document.addEventListener('keydown',e => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase()==='k') {e.preventDefault();$('search').focus();}
  });
  $('addGame').addEventListener('click',addGame);
  $('emptyAdd').addEventListener('click',addGame);
  $('rescan').addEventListener('click',rescan);
  $('emptyScan').addEventListener('click',rescan);
  $('heroPlay').addEventListener('click',() => {
    if (!games.length) return addGame();
    return launch([...games].sort((a,b)=>(b.lastPlayed||'').localeCompare(a.lastPlayed||''))[0].id);
  });
  api.listGames().then(result => {games=result;render();})
    .catch(error => notice('Could not load library: ' + error.message));
}
initialize();
