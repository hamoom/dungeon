local Public = {}

function Public.new(ent)
  local State = {}

  function State:update(player)

  end

  function State:start(player)

    local SpriteComponent = ent.components.sprite
    SpriteComponent:setAnim('wandering')

    self.timer = _G.m.addTimer(500, function()

      if _G.p.new(ent):distanceTo(player) < ent.attackDistance then
        ent:setState('attacking', player)
      else
        ent:setState('wandering', player)
      end
    end)
  end

  function State:exit(player)
    _G.m.cancelTimer(self.timer)
  end


  return State
end

return Public
