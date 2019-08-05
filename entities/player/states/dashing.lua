local m = require("myapp")

local Public = {}

function Public:new(ent)
  local State = {}


  function State:update()
    local dash = ent.maxSpeed * 9
    ent:setLinearVelocity(self.lockedVx * dash, self.lockedVy * dash)

    self.dashTimer = self.dashTimer - m.dt
    if self.dashTimer <= 0 then ent:setState('running') end

  end

  function State:start()
    self.lockedVx, self.lockedVy = ent.vx, ent.vy
    self.dashTimer = 0.08
  end

  function State:exit()
  end


  return State
end



return Public
