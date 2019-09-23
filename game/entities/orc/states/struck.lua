local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()

  end

  function State:start(player)
    ent.isHittable = false
    _G.m.addTimer(1, function()
      if self.prevStateName == 'attacking' then
        ent:setState('blocking', player)
      else
        ent:setState('injured', player)
      end
    end)
  end

  function State:exit()
  end

  return State
end

return Public
