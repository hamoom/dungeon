local stopped = require('objects.player.states.stopped')
local running = require('objects.player.states.running')
local attacking = require('objects.player.states.attacking')

local Public = {}

function Public.new(obj)

  local list = {
    stopped = stopped,
    running = running,
    attacking = attacking
  }

  for _, v in pairs(list) do
    v.obj = obj
  end

  function list:getState(state)
    return self[state]
  end

  return list
end


return Public
