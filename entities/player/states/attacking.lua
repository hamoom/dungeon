local m = require("myapp")

local Public = {}

function Public:new(ent)
  local State = {}

  State.attackTimer = 0

  function State:update()

    ent.speed = ent.speed * 0.8
    ent:setLinearVelocity(ent.vx * ent.speed, ent.vy * ent.speed)

    self.attackTimer = self.attackTimer - m.dt
    if self.attackTimer <= 0 then
      ent:setState('stopped')
    end
  end

  function State:start()
    ent.sword.active = true
    ent.sword.isVisible = true

    self.attackTimer = 0.25
  end

  function State:exit()

    ent.sword.active = false
    ent.sword.isVisible = false
    ent.attacking = false
  end


  return State
end



return Public
