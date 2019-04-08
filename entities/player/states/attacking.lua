local m = require("myapp")

local Public = {}
Public.name = 'attacking'
Public.attackTimer = 0

function Public:update()

  self.ent.vx = 0
  self.ent.vy = 0

  self.attackTimer = self.attackTimer - m.dt
  if self.attackTimer <= 0 then
    self.ent:setState('stopped')
  end
end

function Public:start()
  self.attackTimer = 2


  self.ent.sword.active = true
  self.ent.sword.isVisible = true

end

function Public:exit()
  self.ent.sword.active = false
  self.ent.sword.isVisible = false
  self.ent.attacking = false
end


return Public