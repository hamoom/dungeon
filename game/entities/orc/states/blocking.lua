local Public = {}

function Public:new(ent)
  local State = {}


  function State:update(player)
    ent:setLinearVelocity(0,0)

  end

  function State:start(player)
    -- ent.rotation = _G.h.rotateToward(ent, player)
    ent.fixedRotation = true
    self.attackTimer = _G.m.addTimer(200, function()
      ent:setState('attacking', player)
    end)
  end

  function State:exit(player)
    ent.fixedRotation = false
    timer.cancel(self.attackTimer)
  end

  return State
end

return Public
