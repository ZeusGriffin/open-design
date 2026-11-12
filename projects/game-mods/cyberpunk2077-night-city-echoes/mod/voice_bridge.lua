-- Night City Echoes local voice bridge (opt-in).
-- Written only for the CET mod's sandbox. Does not change actual NPC AI.
local M = {}
local REQUEST_FILE = 'voice_request.json'
local RESPONSE_FILE = 'voice_response.json'
local sequence = 0

function M.new()
  return { pending = nil, status = 'Voice off; start local service and bind Talk hotkey.',
           lastHeard = '', lastReply = '', lastNPC = '', elapsed = 0 }
end

local function writeJson(name, data)
  local ok, err = pcall(function()
    local file, openErr = io.open(name, 'w')
    if not file then error(openErr or 'cannot open request file') end
    file:write(json.encode(data))
    file:close()
  end)
  return ok, err
end

local function readJson(name)
  local file = io.open(name, 'r')
  if not file then return nil end
  local raw = file:read('*a')
  file:close()
  local success, value = pcall(json.decode, raw)
  if success and type(value) == 'table' then return value end
  return nil
end

function M.request(state, npc, respect, disposition, memories)
  if not npc or type(npc.key) ~= 'string' then
    state.status = 'Aim at an NPC, capture it, then press Talk.'
    return false
  end
  if state.pending then
    state.status = 'A voice request is already pending.'
    return false
  end
  sequence = sequence + 1
  local id = tostring(os.time()) .. '-' .. tostring(sequence) .. '-' .. tostring(math.random(100000,999999))
  local encounters = {}
  if type(memories) == 'table' then
    for i = math.max(1, #memories - 5), #memories do
      local item = memories[i]
      if type(item) == 'table' and type(item.action) == 'string' then
        table.insert(encounters, item.action)
      end
    end
  end
  local packet = {
    schema = 1, id = id, npc_key = npc.key, npc_name = tostring(npc.name or npc.key),
    reputation = respect or 0, disposition = disposition or 'neutral',
    encounters = encounters, mode = 'microphone'
  }
  local ok, err = writeJson(REQUEST_FILE, packet)
  if not ok then
    state.status = 'Voice request could not be saved: ' .. tostring(err)
    return false
  end
  state.pending = id
  state.status = 'Voice requested. Speak into your normal Windows microphone when prompted.'
  return true
end

function M.poll(state, delta)
  state.elapsed = state.elapsed + (tonumber(delta) or 0)
  if state.elapsed < 0.4 or not state.pending then return end
  state.elapsed = 0
  local data = readJson(RESPONSE_FILE)
  if not data or data.schema ~= 1 or tostring(data.id) ~= state.pending then return end
  state.pending = nil
  if data.status == 'ok' then
    state.lastHeard = tostring(data.heard or '')
    state.lastReply = tostring(data.reply or '')
    state.lastNPC = tostring(data.npc_name or '')
    state.status = data.spoken and 'Local NPC reply played through Windows speakers.' or
                   'NPC reply ready in journal (Windows speech not active).'
  else
    state.status = 'Voice companion error: ' .. tostring(data.error or 'Unknown error')
  end
end

function M.draw(state)
  ImGui.Separator()
  ImGui.Text('AI Voice Companion (experimental / opt-in)')
  ImGui.Text('Mic is only used after pressing Talk; local Python companion required.')
  ImGui.Text(state.status)
  if state.lastHeard ~= '' then ImGui.Text('You: ' .. state.lastHeard) end
  if state.lastReply ~= '' then
    ImGui.Text((state.lastNPC ~= '' and state.lastNPC or 'NPC') .. ': ' .. state.lastReply)
  end
end

return M
