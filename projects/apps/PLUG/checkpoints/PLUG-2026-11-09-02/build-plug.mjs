import fs from 'node:fs';
const html=fs.readFileSync('source/index.html','utf8');const api=fs.readFileSync('worker/plug-api.js','utf8').replace('export async function api','async function api');
fs.mkdirSync('dist/server',{recursive:true});fs.writeFileSync('dist/server/index.js',api+'\nconst html='+JSON.stringify(html)+';\nexport default {async fetch(request,env){const result=await api(request,env);if(result)return result;if(request.method!=="GET")return new Response("Method not allowed",{status:405});return new Response(html,{headers:{"Content-Type":"text/html;charset=utf-8","X-Content-Type-Options":"nosniff"}})}};');
console.log('Built PLUG Worker + authenticated API');
