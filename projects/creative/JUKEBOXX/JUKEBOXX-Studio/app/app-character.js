(() => {
 'use strict';
 const chip=document.getElementById('appCharacter'), image=document.getElementById('appCharacterImage'), name=document.getElementById('appCharacterName');
 if(!chip||!image||!name)return;
 chip.href='./studio.html?page=character';
 chip.setAttribute('aria-label','Open your JUKEBOXX character station');
 chip.title='Your original JUKEBOXX character';
 image.src='./icon.svg';image.hidden=false;name.textContent='CHARACTER';
 chip.style.setProperty('--character-hue','0deg');
 function update(){const request=indexedDB.open('jukeboxx-studio',1);request.onupgradeneeded=()=>{if(!request.result.objectStoreNames.contains('state'))request.result.createObjectStore('state');};request.onsuccess=()=>{const db=request.result;const read=db.transaction('state').objectStore('state').get('mascot');read.onsuccess=()=>{const m=read.result;if(m&&typeof m.dataURL==='string'&&/^data:image\/(png|jpeg|webp);base64,/.test(m.dataURL)){image.src=m.dataURL;name.textContent=String(m.name||'JUKEBOXX').slice(0,40);}else{image.src='./icon.svg';name.textContent='CHARACTER';}db.close();};read.onerror=()=>db.close();};}
 window.addEventListener('pageshow',update);update();
})();