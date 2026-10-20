package.path = './?.lua;' .. package.path
local events, hotkeys, rendered = {}, {}, {}
local targetIsNPC = true
local click = nil
registerForEvent = function(k, handler) events[k] = handler end
registerHotkey = function(k, _, handler) hotkeys[k] = handler end
json = { encode = function(world) return '{"schema":1,"sequence":' .. world.sequence .. '}' end }
Game = {
  GetPlayer = function() return {} end,
  GetTargetingSystem = function() return {
    GetLookAtObject = function() return {
      IsNPC = function() return targetIsNPC end,
      GetEntityID = function() return { hash=424242 } end,
      GetDisplayName = function() return 'Test Character' end,
    } end,
  } end,
}
ImGui = {
  Begin = function() end, End = function() end, Separator = function() end,
  SameLine = function() end, Text = function(s) rendered[#rendered+1] = s end,
  Button = function(s) if click == s then click = nil; return true end return false end,
}
-- Loading a CET script in a mock confirms Lua syntax and event registrations.
assert(loadfile('init.lua'))()
assert(type(events.onInit)=='function' and type(events.onDraw)=='function')
assert(type(events.onOverlayOpen)=='function' and type(events.onOverlayClose)=='function')
assert(type(hotkeys.nightCityEchoesCapture)=='function')
events.onInit()
targetIsNPC = false
hotkeys.nightCityEchoesCapture()
targetIsNPC = true
hotkeys.nightCityEchoesCapture()
events.onOverlayOpen()
click = 'Helped'
events.onDraw()
rendered = {}
events.onDraw()
local textOut = table.concat(rendered,'\n')
assert(textOut:find('Test Character',1,true))
assert(textOut:find('Reputation: 18',1,true))
assert(textOut:find('Total recorded encounters: 1',1,true))
local file = assert(io.open('night_city_echoes.json','r'))
assert(file:read('*a'):find('"sequence":1',1,true))
file:close()
os.remove('night_city_echoes.json')
rendered = {}
events.onOverlayClose()
events.onDraw()
assert(#rendered == 0)
print('PASS: 9 mocked CET adapter checks (not tested inside Cyberpunk 2077)')
