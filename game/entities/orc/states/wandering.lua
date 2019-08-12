local Wandering = require('lib.state-machine.common-states.wandering')
local Public = {}

function Public:new(ent)
  local State = Wandering:new(ent)
  State.superUpdate = State.update

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 40
  State.range = 150

  function State:update(player)
    self:superUpdate(player)
    if _G.p.new(ent):distanceTo(player) < ent.chaseDistance then
      ent:setState('chasing', player)
    end
  end

  return State
end

return Public
