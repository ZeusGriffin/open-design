-- Offline CET-file-bridge smoke test. Run from ./mod with Lua 5.1+.
package.path = './?.lua;' .. package.path
json = {
  encode = function(value)
    return '{"schema":1,"id":"' .. value.id .. '","encounters":["helped"]}'
  end,
  decode = function(_)
    return {schema=1,id=_G.expectedID,status='ok',npc_name='Test NPC',
            heard='Hello',reply='Hello back',spoken=false}
  end
}
ImGui = {
  Text = function(_) end,
  Separator = function() end,
}
local Voice = require('voice_bridge')
local state = Voice.new()
assert(Voice.request(state, nil, 0, 'neutral') == false)
assert(state.pending == nil)
local npc = {key='test-character-1',name='Test NPC'}
local events = {{action='helped'}, {action='threatened'}}
assert(Voice.request(state, npc, 18, 'neutral', events) == true)
assert(type(state.pending) == 'string')
assert(Voice.request(state, npc, 18, 'neutral', events) == false)
local file = assert(io.open('voice_request.json', 'r'))
local request = file:read('*a')
file:close()
assert(request:find('"schema":1',1,true))
assert(request:find('"encounters":["helped"]',1,true))
_G.expectedID = state.pending
local output = assert(io.open('voice_response.json','w'))
output:write('{"schema":1}')
output:close()
Voice.poll(state,0.5)
assert(state.pending == nil)
assert(state.lastHeard == 'Hello' and state.lastReply == 'Hello back')
Voice.draw(state)
os.remove('voice_request.json')
os.remove('voice_response.json')
print('PASS: local voice bridge request, prior encounters, response, and journal UI')
