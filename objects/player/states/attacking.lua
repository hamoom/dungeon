local m = require("myapp")

local Public = {}
Public.name = 'attacking'
Public.attackTimer = 0

function Public:update()

  self.obj.vx = 0
  self.obj.vy = 0

  self.attackTimer = self.attackTimer - m.dt
  if self.attackTimer <= 0 then
    self.obj:setState('stopped')
  end
end

function Public:start()
  self.attackTimer = 2


  self.obj.sword.active = true
  self.obj.sword.isVisible = true

end

function Public:exit()
  self.obj.sword.active = false
  self.obj.sword.isVisible = false
  self.obj.attacking = false
end


return Public