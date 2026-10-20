-- Night City Echoes: original, engine-independent memory/reputation model.
-- Does not contain code or assets from enRAGE or Cyberpunk 2077.
local M = {}

local impact = {
  helped = 18,
  spared = 12,
  threatened = -16,
  robbed = -28,
  betrayed = -38,
  reconciled = 14,
}

local function clamp(n)
  return math.max(-100, math.min(100, n))
end

function M.new()
  return { schema = 1, npcs = {}, factions = {}, events = {}, sequence = 0 }
end

function M.restore(value)
  if type(value) ~= 'table' or value.schema ~= 1
      or type(value.npcs) ~= 'table' or type(value.factions) ~= 'table'
      or type(value.events) ~= 'table' or type(value.sequence) ~= 'number' then
    return nil, 'Invalid or unsupported save schema'
  end
  return value
end

function M.disposition(reputation)
  if reputation >= 35 then return 'ally' end
  if reputation <= -35 then return 'nemesis' end
  if reputation < 0 then return 'suspicious' end
  return 'neutral'
end

-- Identity: { key = engine-derived identifier, name = label, faction = label }.
-- Events are explicit choices for v0.1, not automatic combat detectors.
function M.record(world, identity, action, timestamp)
  if type(world) ~= 'table' or world.schema ~= 1 then return nil, 'Invalid world' end
  if type(identity) ~= 'table' or type(identity.key) ~= 'string' or identity.key == '' then
    return nil, 'Invalid NPC identity'
  end
  local change = impact[action]
  if not change then return nil, 'Unknown encounter type' end
  local faction = tostring(identity.faction or 'unaffiliated')
  local npc = world.npcs[identity.key]
  if not npc then
    npc = { name = tostring(identity.name or identity.key), faction = faction, respect = 0, memories = {} }
    world.npcs[identity.key] = npc
  end
  npc.name = tostring(identity.name or npc.name)
  npc.faction = faction
  npc.respect = clamp((npc.respect or 0) + change)
  local group = world.factions[faction] or { respect = 0, events = 0 }
  group.respect = clamp(group.respect + (change > 0 and math.ceil(change / 3) or math.floor(change / 3)))
  group.events = group.events + 1
  world.factions[faction] = group
  world.sequence = world.sequence + 1
  local item = { id = world.sequence, npcId = identity.key, name = npc.name,
    faction = faction, action = action, change = change, time = tonumber(timestamp) or 0 }
  table.insert(npc.memories, item)
  table.insert(world.events, item)
  -- Bound growth: keep most recent events and memories in save data.
  if #npc.memories > 60 then table.remove(npc.memories, 1) end
  if #world.events > 500 then table.remove(world.events, 1) end
  return item
end

return M
