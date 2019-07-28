local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()
  end

  function State:start(player)
    local impulseSpeed = 100

    ent.alpha = 0.3
    ent:setLinearVelocity(0, 0)

    local diff = p.newFromSubtraction(ent, player):normalize()

    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    timer.performWithDelay(1000, function()
      ent:setState('stopped', player)
    end, 1)
  end

  function State:exit()
    ent.alpha = 1
  end


  return State
end

return Public
