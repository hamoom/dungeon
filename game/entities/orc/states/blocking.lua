local Spark = require('decorations.spark')
local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
  end

  function State:start(player)
    ent.isHittable = false
    ent.fixedRotation = true

    local impulseSpeed = 20
    local diff = _G.p.newFromSubtraction(ent, player):normalize()

    ent:setLinearVelocity(0, 0)
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    ent.spark = Spark.new(_G.m.map.layer['decorations'], {x = ent.x, y = ent.y })
    ent.spark:flare()

    _G.m.addTimer(300, function()
      ent.isHittable = true
    end)

    self.chaseTimer = _G.m.addTimer(1000, function()
      ent:setState('chasing', player)
    end)
  end

  function State:exit()
    _G.m.cancelTimer(self.chaseTimer)
    ent.fixedRotation = false
  end

  return State
end

return Public
