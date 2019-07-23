local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}


function Public:new(ent)

  local State = {}
  State.name = 'attacking'
  State.initialTime = 1
  State.flashTime = 1

  local impulseSpeed = 100

  function State:update(player)

  end

  function State:start(player)

    ent.isAttacking = false
    ent.isLit = false
    ent:setLinearVelocity(0, 0)

    local totalTime = 500

    local diff

    local function flash()

      totalTime = totalTime * 0.8

      if totalTime < 100 and not diff then
        diff = p.newFromSubtraction(player, ent):normalize()
      end

      if totalTime < 5 then totalTime = 0 end

      if totalTime > 0 then

        ent.isLit = not ent.isLit
        if ent.isLit then
          ent:setFillColor(1,1,0)
        else
          ent:setFillColor(0,1,0)
        end
        self.attackTimer = timer.performWithDelay(totalTime, flash, 1)
      else
        ent.isAttacking = true
        ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

        timer.performWithDelay(500, function()
          ent:setState('stopped', player)
        end, 1)
      end

    end


    flash()

  end

  function State:exit()
    timer.cancel(self.attackTimer)
    ent:setFillColor(0,1,0)
    ent.isLit = false
    ent.isAttacking = false
  end

  return State
end


return Public
