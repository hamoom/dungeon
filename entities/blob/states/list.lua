local wandering = require('entities.blob.states.wandering')
local injured = require('entities.blob.states.injured')
local attacking = require('entities.blob.states.attacking')

local Public = {}

function Public.new(ent)

  local list = {
    wandering = wandering,
    injured = injured,
    attacking = attacking
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
