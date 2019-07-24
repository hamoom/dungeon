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
    if not self.firstRun then self.firstRun = math.random(2000, 4000) end
    local timeLimit = self.firstRun or 2000
    self.timer = timer.performWithDelay(timeLimit, function()
      ent:setState('attacking', player)
    end, 1)
  end

  function State:exit(player)
    timer.cancel(self.timer)
  end


  return State
end

return Public
