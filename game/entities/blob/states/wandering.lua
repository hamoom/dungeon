local Wandering = require('lib.state-machine.common-states.wandering')
local Public = {}

function Public:new(ent)

  local State = Wandering:new(ent)
  State.superUpdate = State.update

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 80
  State.range = 300


  function State:update(player)
    State:superUpdate(player)
    if _G.p.new(ent):distanceTo(player) < ent.attackDistance
    and player.state.name ~= 'death' then
      ent:setState('attacking', player)
    end
  end



  return State
end

return Public
