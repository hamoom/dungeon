local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)
  local State = {}
  State.name = 'stopped'

  function State:update(player)

  end

  function State:start(player)
    self.timer = timer.performWithDelay(1000, function()
      if p.new(ent):distanceTo(player) < ent.attackDistance then
        ent:setState('attacking', player)
      else
        ent:setState('wandering', player)
      end
    end, 1)
  end

  function State:exit(player)
    timer.cancel(self.timer)
  end


  return State
end

return Public
