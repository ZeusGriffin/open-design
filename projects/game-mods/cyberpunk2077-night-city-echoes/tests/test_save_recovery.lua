-- Run from the mod folder: texlua --luaonly ../tests/test_save_recovery.lua
-- Mock only. Proves an unreadable save is kept as .bak before the first new action overwrites it.
package.path = './?.lua;' .. package.path
local events, hotkeys = {}, {}
registerForEvent = function(k, handler) events[k] = handler end
registerHotkey = function(k, _, handler) hotkeys[k] = handler end
json = {
  encode = function(world) return '{"schema":1,"sequence":' .. world.sequence .. '}' end,
  decode = function() error('mock: unreadable save') end,
}
Game = {
  GetPlayer = function() return {} end,
  GetTargetingSystem = function() return { GetLookAtObject = function() return {
    IsNPC = function() return true end,
    GetEntityID = function() return { hash = 1 } end,
    GetDisplayName = function() return 'Test Character' end,
  } end } end,
}
local click
ImGui = {
  Begin = function() end, End = function() end, Separator = function() end, SameLine = function() end,
  Text = function() end,
  Button = function(s) if click == s then click = nil; return true end return false end,
}

local CORRUPT = '{ this is corrupt'
local f = assert(io.open('night_city_echoes.json', 'w'))
f:write(CORRUPT)
f:close()

assert(loadfile('init.lua'))()
events.onInit()
hotkeys.nightCityEchoesCapture()
events.onOverlayOpen()
click = 'Helped'
events.onDraw()

local bak = assert(io.open('night_city_echoes.json.bak', 'r'), 'backup file missing')
assert(bak:read('*a') == CORRUPT, 'backup content differs from original save')
bak:close()
local main = assert(io.open('night_city_echoes.json', 'r'))
assert(main:read('*a'):find('"sequence":1', 1, true), 'new save not written')
main:close()
os.remove('night_city_echoes.json')
os.remove('night_city_echoes.json.bak')
print('PASS: 3 save-recovery checks (mocked CET, not tested inside Cyberpunk 2077)')
