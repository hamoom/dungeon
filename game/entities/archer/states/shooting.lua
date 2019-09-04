local Public = {}

function Public.new(ent)
  local State = {}

  function State:update(player)
    local ArrowComponent = ent.components.arrow
    ent.rotation = _G.h.rotateToward(ent, player)

    if _G.p.new(ent):distanceTo(player) > ent.attackDistance then
      ent:setState('wandering', player)
    end

    ArrowComponent:fly()

    self.shootTimer = self.shootTimer - _G.m.dt
    if self.shootTimer <= 0 then
      self.shootTimer = 4.5
      ArrowComponent:shoot(player)
    end

  end

  function State:start(player)
    local ArrowComponent = ent.components.arrow
    State.shootTimer = 4.5
    ArrowComponent:shoot(player)
  end

  function State:exit()
    local ArrowComponent = ent.components.arrow
    ArrowComponent:cancel()
  end

  return State
end

return Public
