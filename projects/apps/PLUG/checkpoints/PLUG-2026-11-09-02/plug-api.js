const json=(v,status=200)=>new Response(JSON.stringify(v),{status,headers:{'Content-Type':'application/json','Cache-Control':'no-store','X-Content-Type-Options':'nosniff'}});
const tools=[{name:'plug_read_workspace',description:'Read the signed-in user’s explicitly cloud-saved PLUG workspace and revision.',inputSchema:{type:'object',properties:{},additionalProperties:false}},{name:'plug_save_draft',description:'Save a named UI or code draft for user review. Does not overwrite the workspace, compile, flash or format.',inputSchema:{type:'object',properties:{name:{type:'string',maxLength:120},content:{type:'string',maxLength:100000}},required:['name','content'],additionalProperties:false}},{name:'plug_list_drafts',description:'List the signed-in user’s agent drafts awaiting review.',inputSchema:{type:'object',properties:{},additionalProperties:false}}];
function prefix(req){const id=req.headers.get('oai-authenticated-user-id');return id?'users/'+encodeURIComponent(id)+'/':null}
async function listDrafts(bucket,p){let r=await bucket.list({prefix:p+'drafts/',limit:50});let values=await Promise.all(r.objects.map(async o=>{let v=await bucket.get(o.key);return v?JSON.parse(await v.text()):null}));return values.filter(Boolean)}
export async function api(req,env){const path=new URL(req.url).pathname;
if(path==='/mcp'){
 let b;try{b=await req.json()}catch{return json({error:'Invalid JSON'},400)}
 const reply=(result)=>json({jsonrpc:'2.0',id:b.id??null,result});
 if(b.method==='server/discover'||b.method==='initialize')return reply({protocolVersion:'2026-07-28',supportedVersions:['2026-07-28'],capabilities:{tools:{}},serverInfo:{name:'PLUG',version:'0.2'}});
 if(b.method==='tools/list')return reply({tools});
 if(b.method!=='tools/call')return json({jsonrpc:'2.0',id:b.id??null,error:{code:-32601,message:'Method not found'}});
 let p=prefix(req);if(!p)return reply({content:[{type:'text',text:'Sign in with ChatGPT to access your own workspace.'}],isError:true});
 if(!env.BUCKET)return reply({content:[{type:'text',text:'Cloud storage unavailable.'}],isError:true});
 try{let name=b.params?.name,args=b.params?.arguments||{},v;
 if(name==='plug_read_workspace'){let f=await env.BUCKET.get(p+'workspace.json');v=f?{revision:f.etag,workspace:JSON.parse(await f.text())}:{revision:null,workspace:null,message:'Open PLUG → Agents and save your browser workspace to cloud first.'}}
 else if(name==='plug_list_drafts')v=await listDrafts(env.BUCKET,p);
 else if(name==='plug_save_draft'){if(typeof args.name!=='string'||!args.name.trim()||args.name.length>120||typeof args.content!=='string'||args.content.length>100000)throw Error('Invalid name or content');let id=crypto.randomUUID();v={id,name:args.name,content:args.content,createdAt:new Date().toISOString(),status:'Awaiting user review'};await env.BUCKET.put(p+'drafts/'+id+'.json',JSON.stringify(v))}
 else throw Error('Unknown tool');
 return reply({content:[{type:'text',text:JSON.stringify(v)}]});}catch(e){return reply({content:[{type:'text',text:e.message}],isError:true})}
}
if(!path.startsWith('/api/'))return null;
let p=prefix(req);if(!p)return json({error:'Sign in with ChatGPT required.'},401);if(!env.BUCKET)return json({error:'Cloud storage unavailable.'},503);
try{
 if(path==='/api/workspace'&&req.method==='GET'){let f=await env.BUCKET.get(p+'workspace.json');return json(f?{revision:f.etag,workspace:JSON.parse(await f.text())}:{revision:null,workspace:null})}
 if(path==='/api/workspace'&&req.method==='PUT'){
 if(!req.headers.get('content-type')?.includes('application/json'))return json({error:'JSON required'},415);
 if(new URL(req.url).origin!==req.headers.get('origin'))return json({error:'Same-origin browser save required'},403);
 let raw=await req.text();if(raw.length>4000000)return json({error:'Workspace exceeds 4 MB. Export images locally or reduce references.'},413);let v=JSON.parse(raw);if(!Array.isArray(v.projects)||!v.projects.length)return json({error:'Invalid workspace'},400);
 let expected=req.headers.get('If-Match'),current=await env.BUCKET.head(p+'workspace.json');if((current?.etag||'new')!==expected)return json({error:'Cloud changed or not checked. Check cloud status before saving.'},409);
 const written=await env.BUCKET.put(p+'workspace.json',raw,{onlyIf:current?{etagMatches:current.etag}:{etagDoesNotMatch:'*'}});if(!written)return json({error:'Cloud changed. Reload cloud status.'},409);return json({revision:written.etag,saved:true});
 }
 if(path==='/api/drafts'&&req.method==='GET')return json({drafts:await listDrafts(env.BUCKET,p)});
 return json({error:'Not found'},404);
}catch(e){return json({error:e.message},400)}
}
