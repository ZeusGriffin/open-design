package.path = './?.lua;./tests/../?.lua;' .. package.path
local core = require('core')
local state = core.new()
local v = { key = 'named-npc:1', name = 'Mara', faction = 'maelstrom' }
local e, err = core.record(state, v, 'helped', 10)
assert(e and not err and state.npcs[v.key].respect == 18)
assert(core.disposition(state.npcs[v.key].respect) == 'neutral')
core.record(state, v, 'helped', 11)
assert(core.disposition(state.npcs[v.key].respect) == 'ally')
core.record(state, v, 'betrayed', 12)
core.record(state, v, 'robbed', 13)
assert(core.disposition(state.npcs[v.key].respect) == 'suspicious')
core.record(state, v, 'betrayed', 14)
assert(core.disposition(state.npcs[v.key].respect) == 'nemesis')
assert(state.factions.maelstrom and state.factions.maelstrom.events == 5)
assert(state.sequence == 5 and #state.events == 5)
assert(core.record(state, v, 'invalid', 15) == nil)
assert(core.restore(state) == state)
assert(core.restore({schema=99}) == nil)
local t = {key='other-npc',name='Zed',faction='maelstrom'}
for i=1,600 do core.record(state,t,'spared',100+i) end
assert(#state.events==500 and #state.npcs[t.key].memories==60)
assert(state.npcs[t.key].respect == 100 and state.factions.maelstrom.respect <= 100)
print('PASS: 11 Lua core assertions (including bounded history and invalid-save handling)')
