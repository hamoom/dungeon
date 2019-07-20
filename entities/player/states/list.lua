local stopped = require('entities.player.states.stopped')
local running = require('entities.player.states.running')
local attacking = require('entities.player.states.attacking')
local injured = require('entities.player.states.injured')

local Public = {}

function Public.new(ent)

  local list = {
    stopped = stopped,
    running = running,
    attacking = attacking,
    injured = injured,
  }

  for _, v in pairs(list) do
    v.ent = ent
  end

  function list:getState(state)
    return self[state]
  end

  return list
end

return Public
