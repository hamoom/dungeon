local wandering = require('entities.blob.states.wandering')
-- local running = require('entities.player.states.running')
-- local attacking = require('entities.player.states.attacking')

local Public = {}

function Public.new(ent)

  local list = {
    wandering = wandering,
    -- running = running,
    -- attacking = attacking
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
