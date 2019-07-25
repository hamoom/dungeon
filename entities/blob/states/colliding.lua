local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)
  local State = {}
  State.name = 'colliding'

  function State:update(player)
    ent:setLinearVelocity(0,0)
  end

  function State:start(player)

  end

  function State:exit(player)

  end

  return State
end

return Public
