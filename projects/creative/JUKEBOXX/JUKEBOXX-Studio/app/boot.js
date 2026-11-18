(() => {
  'use strict';
  const boot = document.getElementById('boot');
  const menu = document.querySelector('main');
  const white = document.getElementById('bootWhite');
  const black = document.getElementById('bootBlack');
  const skip = document.getElementById('bootSkip');
  const sound = document.getElementById('bootSound');
  const replay = document.getElementById('bootReplay');
  const launch = document.getElementById('launch');
  const hint = document.getElementById('bootHint');
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  const storageKey = 'juke-view-boot-seen-v1';
  let timers = [], audio, master, voices = [], audible = false, running = false, phase = 'white';
  function cancelTimers() { timers.forEach(clearTimeout); timers = []; }
  function later(fn, delay) { timers.push(setTimeout(fn, delay)); }
  function silence() {
    if (master && audio) master.gain.setValueAtTime(0, audio.currentTime);
    voices.forEach(osc => { try { osc.stop(); } catch (_) {} });
    voices = [];
  }
  function tone(frequency, offset, duration, level, type = 'sine', endFrequency) {
    const at = audio.currentTime + offset;
    const osc = audio.createOscillator(), gain = audio.createGain();
    osc.type = type; osc.frequency.setValueAtTime(frequency, at);
    if (endFrequency) osc.frequency.exponentialRampToValueAtTime(endFrequency, at + duration);
    gain.gain.setValueAtTime(0, at);
    gain.gain.linearRampToValueAtTime(level, at + .18);
    gain.gain.exponentialRampToValueAtTime(.0001, at + duration);
    osc.connect(gain); gain.connect(master); osc.start(at); osc.stop(at + duration + .05);
    voices.push(osc);
  }
  // An original synthesized boot chord; no downloaded video or audio is needed.
  function chime() {
    if (!audible || !audio || audio.state !== 'running') return;
    silence(); master.gain.setValueAtTime(.22, audio.currentTime);
    if (phase === 'white') {
      tone(66, 0, 4, .5, 'sine', 55);
      [130.81,196,261.63,392].forEach((f,i)=>tone(f,.08+i*.1,3.5,.14));
      tone(1200,.05,2.4,.025,'sine',350);
    } else {
      [261.63,329.63,392,523.25].forEach((f,i)=>tone(f,i*.11,3.1,.13,'sine'));
      tone(65.41,0,3.6,.3);
    }
  }
  async function enableSound() {
    audible = !audible;
    sound.setAttribute('aria-pressed', String(audible));
    sound.textContent = audible ? 'SOUND ON' : 'SOUND OFF';
    if (!audible) { silence(); return; }
    try {
      const Audio = window.AudioContext || window.webkitAudioContext;
      if (!Audio) throw Error('Audio unavailable');
      if (!audio) { audio = new Audio(); master = audio.createGain(); master.gain.value = 0; master.connect(audio.destination); }
      await audio.resume();
      if (running && audible) chime();
    } catch (_) { audible = false; sound.textContent = 'SOUND UNAVAILABLE'; sound.setAttribute('aria-pressed','false'); }
  }
  function setPhase(next) {
    phase = next;
    const dark = next === 'black';
    boot.classList.toggle('dark',dark);
    white.classList.toggle('active',!dark); black.classList.toggle('active',dark);
    white.setAttribute('aria-hidden',String(dark)); black.setAttribute('aria-hidden',String(!dark));
    chime();
  }
  function remember() { try { sessionStorage.setItem(storageKey,'1'); } catch (_) {} }
  function seen() { try { return sessionStorage.getItem(storageKey)==='1'; } catch (_) { return false; } }
  function finish(focus = true) {
    running = false; cancelTimers(); silence(); remember();
    boot.hidden = true; boot.classList.remove('running');
    menu.hidden = false; menu.inert = false; document.body.classList.remove('booting');
    if (focus) launch.focus({preventScroll:true});
  }
  function start() {
    cancelTimers(); silence(); running = true;
    menu.hidden = true; menu.inert = true; boot.hidden = false;
    document.body.classList.add('booting'); boot.classList.remove('running');
    // Restart CSS animations when replay is selected.
    white.classList.remove('active'); black.classList.remove('active');
    void boot.offsetWidth;
    if (reduced.matches) {
      setPhase('black'); skip.textContent = 'CONTINUE TO MENU';
      hint.textContent = 'PRESS ENTER TO CONTINUE';
    } else {
      boot.classList.add('running'); setPhase('white'); skip.textContent = 'SKIP INTRO';
      hint.textContent = 'PRESS ENTER OR ESC TO SKIP';
      later(()=>setPhase('black'),4900);
      later(()=>finish(),10500);
    }
    skip.focus({preventScroll:true});
  }
  skip.addEventListener('click',()=>finish());
  sound.addEventListener('click',enableSound);
  replay.addEventListener('click',start);
  document.addEventListener('keydown',event=>{
    if (!running || (event.key !== 'Escape' && event.key !== 'Enter')) return;
    // Let the focused audio button handle Enter without skipping the intro.
    if (event.key==='Enter' && event.target===sound) return;
    event.preventDefault(); event.stopImmediatePropagation(); finish();
  },true);
  window.addEventListener('pagehide',()=>{cancelTimers();silence();});
  window.addEventListener('pageshow',event=>{if(event.persisted) finish(false);});
  reduced.addEventListener('change',()=>{if(running) start();});
  const returning = performance.getEntriesByType('navigation')[0]?.type === 'back_forward';
  if (seen() && (returning || new URLSearchParams(location.search).get('intro')!=='1')) finish(false);
  else start();
})();
