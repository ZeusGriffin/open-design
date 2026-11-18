(() => {
  'use strict';
  const characters = [
    {id:'juke',name:'JUKE',color:'#5f91ff',hue:0,armor:'COBALT',alias:'THE ORIGINAL',description:'The original JUKEBOXX pilot. Cobalt armor, cyan joints, ready for your next creative session.'},
    {id:'echo',name:'ECHO',color:'#72e5dc',hue:-55,armor:'MINT',alias:'FIND YOUR SIGNAL',description:'A fresh signal in mint armor. Same creative spirit, a different color for your workstation.'},
    {id:'bass',name:'BASS',color:'#ffbc69',hue:165,armor:'AMBER',alias:'SET THE RHYTHM',description:'Warm amber armor for a bold first impression. Bring a little more energy to your creative session.'},
    {id:'nova',name:'NOVA',color:'#c5a0ff',hue:45,armor:'VIOLET',alias:'AFTER HOURS',description:'Violet armor for the late-night session. Choose your look, then get back to making something.'}
  ];
  const $ = id => document.getElementById(id);
  const choices = Array.from(document.querySelectorAll('[data-character]'));
  const storageKey = 'juke-character-v1';
  let selected = 0, storageAvailable = true, confirming = false;
  try {
    const saved = JSON.parse(localStorage.getItem(storageKey)||'null');
    const found = characters.findIndex(c => c.id === saved?.id);
    if (found >= 0) selected = found;
  } catch (_) { storageAvailable = false; }
  function render(announce = true) {
    const c = characters[selected];
    document.documentElement.style.setProperty('--accent',c.color);
    document.documentElement.style.setProperty('--hue',c.hue+'deg');
    $('characterName').textContent = c.name;
    $('characterAlias').textContent = c.alias;
    $('characterDescription').textContent = c.description;
    $('unitNumber').textContent = 'UNIT 0'+(selected+1)+' / CREATIVE PILOT';
    $('stageUnit').textContent = 'UNIT 0'+(selected+1)+' / '+c.armor;
    $('armorName').textContent = c.armor;
    $('stageCaption').textContent = c.name+' / '+c.armor+' ARMOR';
    $('characterImage').alt = c.name+' in '+c.armor.toLowerCase()+' low-poly armor';
    choices.forEach(button => button.setAttribute('aria-pressed',String(button.dataset.character===c.id)));
    if(announce) $('selectionAnnouncement').textContent=c.name+' selected. '+c.armor.toLowerCase()+' armor.';
    if(!storageAvailable){$('saveHint').textContent='Your choice opens this session. This browser may not remember it.';$('saveHint').classList.add('warning');}
  }
  function choose(index, focus = false) {
    selected = (index+characters.length)%characters.length;
    render();
    if(focus) choices[selected].focus({preventScroll:true});
  }
  choices.forEach(button => button.addEventListener('click',()=>{
    const index = characters.findIndex(c=>c.id===button.dataset.character);
    if(index>=0) choose(index);
  }));
  $('previousCharacter').addEventListener('click',()=>choose(selected-1));
  $('nextCharacter').addEventListener('click',()=>choose(selected+1));
  document.addEventListener('keydown',event=>{
    if(event.altKey||event.ctrlKey||event.metaKey) return;
    if(event.key==='ArrowLeft'||event.key==='ArrowRight') {
      event.preventDefault();choose(selected+(event.key==='ArrowRight'?1:-1),true);
    }
  });
  $('confirmCharacter').addEventListener('click',()=>{
    if(confirming)return;
    confirming=true;
    const c=characters[selected];
    try {localStorage.setItem(storageKey,JSON.stringify({id:c.id,name:c.name,color:c.color,hue:c.hue}));}
    catch(_){storageAvailable=false;}
    // Pass only a known roster ID, so selection still works if storage is disabled.
    location.href='./game-app.html?character='+encodeURIComponent(c.id);
  });
  render(false);
})();
