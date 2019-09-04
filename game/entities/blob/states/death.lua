local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
  end

  function State:start()
    local SpriteComponent = ent.components.sprite
    SpriteComponent:setAnim('death')

    self.timer = _G.m.addTimer(1000, function()
      ent:destroy()
    end)
  end

  function State:exit()
    _G.m.cancelTimer(self.timer)
  end


  return State
end

return Public
