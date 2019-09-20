local Public = {}

function Public.new(ent)
  local State = {}


  function State:update()
    ent:setLinearVelocity(0,0)
  end

  function State:start(player)
    ent.fixedRotation = true

    local SpriteComponent = ent.components.sprite
    SpriteComponent:setFacing('block-f', 'block-b', 'block-s', true)
    self.attackTimer = _G.m.addTimer(200, function()
      ent:setState('attacking', player)
    end)
  end

  function State:exit()
    ent.fixedRotation = false
    timer.cancel(self.attackTimer)
  end

  return State
end

return Public
