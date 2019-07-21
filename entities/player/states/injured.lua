local p = require('lib.point')
local Public = {}
Public.name = 'injured'

function Public:update()

  local ent = self.ent
end

function Public:start(enemy)
  local ent = self.ent
  ent.speed = 0
  local diff = p.newFromSubtraction(ent, enemy):normalize()
  -- local diff = {x = math.random(), y = math.random()}

  -- ent:setLinearVelocity(0,0)
  ent:applyLinearImpulse(0.6 * diff.x, 0.6  * diff.y, ent.x, ent.y)
  ent.alpha = 0.3
  timer.performWithDelay(500, function()
    ent.alpha = 1
    ent:setState('stopped')
  end, 1)
end

function Public:exit()
  local ent = self.ent
  ent.attacking = false
end

return Public
