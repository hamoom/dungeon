local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}
Public.name = 'injured'


function Public:update()


end

function Public:start(player)
  local ent = self.ent

  ent:setLinearVelocity(0, 0)

  local diff = p.newFromSubtraction(ent, player):normalize()

  ent:applyLinearImpulse(0.3 * diff.x, 0.3 * diff.y, ent.x, ent.y)

  timer.performWithDelay(2000, function()
    ent:setState('wandering')
  end, 1)
end

function Public:exit()
end

return Public
