local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}
Public.name = 'attacking'

local impulseSpeed = 100
function Public:update(player)
  local ent = self.ent
  -- ent:setLinearVelocity(0, 0)
end

function Public:start(player)
  local ent = self.ent

  ent:setLinearVelocity(0, 0)

  local diff
  timer.performWithDelay(1500, function()
    diff = p.newFromSubtraction(player, ent):normalize()
  end, 1)


  self.attackTimer = timer.performWithDelay(2000, function()
    ent.isAttacking = true
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    timer.performWithDelay(500, function()
      ent:setState('wandering')
    end, 1)

  end, 1)

end

function Public:exit()

  local ent = self.ent
  ent.isAttacking = false
  timer.cancel(self.attackTimer)
end

return Public
