local p = require('lib.point')
local Public = {}


function Public:new(ent)
  local State = {}


  function State:update()
  end

  function State:start(enemy)

    local diff = p.newFromSubtraction(ent, enemy):normalize()
    diff.x = diff.x + (math.random(-100, 100) / 100)
    diff.y = diff.y + (math.random(-100, 100) / 100)

    ent:setLinearVelocity(0,0)
    ent:applyLinearImpulse(0.2 * diff.x, 0.2  * diff.y, ent.x, ent.y)
    ent.alpha = 0.3
    timer.performWithDelay(500, function()
      ent.alpha = 1
      ent:setState('stopped')
    end, 1)
  end

  function State:exit()
    ent.attacking = false
  end


  return State
end


return Public
