local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    local dash = ent.maxSpeed * 9
    ent:setLinearVelocity(self.lockedVx * dash, self.lockedVy * dash)

    self.dashTimer = self.dashTimer - _G.m.dt
    if self.dashTimer <= 0 then
      ent:setState('running')
    end
  end

  function State:start()
    local dashEffect = ent.components.dashEffect
    dashEffect:chase()
    self.lockedVx, self.lockedVy = ent.vx, ent.vy
    self.dashTimer = 0.08
  end

  function State:exit()
  end

  return State
end

return Public
