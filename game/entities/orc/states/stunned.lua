local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()

  end

  function State:start(player)
    ent.isHittable = false
    self.timer = _G.m.addTimer(500, function()
      ent:setState('chasing', player)
    end)
  end

  function State:exit()
    ent.isHittable = true
    _G.m.cancelTimer(self.timer)
  end


  return State
end

return Public
