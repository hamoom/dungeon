local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()
  end

  function State:start(player)


    local impulseSpeed = 25
    local diff = p.newFromSubtraction(ent, player):normalize()

    ent:setLinearVelocity(0, 0)
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    ent.alpha = self.prevStateName == 'blocking' and 1 or 0.3

    m.addTimer(600, function()

      if self.prevStateName == 'blocking' then
        ent:setState('attacking', player)
      else
        ent.health = ent.health - 1

        if ent.health > 0 then
          ent:setState('chasing', player)
        elseif ent.health <= 0 and ent.item then
          ent:dropItem()
        end
      end

    end)

  end

  function State:exit()
    ent.alpha = 1
  end


  return State
end

return Public
