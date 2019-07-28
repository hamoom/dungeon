local m = require("myapp")
local p = require('lib.point')
local Public = {}


function Public:new(ent)
  local State = {}

  function State:update()
  end

  function State:start(enemy)
    ent.health = ent.health - 1
    Runtime:dispatchEvent({ name = 'changeHealth', params = { health = ent.health }})

    local diff = p.newFromSubtraction(ent, enemy):normalize()
    diff.x = diff.x + (math.random(-100, 100) / 100)
    diff.y = diff.y + (math.random(-100, 100) / 100)

    ent:setLinearVelocity(0,0)
    ent:applyLinearImpulse(0.2 * diff.x, 0.2  * diff.y, ent.x, ent.y)
    ent.alpha = 0.3
    m.addTimer(500, function()
      ent.alpha = 1
      ent:setState('stopped')
    end)

    if ent.health <= 0 then
      ent.health = 0
      Runtime:dispatchEvent({ name = 'gameOver' })
    end

  end

  function State:exit()
  end


  return State
end


return Public
