local Public = {}

function Public.new(ent)
  local State = {}

  function State:update(player)
  end

  function State:start(player)
    local SpriteComponent = ent.components.sprite
    SpriteComponent:setAnim('death')

    self.timer = _G.m.addTimer(1000, function()
      ent:destroy()
    end)
  end

  function State:exit(player)
    _G.m.cancelTimer(self.timer)
  end


  return State
end

return Public
