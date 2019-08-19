local Public = {}

function Public:new(ent)
  local State = {}


  function State:update()
    local dash = ent.maxSpeed * 9
    ent:setLinearVelocity(self.lockedVx * dash, self.lockedVy * dash)

    self.dashTimer = self.dashTimer - _G.m.dt
    if self.dashTimer <= 0 then ent:setState('running') end

  end

  function State:start()
    local time = 15
    for _, v in pairs(ent.dashSprites) do
      v:cancelChase()
      v.x, v.y = ent.x, ent.y
      v.xScale = ent.sprite.xScale
      _G.m.addTimer(time, function()

        v.isVisible = true
        v:setSequence(ent.sprite.sequence)
        v:play()
        v:chasePlayer()
      end)
      time = time * 1.15
    end

    self.lockedVx, self.lockedVy = ent.vx, ent.vy
    self.dashTimer = 0.08
  end

  function State:exit()
  end

  return State
end



return Public
