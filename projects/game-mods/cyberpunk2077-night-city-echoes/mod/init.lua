-- Night City Echoes v0.1 - manually records encounters for targeted NPCs.
-- A Cyber Engine Tweaks mod. Only use in single-player Story Mode.
local Core = require('core')
local SAVE_FILE = 'night_city_echoes.json' -- CET io sandbox is relative to this mod folder.
local world = Core.new()
local selected = nil
local uiOpen = false
local notice = 'Look at an NPC in-game, then use the Capture NPC hotkey.'

local function saveWorld()
  local success, err = pcall(function()
    local encoded = json.encode(world)
    local file, openErr = io.open(SAVE_FILE, 'w')
    if not file then error(openErr or 'cannot open save file') end
    file:write(encoded)
    file:close()
  end)
  if not success then
    notice = 'Could not save: ' .. tostring(err)
    print('[Night City Echoes] ' .. notice)
  end
  return success
end

local function loadWorld()
  local file = io.open(SAVE_FILE, 'r')
  if not file then return end
  local raw = file:read('*a')
  file:close()
  local ok, decoded = pcall(json.decode, raw)
  if ok then
    local restored, err = Core.restore(decoded)
    if restored then world = restored; return end
    notice = 'Save rejected: ' .. tostring(err)
  else
    notice = 'Save corrupt: previous data not overwritten until new action.'
  end
  print('[Night City Echoes] ' .. notice)
end

local function captureNPC()
  local ok, outcome = pcall(function()
    local player = Game.GetPlayer()
    if not player then return nil end
    local system = Game.GetTargetingSystem()
    if not system then return nil end
    local npc = system:GetLookAtObject(player)
    if not npc or not npc:IsNPC() then return nil end
    local entityId = npc:GetEntityID()
    if not entityId then return nil end
    local id = entityId.hash and tostring(entityId.hash) or tostring(entityId)
    if id == '' or id == 'nil' then return nil end
    local label = id
    pcall(function()
      local value = npc:GetDisplayName()
      if value then label = tostring(value) end
    end)
    -- Faction detection varies by entity type and patch; don't claim to know it.
    return { key = id, name = label, faction = 'unaffiliated' }
  end)
  if not ok then
    notice = 'Target API unavailable: ' .. tostring(outcome)
    return
  end
  if not outcome then
    notice = 'No NPC targeted. Aim directly at a person in Story Mode.'
    return
  end
  selected = outcome
  local existing = world.npcs[selected.key]
  notice = 'Captured ' .. selected.name .. (existing and ' (remembered)' or ' (new)')
  print('[Night City Echoes] ' .. notice)
end

local function logAction(action)
  if not selected then
    notice = 'Capture an NPC before recording an event.'
    return
  end
  local entry, err = Core.record(world, selected, action, os.time())
  if not entry then
    notice = tostring(err)
    return
  end
  notice = selected.name .. ': ' .. action .. ' (' .. tostring(entry.change) .. ')'
  saveWorld()
end

-- CET reads game pointers only after onInit.
registerForEvent('onInit', function()
  loadWorld()
  print('[Night City Echoes] v0.1 started. Bind Capture NPC in CET > Bindings.')
end)

registerHotkey('nightCityEchoesCapture', 'Night City Echoes: Capture NPC', function()
  captureNPC()
end)

registerForEvent('onOverlayOpen', function() uiOpen = true end)
registerForEvent('onOverlayClose', function() uiOpen = false end)
registerForEvent('onDraw', function()
  if not uiOpen then return end
  ImGui.Begin('Night City Echoes - Memory Journal')
  ImGui.Text('Prototype: tracks player choices; does not control NPC AI yet.')
  ImGui.Text(notice)
  if ImGui.Button('Capture targeted NPC') then captureNPC() end
  if selected then
    ImGui.Separator()
    ImGui.Text('NPC: ' .. selected.name)
    ImGui.Text('Identifier: ' .. selected.key)
    local saved = world.npcs[selected.key]
    local respect = saved and saved.respect or 0
    ImGui.Text('Reputation: ' .. tostring(respect) .. ' / ' .. Core.disposition(respect))
    if ImGui.Button('Helped') then logAction('helped') end
    ImGui.SameLine()
    if ImGui.Button('Spared') then logAction('spared') end
    ImGui.SameLine()
    if ImGui.Button('Threatened') then logAction('threatened') end
    if ImGui.Button('Robbed') then logAction('robbed') end
    ImGui.SameLine()
    if ImGui.Button('Betrayed') then logAction('betrayed') end
    ImGui.SameLine()
    if ImGui.Button('Reconciled') then logAction('reconciled') end
    if saved then
      ImGui.Text('Memories for this NPC: ' .. tostring(#saved.memories))
      local from = math.max(1, #saved.memories - 5)
      for i = #saved.memories, from, -1 do
        local e = saved.memories[i]
        ImGui.Text('#' .. tostring(e.id) .. ' ' .. e.action .. ' (' .. tostring(e.change) .. ')')
      end
    end
  end
  ImGui.Separator()
  ImGui.Text('Total recorded encounters: ' .. tostring(world.sequence))
  if ImGui.Button('Save journal') then
    if saveWorld() then notice = 'Journal saved.' end
  end
  ImGui.End()
end)
