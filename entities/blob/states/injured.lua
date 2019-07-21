local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}
Public.name = 'injured'

local impulseSpeed = 100
function Public:update()


end

function Public:start(player)



  local ent = self.ent
  ent.alpha = 0.3

  ent:setLinearVelocity(0, 0)

  local diff = p.newFromSubtraction(ent, player):normalize()

  ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

  timer.performWithDelay(1000, function()
    ent:setState('attacking', player)
  end, 1)
end

function Public:exit()
  local ent = self.ent
  ent.alpha = 1
end

return Public
