/* Local website and cover makers. No network requests or generated scripts. */
(() => {
  'use strict';
  const Studio = window.JukeStudio;
  if (!Studio || typeof Studio.register !== 'function') return;

  const text = (value, fallback = '', limit = 12000) => typeof value === 'string' ? value.slice(0, limit) : fallback;
  const color = (value, fallback) => typeof value === 'string' && /^#[0-9a-f]{6}$/i.test(value) ? value : fallback;
  const escape = value => String(value).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
  const slug = value => String(value).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 60) || 'juke-project';
  const clamp = (value, min, max, fallback) => Number.isFinite(Number(value)) ? Math.max(min, Math.min(max, Number(value))) : fallback;

  function element(tag, attributes = {}, children = []) {
    const node = document.createElement(tag);
    Object.entries(attributes).forEach(([key, value]) => {
      if (key === 'text') node.textContent = value;
      else if (key === 'class') node.className = value;
      else if (key === 'value') node.value = value;
      else node.setAttribute(key, String(value));
    });
    (Array.isArray(children) ? children : [children]).forEach(child => {
      if (child !== null && child !== undefined) node.append(child instanceof Node ? child : document.createTextNode(String(child)));
    });
    return node;
  }

  function field(label, input) {
    return element('label', { class: 'field' }, [element('span', { text: label }), input]);
  }

  function button(label, primary = false) {
    return element('button', { type: 'button', class: 'btn' + (primary ? ' primary' : ''), text: label });
  }

  function lifecycle(root, S) {
    let active = true;
    const listeners = [];
    const timers = new Set();
    const on = (target, event, fn, options) => {
      target.addEventListener(event, fn, options);
      listeners.push(() => target.removeEventListener(event, fn, options));
    };
    const notify = message => { if (active) S.notify(message); };
    const action = (control, task) => on(control, 'click', async () => {
      if (!active || control.disabled) return;
      control.disabled = true;
      try { await task(); }
      catch (error) { notify('Could not complete that action: ' + text(error && error.message, 'Please try again.', 150)); }
      finally { if (active) control.disabled = false; }
    });
    return {
      on, action, notify,
      get active() { return active; },
      delay(fn, ms) { const id = setTimeout(() => { timers.delete(id); if (active) fn(); }, ms); timers.add(id); return id; },
      cancel(id) { clearTimeout(id); timers.delete(id); },
      cleanup() { active = false; listeners.forEach(remove => remove()); timers.forEach(clearTimeout); timers.clear(); }
    };
  }

  Studio.register('website', async (root, S) => {
    const life = lifecycle(root, S);
    const defaults = {
      title: 'Your next big idea.', tagline: 'A small beginning. A world of possibilities.',
      body: 'Welcome to my corner of the web. This is a place for the things I make, the ideas I share, and what comes next.',
      accent: '#70dfe5', background: '#101b2c',
      sections: [
        { heading: 'Made with purpose', body: 'Tell people what you do and why it matters.' },
        { heading: 'What comes next', body: 'Share a project, a story, or something you are building.' }
      ]
    };
    let saved;
    try { saved = await S.load('website-maker-draft-v1', defaults); }
    catch (_) { saved = defaults; }
    saved = saved && typeof saved === 'object' ? saved : defaults;
    const initial = {
      title: text(saved.title, defaults.title, 140), tagline: text(saved.tagline, defaults.tagline, 280),
      body: text(saved.body, defaults.body, 10000), accent: color(saved.accent, defaults.accent), background: color(saved.background, defaults.background),
      sections: (Array.isArray(saved.sections) ? saved.sections : defaults.sections).slice(0, 12).map(section => ({
        heading: text(section && section.heading, '', 140), body: text(section && section.body, '', 6000)
      }))
    };
    const heading = element('div', { class: 'panel-head' }, [element('h2', { text: 'WEBSITE MAKER' }), element('span', { text: 'LOCAL HTML / 01' })]);
    const intro = element('p', { class: 'hint', text: 'Build a complete page, edit its sections, and export an HTML file. The preview stays in this browser; no publishing service is connected.' });
    const titleInput = element('input', { type: 'text', maxlength: 140, value: initial.title });
    const taglineInput = element('input', { type: 'text', maxlength: 280, value: initial.tagline });
    const bodyInput = element('textarea', { rows: 5, maxlength: 10000, value: initial.body });
    const accentInput = element('input', { type: 'color', value: initial.accent });
    const backgroundInput = element('input', { type: 'color', value: initial.background });
    const form = element('div', { class: 'stack' }, [
      field('Page title', titleInput), field('Tagline', taglineInput), field('Introduction', bodyInput),
      element('div', { class: 'form-grid' }, [field('Accent color', accentInput), field('Background color', backgroundInput)])
    ]);
    const sectionList = element('div', { class: 'stack' });
    const addSection = button('+ Add section');
    const sectionCount = element('p', { class: 'hint' });
    const sections = [];
    const editPanel = element('section', { class: 'panel stack' }, [
      element('h3', { text: 'PAGE CONTENT' }), form,
      element('h3', { text: 'SECTIONS' }), sectionList, addSection, sectionCount
    ]);
    const preview = element('iframe', { class: 'preview-frame', title: 'Generated website preview', sandbox: '' });
    preview.style.width = '100%';
    preview.style.minHeight = '580px';
    const previewLabel = element('p', { class: 'hint', text: 'Live preview · self-contained page · no scripts' });
    const previewPanel = element('section', { class: 'panel stack' }, [element('h3', { text: 'PREVIEW' }), previewLabel, preview]);
    const build = button('Build preview', true), save = button('Save draft'), download = button('Export HTML'), saveFile = button('Save HTML to Files');
    root.replaceChildren(heading, intro, element('div', { class: 'toolbar' }, [build, save, download, saveFile]), element('div', { class: 'split' }, [editPanel, previewPanel]));

    function readState() {
      return {
        title: titleInput.value.slice(0, 140), tagline: taglineInput.value.slice(0, 280), body: bodyInput.value.slice(0, 10000),
        accent: color(accentInput.value, defaults.accent), background: color(backgroundInput.value, defaults.background),
        sections: sections.map(section => ({ heading: section.heading.value.slice(0, 140), body: section.body.value.slice(0, 6000) }))
      };
    }

    function paragraphs(value) {
      return String(value).split(/\n\s*\n/).filter(v => v.trim()).map(v => '<p>' + escape(v).replace(/\n/g, '<br>') + '</p>').join('');
    }

    function buildHTML(state) {
      const title = state.title.trim() || 'Untitled website';
      const cards = state.sections.map((section, i) => '<section class="card" id="section-' + (i + 1) + '"><span class="index">' + String(i + 1).padStart(2, '0') + '</span><h2>' + escape(section.heading.trim() || 'Untitled section') + '</h2>' + paragraphs(section.body) + '</section>').join('');
      return '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>' + escape(title) + '</title><style>' +
        ':root{color-scheme:dark;--accent:' + color(state.accent, defaults.accent) + ';--bg:' + color(state.background, defaults.background) + '}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:var(--bg);color:#f1f5fc;font-family:Arial,Helvetica,sans-serif;line-height:1.7}a{color:inherit}a:focus-visible{outline:3px solid var(--accent);outline-offset:6px}.wrap{max-width:1120px;margin:auto;padding:0 6vw}header{padding-top:32px;display:flex;justify-content:space-between;gap:20px;align-items:center;border-bottom:1px solid #ffffff24;padding-bottom:22px}.brand{font-size:12px;font-weight:800;letter-spacing:2px;text-transform:uppercase;color:var(--accent);overflow-wrap:anywhere}.nav{font-size:12px;text-decoration:none;white-space:nowrap}.hero{padding:100px 0 75px;max-width:890px}.eyebrow{font-size:10px;letter-spacing:3px;color:var(--accent);text-transform:uppercase}.hero h1{font-size:clamp(42px,7.5vw,92px);line-height:1.02;letter-spacing:-.055em;margin:18px 0 28px;overflow-wrap:anywhere}.tagline{font-size:clamp(18px,2.5vw,25px);color:#d7e2ef;max-width:680px}.explore{display:inline-block;margin-top:20px;padding:12px 22px;background:var(--accent);color:#091523;text-decoration:none;font-size:13px;font-weight:bold;border-radius:2px}#about{padding:32px 0 55px;max-width:750px;border-top:1px solid #ffffff24}h2{font-size:26px;line-height:1.25;margin:10px 0 17px;overflow-wrap:anywhere}p{overflow-wrap:anywhere}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,280px),1fr));gap:22px;padding-bottom:80px}.card{padding:30px;background:#ffffff07;border:1px solid #ffffff24;border-top:3px solid var(--accent)}.index{font:12px monospace;color:var(--accent)}.card p,#about p{color:#c5d3e4;font-size:15px}.footer{padding:25px 0 35px;border-top:1px solid #ffffff24;color:#9fb2ca;font-size:11px}@media(max-width:600px){.hero{padding:65px 0 45px}.card{padding:24px}.hero h1{letter-spacing:-.04em}}@media(prefers-reduced-motion:reduce){html{scroll-behavior:auto}}</style></head><body><div class="wrap"><header><span class="brand">' + escape(title) + '</span><a class="nav" href="#about">About this page ↗</a></header><main><section class="hero"><p class="eyebrow">INDEPENDENT / CREATIVE</p><h1>' + escape(title) + '</h1><p class="tagline">' + escape(state.tagline) + '</p><a class="explore" href="' + (state.sections.length ? '#section-1' : '#about') + '">Explore the page ↓</a></section><section id="about"><h2>A little more.</h2>' + paragraphs(state.body) + '</section><div class="grid">' + cards + '</div></main><footer class="footer">' + escape(title) + '</footer></div></body></html>';
    }

    let previewTimer;
    function render() { if (life.active) preview.srcdoc = buildHTML(readState()); }
    function requestPreview() { life.cancel(previewTimer); previewTimer = life.delay(render, 160); }
    function refreshCount() { sectionCount.textContent = sections.length + ' / 12 sections'; addSection.disabled = sections.length >= 12; }
    function appendSection(value = { heading: '', body: '' }) {
      if (sections.length >= 12) return;
      const item = {
        heading: element('input', { type: 'text', maxlength: 140, value: value.heading }),
        body: element('textarea', { rows: 3, maxlength: 6000, value: value.body })
      };
      const remove = button('Remove section');
      const panel = element('section', { class: 'panel stack' }, [field('Section heading', item.heading), field('Section text', item.body), remove]);
      sections.push(item);
      sectionList.append(panel);
      life.on(panel, 'input', requestPreview);
      life.on(remove, 'click', () => {
        const index = sections.indexOf(item);
        if (index !== -1) sections.splice(index, 1);
        panel.remove(); refreshCount(); render();
      });
      refreshCount();
      return item;
    }
    initial.sections.forEach(appendSection);
    life.on(form, 'input', requestPreview);
    life.on(addSection, 'click', () => { const item = appendSection(); if (item) item.heading.focus(); render(); });
    life.action(build, async () => { render(); life.notify('Website preview rebuilt.'); });
    life.action(save, async () => { await S.save('website-maker-draft-v1', readState()); life.notify('Website draft saved in this browser.'); });
    life.action(download, async () => {
      const state = readState();
      await S.download(new Blob([buildHTML(state)], { type: 'text/html;charset=utf-8' }), slug(state.title) + '.html');
      life.notify('HTML exported. Open the file in a browser.');
    });
    life.action(saveFile, async () => {
      const state = readState();
      await S.saveFile({ name: slug(state.title) + '.html', type: 'text/html', content: buildHTML(state) });
      life.notify('Website HTML saved to Files.');
    });
    refreshCount(); render();
    return () => { life.cleanup(); preview.removeAttribute('srcdoc'); };
  });

  Studio.register('cover', async (root, S) => {
    const life = lifecycle(root, S);
    const defaults = { artist: 'JOHNNY JUKEBOX', title: 'OPEN\nFREQUENCY', size: 110, text: '#f1f9ff', accent: '#70dfe5', background: '#1647a3', preset: 'angular', font: 'block', image: '' };
    const imagePattern = /^data:image\/(?:png|jpeg|webp|gif);base64,[a-z0-9+/=\r\n]+$/i;
    const safeImage = value => typeof value === 'string' && value.length <= 14 * 1024 * 1024 && imagePattern.test(value) ? value : '';
    let saved;
    try { saved = await S.load('cover-maker-draft-v1', defaults); }
    catch (_) { saved = defaults; }
    saved = saved && typeof saved === 'object' ? saved : defaults;
    const initial = {
      artist: text(saved.artist, defaults.artist, 100), title: text(saved.title, defaults.title, 180),
      size: clamp(saved.size, 40, 180, defaults.size), text: color(saved.text, defaults.text),
      accent: color(saved.accent, defaults.accent), background: color(saved.background, defaults.background),
      preset: ['angular', 'gradient', 'solid'].includes(saved.preset) ? saved.preset : defaults.preset,
      font: ['block', 'mono', 'serif'].includes(saved.font) ? saved.font : defaults.font, image: safeImage(saved.image)
    };
    const heading = element('div', { class: 'panel-head' }, [element('h2', { text: 'COVER ART MAKER' }), element('span', { text: '1024 × 1024 / PNG' })]);
    const intro = element('p', { class: 'hint', text: 'Design a square cover with your own text, colors, and optional image. Everything renders locally; this tool does not generate AI images.' });
    const artist = element('input', { type: 'text', maxlength: 100, value: initial.artist });
    const title = element('textarea', { rows: 3, maxlength: 180, value: initial.title });
    const size = element('input', { type: 'range', min: 40, max: 180, step: 2, value: initial.size });
    const sizeReadout = element('span', { class: 'hint', text: initial.size + ' px maximum' });
    const ink = element('input', { type: 'color', value: initial.text });
    const accent = element('input', { type: 'color', value: initial.accent });
    const background = element('input', { type: 'color', value: initial.background });
    const preset = element('select', {}, [
      element('option', { value: 'angular', text: 'Angular / PS1' }), element('option', { value: 'gradient', text: 'Gradient' }), element('option', { value: 'solid', text: 'Solid' })
    ]);
    preset.value = initial.preset;
    const font = element('select', {}, [
      element('option', { value: 'block', text: 'Block sans' }), element('option', { value: 'mono', text: 'Monospace' }), element('option', { value: 'serif', text: 'Serif' })
    ]);
    font.value = initial.font;
    const upload = element('input', { type: 'file', accept: 'image/png,image/jpeg,image/webp,image/gif' });
    const clearImage = button('Clear image');
    const imageStatus = element('p', { class: 'hint', role: 'status', text: 'No image selected. PNG, JPG, WebP, or GIF · up to 10 MB.' });
    const controls = element('div', { class: 'stack' }, [
      field('Artist', artist), field('Cover title', title), field('Maximum title size', size), sizeReadout,
      element('div', { class: 'form-grid' }, [field('Typeface', font), field('Background preset', preset)]),
      element('div', { class: 'form-grid' }, [field('Text', ink), field('Accent', accent), field('Background', background)]),
      field('Optional background image', upload), imageStatus, clearImage,
      element('p', { class: 'hint', text: 'Image fills the square. Save draft to keep the form and image in this browser. Long titles shrink to fit.' })
    ]);
    const editPanel = element('section', { class: 'panel stack' }, [element('h3', { text: 'ART DIRECTION' }), controls]);
    const canvas = element('canvas', { width: 1024, height: 1024, role: 'img', 'aria-label': 'Cover artwork preview' });
    canvas.style.width = '100%'; canvas.style.maxWidth = '580px'; canvas.style.height = 'auto'; canvas.style.display = 'block';
    const previewPanel = element('section', { class: 'panel stack' }, [element('h3', { text: 'COVER PREVIEW' }), element('div', { class: 'canvas-wrap' }, [canvas]), element('p', { class: 'hint', text: '1024 × 1024 pixels · exported PNG matches this preview' })]);
    const redraw = button('Refresh preview', true), save = button('Save draft'), download = button('Export PNG'), saveFile = button('Save PNG to Files');
    root.replaceChildren(heading, intro, element('div', { class: 'toolbar' }, [redraw, save, download, saveFile]), element('div', { class: 'split' }, [editPanel, previewPanel]));
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      previewPanel.replaceChildren(element('p', { class: 'empty', text: 'Canvas is unavailable in this browser.' }));
      [redraw, save, download, saveFile, upload, clearImage].forEach(control => { control.disabled = true; });
      return () => life.cleanup();
    }
    let image = null, imageData = '', imageTicket = 0, imageBusy = false;
    const outputControls = [save, download, saveFile];
    function imageLoading(busy) { imageBusy = busy; outputControls.forEach(control => { control.disabled = busy; }); }
    function readState() {
      return {
        artist: artist.value.slice(0, 100), title: title.value.slice(0, 180), size: clamp(size.value, 40, 180, 110),
        text: color(ink.value, defaults.text), accent: color(accent.value, defaults.accent), background: color(background.value, defaults.background),
        preset: ['angular', 'gradient', 'solid'].includes(preset.value) ? preset.value : 'angular',
        font: ['block', 'mono', 'serif'].includes(font.value) ? font.value : 'block', image: imageData
      };
    }
    function polygon(points, fill) {
      ctx.beginPath(); points.forEach((point, i) => i ? ctx.lineTo(point[0], point[1]) : ctx.moveTo(point[0], point[1])); ctx.closePath(); ctx.fillStyle = fill; ctx.fill();
    }
    function wrapLine(value, maxWidth) {
      if (!value) return [''];
      const words = value.trim().split(/\s+/), lines = [];
      let line = '';
      for (const word of words) {
        if (ctx.measureText(word).width > maxWidth) {
          if (line) { lines.push(line); line = ''; }
          let piece = '';
          for (const char of word) {
            if (piece && ctx.measureText(piece + char).width > maxWidth) { lines.push(piece); piece = ''; }
            piece += char;
          }
          line = piece;
        } else if (line && ctx.measureText(line + ' ' + word).width > maxWidth) {
          lines.push(line); line = word;
        } else line += (line ? ' ' : '') + word;
      }
      if (line) lines.push(line);
      return lines.length ? lines : [''];
    }
    function render() {
      if (!life.active) return;
      const state = readState();
      const family = { block: '"Arial Black", Arial, sans-serif', mono: 'Consolas, "Courier New", monospace', serif: 'Georgia, "Times New Roman", serif' }[state.font];
      ctx.clearRect(0, 0, 1024, 1024);
      ctx.fillStyle = state.background; ctx.fillRect(0, 0, 1024, 1024);
      if (state.preset === 'gradient') {
        const gradient = ctx.createLinearGradient(0, 0, 1024, 1024);
        gradient.addColorStop(0, state.background); gradient.addColorStop(1, state.accent);
        ctx.fillStyle = gradient; ctx.fillRect(0, 0, 1024, 1024);
      } else if (state.preset === 'angular') {
        polygon([[0, 0], [760, 0], [300, 600], [0, 510]], '#09204d');
        polygon([[1024, 0], [1024, 800], [500, 1024], [640, 475]], state.accent + '99');
        polygon([[0, 700], [425, 410], [800, 1024], [0, 1024]], '#09192fbb');
        polygon([[60, 0], [116, 0], [1024, 856], [1024, 920]], '#b3edff16');
        let seed = 781;
        for (let i = 0; i < 4000; i++) {
          seed = (seed * 1664525 + 1013904223) >>> 0; const x = seed % 256;
          seed = (seed * 1664525 + 1013904223) >>> 0; const y = seed % 256;
          ctx.fillStyle = i % 2 ? '#c6efff0c' : '#030b1c14'; ctx.fillRect(x * 4, y * 4, 4, 4);
        }
      }
      if (image) {
        const scale = Math.max(1024 / image.naturalWidth, 1024 / image.naturalHeight);
        const width = image.naturalWidth * scale, height = image.naturalHeight * scale;
        ctx.drawImage(image, (1024 - width) / 2, (1024 - height) / 2, width, height);
      }
      const shade = ctx.createLinearGradient(0, 0, 0, 1024);
      shade.addColorStop(0, '#06122488'); shade.addColorStop(.35, '#06122400'); shade.addColorStop(1, '#041021e6');
      ctx.fillStyle = shade; ctx.fillRect(0, 0, 1024, 1024);
      ctx.strokeStyle = state.accent; ctx.lineWidth = 3; ctx.strokeRect(42, 42, 940, 940);
      ctx.fillStyle = state.accent; [[42,42],[974,42],[42,974],[974,974]].forEach(p => ctx.fillRect(p[0], p[1], 8, 8));
      ctx.fillStyle = state.text; ctx.textBaseline = 'alphabetic'; ctx.textAlign = 'left';
      ctx.font = 'bold 32px ' + family;
      ctx.shadowColor = '#06132a'; ctx.shadowBlur = 0; ctx.shadowOffsetX = 2; ctx.shadowOffsetY = 3;
      ctx.fillText(state.artist.trim() || 'ARTIST NAME', 80, 122, 860);
      const requestedLines = (state.title.trim() || 'UNTITLED').split(/\r?\n/).map(line => line.trim()).filter(Boolean);
      // Keep all title words while preventing dozens of manual line breaks from pushing art off-canvas.
      const titleLines = requestedLines.length > 6 ? requestedLines.slice(0, 5).concat(requestedLines.slice(5).join(' ')) : requestedLines;
      let fontSize = state.size, lines;
      do {
        ctx.font = '900 ' + fontSize + 'px ' + family;
        lines = titleLines.flatMap(line => wrapLine(line, 855));
        if (lines.length * fontSize * 1.06 <= 430 || fontSize <= 32) break;
        fontSize -= 2;
      } while (fontSize >= 32);
      const lineHeight = fontSize * 1.06;
      const startY = 900 - (lines.length - 1) * lineHeight;
      ctx.shadowOffsetX = 4; ctx.shadowOffsetY = 5;
      lines.forEach((line, i) => ctx.fillText(line, 80, startY + i * lineHeight, 860));
      ctx.shadowOffsetX = 0; ctx.shadowOffsetY = 0;
      ctx.fillStyle = state.accent; ctx.fillRect(80, startY - fontSize - 26, 110, 5);
      ctx.font = '15px Consolas, monospace'; ctx.fillText('SIDE A / 01', 80, 949);
      sizeReadout.textContent = state.size + ' px maximum' + (fontSize < state.size ? ' · fitted to ' + fontSize + ' px' : '');
      canvas.setAttribute('aria-label', 'Cover artwork preview: ' + (state.title.trim() || 'Untitled') + ' by ' + (state.artist.trim() || 'Artist name'));
    }

    async function loadImage(dataURL, label) {
      const ticket = ++imageTicket;
      imageLoading(true); imageStatus.textContent = 'Loading image…';
      try {
        if (!safeImage(dataURL)) throw new Error('Use a PNG, JPG, WebP, or GIF image up to 10 MB.');
        const decoded = await new Promise((resolve, reject) => {
          const candidate = new Image();
          candidate.onload = () => resolve(candidate);
          candidate.onerror = () => reject(new Error('That file could not be decoded as an image.'));
          candidate.src = dataURL;
        });
        if (!life.active || ticket !== imageTicket) return;
        if (!decoded.naturalWidth || !decoded.naturalHeight || decoded.naturalWidth * decoded.naturalHeight > 40000000) throw new Error('Please choose an image with at most 40 million pixels.');
        image = decoded; imageData = dataURL;
        imageStatus.textContent = label + ' · ' + decoded.naturalWidth + ' × ' + decoded.naturalHeight;
        clearImage.disabled = false; render();
      } catch (error) {
        if (!life.active || ticket !== imageTicket) return;
        imageStatus.textContent = text(error.message, 'Image could not be loaded.', 180);
        life.notify(imageStatus.textContent);
      } finally { if (life.active && ticket === imageTicket) imageLoading(false); }
    }

    life.on(controls, 'input', event => { if (event.target !== upload) render(); });
    life.on(upload, 'change', async () => {
      const file = upload.files && upload.files[0];
      if (!file) return;
      if (file.size > 10 * 1024 * 1024) { life.notify('Image is too large. Choose a file up to 10 MB.'); upload.value = ''; return; }
      if (!['image/png', 'image/jpeg', 'image/webp', 'image/gif'].includes(file.type)) { life.notify('Choose a PNG, JPG, WebP, or GIF image.'); upload.value = ''; return; }
      const ticket = ++imageTicket;
      imageLoading(true); imageStatus.textContent = 'Reading image…';
      try {
        const dataURL = await S.fileToDataURL(file);
        if (life.active && ticket === imageTicket) await loadImage(dataURL, file.name.slice(0, 100));
      } catch (error) { if (life.active && ticket === imageTicket) { imageStatus.textContent = 'Could not read that image.'; life.notify(imageStatus.textContent); imageLoading(false); } }
      finally { if (life.active) upload.value = ''; }
    });
    life.on(clearImage, 'click', () => {
      imageTicket++; image = null; imageData = ''; imageLoading(false); upload.value = '';
      imageStatus.textContent = 'No image selected. PNG, JPG, WebP, or GIF · up to 10 MB.';
      clearImage.disabled = true; render();
    });
    function asPNG() {
      render();
      return new Promise((resolve, reject) => {
        try { canvas.toBlob(blob => blob ? resolve(blob) : reject(new Error('PNG export failed.')), 'image/png'); }
        catch (error) { reject(error); }
      });
    }
    life.action(redraw, async () => { render(); life.notify('Cover preview refreshed.'); });
    life.action(save, async () => { if (imageBusy) return; await S.save('cover-maker-draft-v1', readState()); life.notify('Cover draft and image saved in this browser.'); });
    life.action(download, async () => {
      if (imageBusy) return;
      await S.download(await asPNG(), slug(title.value || 'cover-art') + '.png'); life.notify('1024 × 1024 PNG exported.');
    });
    life.action(saveFile, async () => {
      if (imageBusy) return;
      await S.saveFile({ name: slug(title.value || 'cover-art') + '.png', type: 'image/png', content: await asPNG() }); life.notify('Cover PNG saved to Files.');
    });
    clearImage.disabled = true; render();
    if (initial.image) await loadImage(initial.image, 'Saved image');
    return () => { life.cleanup(); imageTicket++; image = null; imageData = ''; };
  });
})();
