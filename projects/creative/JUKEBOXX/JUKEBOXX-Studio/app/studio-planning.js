(() => {
  'use strict';
  const Studio = window.JukeStudio;
  const MAX_IMAGE_BYTES = 10 * 1024 * 1024;
  const rasterData = /^data:image\/(?:png|jpe?g|webp|gif|avif|bmp);base64,/i;
  const uid = () => window.crypto?.randomUUID?.() || `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;
  const hex = value => /^#[0-9a-f]{6}$/i.test(value || '') ? value : '#72dbe7';
  const short = (value, length = 180) => String(value ?? '').trim().slice(0, length);
  const json = value => JSON.stringify(value, null, 2);
  const isoDate = value => /^\d{4}-\d{2}-\d{2}$/.test(value || '') && Number.isFinite(Date.parse(value + 'T00:00:00Z')) && new Date(value + 'T00:00:00Z').toISOString().slice(0, 10) === value;
  const dateNumber = value => Date.parse(value + 'T00:00:00Z') / 86400000;
  const dayString = value => new Date(value * 86400000).toISOString().slice(0, 10);
  const today = () => {
    const date = new Date();
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  };
  const statusLabels = { planned: 'Planned', active: 'In progress', done: 'Complete' };
  const statusColor = { planned: '#6c8cb8', active: '#71dce7', done: '#8dd8a5' };

  function mount(root, S, key) {
    const wrapper = document.createElement('section');
    wrapper.className = 'stack';
    wrapper.dataset.planningModule = key;
    wrapper.innerHTML = '<div class="panel"><p class="hint" role="status">Loading your saved workspace…</p></div>';
    root.replaceChildren(wrapper);
    let disposed = false;
    let saveQueue = Promise.resolve();
    const abort = new AbortController();
    const alive = () => !disposed && wrapper.parentNode === root;
    return {
      wrapper, alive,
      on(target, type, listener) { target.addEventListener(type, listener, { signal: abort.signal }); },
      save(value) {
        const snapshot = JSON.parse(JSON.stringify(value));
        saveQueue = saveQueue.catch(() => {}).then(() => S.save(key, snapshot));
        return saveQueue.catch(error => {
          if (alive()) S.notify('Could not save this change. Keep this page open and export a copy.');
          throw error;
        });
      },
      cleanup() { disposed = true; abort.abort(); }
    };
  }

  function empty(message) {
    const node = document.createElement('div');
    node.className = 'empty';
    node.textContent = message;
    return node;
  }

  Studio.register('vision', async (root, S) => {
    const view = mount(root, S, 'vision');
    let cards = [];
    try {
      const stored = await S.load('vision', []);
      if (Array.isArray(stored)) cards = stored.filter(card => card && typeof card.id === 'string' && (card.kind === 'note' || card.kind === 'image')).map(card => ({
        id: card.id, kind: card.kind, title: short(card.title), text: short(card.text, 2000), color: hex(card.color),
        image: typeof card.image === 'string' && rasterData.test(card.image) ? card.image : '',
        createdAt: typeof card.createdAt === 'string' ? card.createdAt : new Date().toISOString()
      })).filter(card => card.kind !== 'image' || card.image);
    } catch (_) { if (view.alive()) S.notify('Saved vision board is unavailable. You can still build a new board.'); }
    if (!view.alive()) return view.cleanup;
    view.wrapper.innerHTML = `
      <div class="panel"><div class="panel-head"><h2>VISION BOARD</h2><span class="hint" data-count></span></div><p class="hint">Collect artwork, references, colors, and notes for your next release.</p>
        <div class="toolbar"><label class="btn" style="display:inline-flex;align-items:center;gap:8px;cursor:pointer">＋ ADD IMAGES<input data-images type="file" accept="image/png,image/jpeg,image/webp,image/gif,image/avif,image/bmp" multiple style="max-width:220px" aria-label="Add images to vision board"></label><button class="btn" data-export>EXPORT BOARD JSON</button><button class="btn" data-library>SAVE BOARD TO PROJECTS</button></div>
        <p class="hint">Images stay in this browser. Up to 10 MB per image.</p>
      </div>
      <form class="panel stack" data-note-form><div class="panel-head"><h3>ADD A NOTE</h3></div><div class="form-grid"><label class="field">TITLE<input name="title" maxlength="180" placeholder="Visual direction"></label><label class="field">ACCENT COLOR<input name="color" type="color" value="#72dbe7"></label></div><label class="field">NOTE<textarea name="text" rows="3" maxlength="2000" placeholder="Mood, references, ideas…" required></textarea></label><div><button class="btn primary" type="submit">＋ PIN NOTE</button></div></form>
      <div class="card-grid" data-board aria-label="Vision board cards"></div>`;
    const $ = selector => view.wrapper.querySelector(selector);
    const board = $('[data-board]');
    const count = $('[data-count]');

    function renderCards() {
      if (!view.alive()) return;
      count.textContent = `${cards.length} ${cards.length === 1 ? 'CARD' : 'CARDS'}`;
      board.replaceChildren();
      if (!cards.length) { board.append(empty('Your board is empty. Add reference images or pin your first note.')); return; }
      cards.forEach(card => {
        const article = document.createElement('article');
        article.className = 'item-card stack';
        article.style.borderTop = `3px solid ${card.color}`;
        article.dataset.card = card.id;
        const e = S.escape;
        article.innerHTML = `${card.kind === 'image' ? '<img data-image alt="" style="display:block;width:100%;max-height:300px;object-fit:contain;background:#111d2c;image-rendering:auto">' : ''}
          <label class="field">${card.kind === 'image' ? 'IMAGE TITLE' : 'TITLE'}<input data-card-title maxlength="180" value="${e(card.title)}" aria-label="Card title"></label>
          ${card.kind === 'note' ? `<label class="field">NOTE<textarea data-card-text rows="4" maxlength="2000" aria-label="Note text">${e(card.text)}</textarea></label>` : ''}
          <div class="toolbar"><label class="field" style="max-width:110px">COLOR<input data-card-color type="color" value="${card.color}" aria-label="Card accent color"></label><button type="button" class="btn" data-remove>REMOVE CARD</button></div>`;
        if (card.kind === 'image') {
          article.querySelector('[data-image]').src = card.image;
          article.querySelector('[data-image]').alt = card.title || 'Vision board reference';
        }
        board.append(article);
      });
    }

    view.on($('[data-note-form]'), 'submit', event => {
      event.preventDefault();
      const form = event.currentTarget;
      const data = new FormData(form);
      const text = short(data.get('text'), 2000);
      if (!text) { S.notify('Add some note text first.'); return; }
      cards.push({ id: uid(), kind: 'note', title: short(data.get('title')) || 'Untitled note', text, color: hex(data.get('color')), createdAt: new Date().toISOString() });
      form.reset();
      renderCards();
      view.save(cards).then(() => { if (view.alive()) S.notify('Note pinned.'); }).catch(() => {});
    });
    view.on($('[data-images]'), 'change', async event => {
      const input = event.currentTarget;
      const files = Array.from(input.files || []);
      input.disabled = true;
      const added = [];
      try {
        for (const file of files) {
          if (!view.alive()) return;
          if (!/^image\/(?:png|jpe?g|webp|gif|avif|bmp)$/i.test(file.type)) { S.notify(`Unsupported image: ${short(file.name, 80)}`); continue; }
          if (file.size > MAX_IMAGE_BYTES) { S.notify(`Image exceeds 10 MB: ${short(file.name, 80)}`); continue; }
          try {
            const image = await S.fileToDataURL(file);
            if (rasterData.test(image)) added.push({ id: uid(), kind: 'image', title: short(file.name), text: '', image, color: '#72dbe7', createdAt: new Date().toISOString() });
          } catch (_) { if (view.alive()) S.notify(`Could not read ${short(file.name, 80)}.`); }
        }
        if (view.alive() && added.length) {
          cards.push(...added); renderCards();
          await view.save(cards);
          if (view.alive()) S.notify(`${added.length} ${added.length === 1 ? 'image added' : 'images added'}.`);
        }
      } catch (_) {} finally { if (view.alive()) { input.disabled = false; input.value = ''; } }
    });
    view.on(board, 'change', event => {
      const article = event.target.closest('[data-card]');
      if (!article) return;
      const card = cards.find(value => value.id === article.dataset.card);
      if (!card) return;
      if (event.target.matches('[data-card-title]')) { card.title = short(event.target.value); const image = article.querySelector('[data-image]'); if (image) image.alt = card.title || 'Vision board reference'; }
      else if (event.target.matches('[data-card-text]')) card.text = short(event.target.value, 2000);
      else if (event.target.matches('[data-card-color]')) { card.color = hex(event.target.value); article.style.borderTopColor = card.color; }
      else return;
      view.save(cards).catch(() => {});
    });
    view.on(board, 'click', event => {
      const button = event.target.closest('[data-remove]');
      if (!button) return;
      const article = button.closest('[data-card]');
      cards = cards.filter(card => card.id !== article.dataset.card);
      renderCards(); view.save(cards).catch(() => {});
    });
    const snapshot = () => ({ product: 'JUKEBOXX', kind: 'vision-board', version: 1, exportedAt: new Date().toISOString(), cards });
    view.on($('[data-export]'), 'click', () => S.download(new Blob([json(snapshot())], { type: 'application/json' }), 'JUKE-vision-board.json'));
    view.on($('[data-library]'), 'click', async event => {
      const button = event.currentTarget; button.disabled = true;
      try { await S.saveFile({ name: 'JUKE-vision-board.json', type: 'application/json', content: json(snapshot()) }); if (view.alive()) S.notify('Vision board saved to your project files.'); }
      catch (_) { if (view.alive()) S.notify('Could not save the board to project files. Try exporting JSON.'); }
      finally { if (view.alive()) button.disabled = false; }
    });
    renderCards();
    return view.cleanup;
  });

  Studio.register('progress', async (root, S) => {
    const view = mount(root, S, 'progress');
    let tasks = [];
    try {
      const stored = await S.load('progress', []);
      if (Array.isArray(stored)) tasks = stored.filter(task => task && typeof task.id === 'string').map(task => ({ id: task.id, title: short(task.title) || 'Untitled task', done: task.done === true, createdAt: typeof task.createdAt === 'string' ? task.createdAt : new Date().toISOString() }));
    } catch (_) { if (view.alive()) S.notify('Saved progress is unavailable. New tasks can still be added.'); }
    if (!view.alive()) return view.cleanup;
    view.wrapper.innerHTML = `
      <div class="panel stack"><div class="panel-head"><h2>PROJECT PROGRESS</h2><strong data-percent>0%</strong></div><div class="progress-track" role="progressbar" aria-label="Project task completion" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0" style="min-height:18px;border:1px solid #57728f;background:#111c2c;overflow:hidden"><div class="progress-fill" style="height:18px;width:0%;background:linear-gradient(90deg,#2459b8,#72dbe7)"></div></div><p class="hint" data-summary role="status"></p></div>
      <form class="panel stack" data-task-form><label class="field">NEXT TASK<input name="title" maxlength="180" required placeholder="Finish cover art, build the website, export review notes…"></label><div><button class="btn primary" type="submit">＋ ADD TASK</button></div></form>
      <div class="panel stack"><div class="panel-head"><h3>YOUR CHECKLIST</h3><button class="btn" data-export>EXPORT CHECKLIST</button></div><div class="stack" data-tasks></div></div>`;
    const $ = selector => view.wrapper.querySelector(selector);
    const list = $('[data-tasks]');
    function render() {
      if (!view.alive()) return;
      const done = tasks.filter(task => task.done).length;
      const percent = tasks.length ? Math.round(done / tasks.length * 100) : 0;
      $('[data-percent]').textContent = `${percent}%`;
      $('[role="progressbar"]').setAttribute('aria-valuenow', String(percent));
      $('[role="progressbar"]').setAttribute('aria-valuetext', `${done} of ${tasks.length} tasks complete`);
      $('.progress-fill').style.width = `${percent}%`;
      $('[data-summary]').textContent = tasks.length ? `${done} of ${tasks.length} tasks complete. ${tasks.length - done} remaining.` : 'No tasks yet. Add the first task to start tracking progress.';
      list.replaceChildren();
      if (!tasks.length) { list.append(empty('Your next creative milestone starts with one task.')); return; }
      tasks.forEach(task => {
        const row = document.createElement('div');
        row.className = 'item-card toolbar';
        row.dataset.task = task.id;
        row.style.justifyContent = 'space-between';
        const label = document.createElement('label');
        label.style.cssText = 'display:flex;align-items:center;gap:12px;flex:1;min-width:0;cursor:pointer';
        const check = document.createElement('input');
        check.type = 'checkbox'; check.checked = task.done;
        check.dataset.done = '';
        check.setAttribute('aria-label', `Mark ${task.title} ${task.done ? 'incomplete' : 'complete'}`);
        check.style.cssText = 'width:20px;height:20px;flex:0 0 20px;accent-color:#72dbe7';
        const text = document.createElement('span'); text.textContent = task.title;
        text.style.cssText = `overflow-wrap:anywhere;${task.done ? 'text-decoration:line-through;color:#8ea6b9' : ''}`;
        label.append(check, text);
        const remove = document.createElement('button');
        remove.type = 'button'; remove.className = 'btn'; remove.dataset.removeTask = '';
        remove.textContent = 'REMOVE'; remove.setAttribute('aria-label', `Remove task: ${task.title}`);
        row.append(label, remove); list.append(row);
      });
    }
    view.on($('[data-task-form]'), 'submit', event => {
      event.preventDefault();
      const field = event.currentTarget.elements.namedItem('title');
      const title = short(field.value);
      if (!title) { field.focus(); return; }
      tasks.push({ id: uid(), title, done: false, createdAt: new Date().toISOString() });
      field.value = ''; render(); view.save(tasks).catch(() => {}); field.focus();
    });
    view.on(list, 'change', event => {
      if (!event.target.matches('[data-done]')) return;
      const row = event.target.closest('[data-task]');
      const task = tasks.find(item => item.id === row.dataset.task);
      if (!task) return;
      task.done = event.target.checked; render(); view.save(tasks).catch(() => {});
      const updated = Array.from(list.querySelectorAll('[data-task]')).find(item => item.dataset.task === task.id);
      updated?.querySelector('input')?.focus({ preventScroll: true });
    });
    view.on(list, 'click', event => {
      const button = event.target.closest('[data-remove-task]');
      if (!button) return;
      const row = button.closest('[data-task]');
      tasks = tasks.filter(task => task.id !== row.dataset.task); render(); view.save(tasks).catch(() => {});
    });
    view.on($('[data-export]'), 'click', () => S.download(new Blob([json({ product: 'JUKEBOXX', kind: 'progress', version: 1, exportedAt: new Date().toISOString(), tasks })], { type: 'application/json' }), 'JUKE-progress.json'));
    render();
    return view.cleanup;
  });

  Studio.register('timeline', async (root, S) => {
    const view = mount(root, S, 'timeline');
    let milestones = [], editingId = null;
    try {
      const stored = await S.load('timeline', []);
      if (Array.isArray(stored)) milestones = stored.filter(item => item && typeof item.id === 'string' && isoDate(item.start) && isoDate(item.end) && item.end >= item.start).map(item => ({ id: item.id, title: short(item.title) || 'Untitled milestone', start: item.start, end: item.end, status: Object.hasOwn(statusLabels, item.status) ? item.status : 'planned' }));
    } catch (_) { if (view.alive()) S.notify('Saved rollout is unavailable. You can still plan new milestones.'); }
    if (!view.alive()) return view.cleanup;
    view.wrapper.innerHTML = `
      <div class="panel"><div class="panel-head"><h2>ROLLOUT TIMELINE</h2><button class="btn" data-export>EXPORT TIMELINE</button></div><p class="hint">Map artwork, website, promotion, and release milestones on a shared timeline.</p></div>
      <form class="panel stack" data-milestone-form><div class="panel-head"><h3 data-form-title>ADD A MILESTONE</h3><button class="btn" data-cancel-edit type="button" hidden>CANCEL EDIT</button></div><label class="field">MILESTONE<input name="title" maxlength="180" required placeholder="Cover reveal, single release, launch day…"></label><div class="form-grid"><label class="field">START DATE<input name="start" type="date" required value="${today()}"></label><label class="field">END DATE<input name="end" type="date" required value="${today()}"></label><label class="field">STATUS<select name="status"><option value="planned">Planned</option><option value="active">In progress</option><option value="done">Complete</option></select></label></div><p data-date-error role="alert" class="hint" style="color:#ffbd8f" hidden></p><div><button class="btn primary" data-submit-milestone type="submit">＋ ADD MILESTONE</button></div></form>
      <div class="panel stack"><div class="panel-head"><h3>RELEASE MAP</h3><span class="hint" data-date-range></span></div><p class="hint">The vertical amber line marks today. Each bar includes its start and end dates.</p><div class="chart-scroll" data-chart style="overflow-x:auto"></div></div>
      <div class="panel stack"><div class="panel-head"><h3>MILESTONE DETAILS</h3><span class="hint" data-total></span></div><div data-milestones class="stack"></div></div>`;
    const $ = selector => view.wrapper.querySelector(selector);
    const form = $('[data-milestone-form]');
    const list = $('[data-milestones]');
    function resetForm() {
      editingId = null; form.reset();
      form.elements.namedItem('start').value = today(); form.elements.namedItem('end').value = today();
      $('[data-form-title]').textContent = 'ADD A MILESTONE';
      $('[data-submit-milestone]').textContent = '＋ ADD MILESTONE';
      $('[data-cancel-edit]').hidden = true; $('[data-date-error]').hidden = true;
    }
    function renderChart(sorted) {
      const chart = $('[data-chart]'); chart.replaceChildren();
      if (!sorted.length) { $('[data-date-range]').textContent = 'NO DATES YET'; chart.append(empty('Add milestones to build your rollout chart.')); return; }
      const minStart = Math.min(...sorted.map(item => dateNumber(item.start)));
      const maxEnd = Math.max(...sorted.map(item => dateNumber(item.end)));
      const first = minStart - 1, last = maxEnd + 1, span = last - first + 1;
      const position = date => (dateNumber(date) - first) / span * 100;
      const width = Math.max(620, Math.min(1600, span * 18));
      const container = document.createElement('div');
      container.style.cssText = `min-width:${width}px;position:relative;padding:8px 0 4px`;
      container.setAttribute('role', 'img');
      container.setAttribute('aria-label', `Rollout chart, ${dayString(first)} to ${dayString(last)}. ${sorted.length} milestones. Exact dates and statuses are listed below.`);
      $('[data-date-range]').textContent = `${dayString(first)} — ${dayString(last)}`;
      const axis = document.createElement('div');
      axis.style.cssText = 'display:grid;grid-template-columns:170px 1fr;min-height:35px;align-items:start';
      const axisTitle = document.createElement('span'); axisTitle.className = 'hint'; axisTitle.textContent = 'MILESTONE';
      const axisDates = document.createElement('div'); axisDates.style.cssText = 'position:relative;height:30px;margin-right:18px';
      for (let i = 0; i <= 4; i++) {
        const tick = document.createElement('span');
        tick.textContent = dayString(Math.min(last, first + Math.round((span - 1) * i / 4)));
        tick.style.cssText = `position:absolute;top:0;left:${i * 25}%;transform:translateX(${i === 0 ? '0' : i === 4 ? '-100%' : '-50%'});font:9px 'Courier New',monospace;color:#9fb8d1;white-space:nowrap`;
        axisDates.append(tick);
      }
      axis.append(axisTitle, axisDates); container.append(axis);
      const currentDay = today(), todayX = position(currentDay);
      sorted.forEach(item => {
        const row = document.createElement('div');
        row.style.cssText = 'display:grid;grid-template-columns:170px 1fr;min-height:54px;align-items:center;border-top:1px solid #7593b122';
        const label = document.createElement('span'); label.textContent = item.title;
        label.style.cssText = 'font:10px/1.4 monospace;padding:8px 15px 8px 0;overflow-wrap:anywhere;color:#dceaff';
        const track = document.createElement('div');
        track.style.cssText = 'position:relative;height:42px;margin-right:18px;background:repeating-linear-gradient(90deg,#7fa2c522 0 1px,transparent 1px 25%)';
        const bar = document.createElement('span');
        const barWidth = (dateNumber(item.end) - dateNumber(item.start) + 1) / span * 100;
        bar.style.cssText = `position:absolute;left:${position(item.start)}%;width:${barWidth}%;min-width:5px;height:19px;top:7px;background:${statusColor[item.status]};border:1px solid #d8f3ff80;box-shadow:1px 2px #081729`;
        bar.title = `${item.title}: ${item.start} to ${item.end} · ${statusLabels[item.status]}`;
        track.append(bar);
        if (todayX >= 0 && todayX <= 100) {
          const marker = document.createElement('span');
          marker.style.cssText = `position:absolute;top:0;bottom:0;left:${todayX}%;width:2px;background:#ffbb6e;opacity:.85;pointer-events:none`;
          marker.title = `Today: ${currentDay}`; track.append(marker);
        }
        row.append(label, track); container.append(row);
      });
      chart.append(container);
    }
    function render() {
      if (!view.alive()) return;
      const sorted = [...milestones].sort((a, b) => a.start.localeCompare(b.start) || a.title.localeCompare(b.title));
      $('[data-total]').textContent = `${sorted.length} ${sorted.length === 1 ? 'MILESTONE' : 'MILESTONES'}`;
      renderChart(sorted); list.replaceChildren();
      if (!sorted.length) { list.append(empty('Your rollout is ready for its first milestone.')); return; }
      const tableWrap = document.createElement('div'); tableWrap.style.overflowX = 'auto';
      const table = document.createElement('table');
      table.style.cssText = 'width:100%;border-collapse:collapse;text-align:left;min-width:600px;font-size:11px';
      table.innerHTML = '<caption class="hint" style="text-align:left;padding-bottom:12px">Exact dates and editable rollout status</caption><thead><tr><th scope="col" style="padding:10px 12px 10px 0">MILESTONE</th><th scope="col" style="padding:10px">START</th><th scope="col" style="padding:10px">END</th><th scope="col" style="padding:10px">STATUS</th><th scope="col" style="padding:10px">ACTIONS</th></tr></thead>';
      const tbody = document.createElement('tbody');
      sorted.forEach(item => {
        const row = document.createElement('tr'); row.dataset.milestone = item.id; row.style.borderTop = '1px solid #7593b133';
        const e = S.escape;
        row.innerHTML = `<th scope="row" style="text-align:left;padding:12px 12px 12px 0;max-width:220px;overflow-wrap:anywhere;font-weight:normal">${e(item.title)}</th><td style="padding:10px;white-space:nowrap">${item.start}</td><td style="padding:10px;white-space:nowrap">${item.end}</td><td style="padding:10px"><select data-status aria-label="Status for ${e(item.title)}"><option value="planned">Planned</option><option value="active">In progress</option><option value="done">Complete</option></select></td><td style="padding:10px"><div class="toolbar"><button type="button" class="btn" data-edit>EDIT</button><button type="button" class="btn" data-remove-milestone>REMOVE</button></div></td>`;
        row.querySelector('[data-status]').value = item.status;
        tbody.append(row);
      });
      table.append(tbody); tableWrap.append(table); list.append(tableWrap);
    }
    view.on(form, 'submit', event => {
      event.preventDefault();
      const data = new FormData(form);
      const title = short(data.get('title'));
      const start = String(data.get('start') || ''), end = String(data.get('end') || '');
      const status = String(data.get('status') || 'planned');
      const error = $('[data-date-error]');
      if (!title) { form.elements.namedItem('title').focus(); return; }
      if (!isoDate(start) || !isoDate(end) || end < start) { error.textContent = 'Choose valid dates. End date must be on or after the start date.'; error.hidden = false; return; }
      if (!Object.hasOwn(statusLabels, status)) return;
      const item = { id: editingId || uid(), title, start, end, status };
      if (editingId) milestones = milestones.map(value => value.id === editingId ? item : value);
      else milestones.push(item);
      resetForm(); render(); view.save(milestones).catch(() => {});
    });
    view.on($('[data-cancel-edit]'), 'click', resetForm);
    view.on(list, 'change', event => {
      if (!event.target.matches('[data-status]') || !Object.hasOwn(statusLabels, event.target.value)) return;
      const row = event.target.closest('[data-milestone]');
      const item = milestones.find(value => value.id === row.dataset.milestone);
      if (!item) return;
      item.status = event.target.value; render(); view.save(milestones).catch(() => {});
    });
    view.on(list, 'click', event => {
      const button = event.target.closest('[data-edit],[data-remove-milestone]');
      if (!button) return;
      const row = button.closest('[data-milestone]');
      const item = milestones.find(value => value.id === row.dataset.milestone);
      if (!item) return;
      if (button.matches('[data-edit]')) {
        editingId = item.id;
        form.elements.namedItem('title').value = item.title;
        form.elements.namedItem('start').value = item.start;
        form.elements.namedItem('end').value = item.end;
        form.elements.namedItem('status').value = item.status;
        $('[data-form-title]').textContent = 'EDIT MILESTONE';
        $('[data-submit-milestone]').textContent = 'SAVE MILESTONE';
        $('[data-cancel-edit]').hidden = false; $('[data-date-error]').hidden = true;
        form.elements.namedItem('title').focus();
      } else {
        if (editingId === item.id) resetForm();
        milestones = milestones.filter(value => value.id !== item.id); render(); view.save(milestones).catch(() => {});
      }
    });
    const snapshot = () => ({ product: 'JUKEBOXX', kind: 'rollout-timeline', version: 1, exportedAt: new Date().toISOString(), milestones });
    view.on($('[data-export]'), 'click', () => S.download(new Blob([json(snapshot())], { type: 'application/json' }), 'JUKE-rollout-timeline.json'));
    render();
    return view.cleanup;
  });
})();
