local m = require("myapp")

local Public = {}
Public.name = 'attacking'
Public.attackTimer = 0

function Public:update()
  local ent = self.ent

  ent.speed = ent.speed * 0.8
  ent:setLinearVelocity(ent.vx * ent.speed, ent.vy * ent.speed)

  self.attackTimer = self.attackTimer - m.dt
  if self.attackTimer <= 0 then
    ent:setState('stopped')
  end
end

function Public:start()
  local ent = self.ent


  -- ent:setLinearVelocity(0,0)

  ent.sword.active = true
  ent.sword.isVisible = true

  self.attackTimer = 0.25
end

function Public:exit()
  local ent = self.ent

  ent.sword.active = false
  ent.sword.isVisible = false
  ent.attacking = false
end


return Public
