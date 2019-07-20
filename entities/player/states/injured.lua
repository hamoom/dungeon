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

  -- ent:applyLinearImpulse(0.2 * diff.x, 0.2 * diff.y, ent.x, ent.y)
  timer.performWithDelay(500, function()
    ent:setState('stopped')
  end, 1)
end

function Public:exit()
  local ent = self.ent

  ent.attacking = false
end

return Public
