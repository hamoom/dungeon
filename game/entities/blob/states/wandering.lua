local Wandering = require('lib.state-machine.common-states.wandering')
local Public = {}

function Public:new(ent)

  local State = Wandering:new(ent)
  State.superUpdate = State.update

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 80
  State.range = 100
  State.attackDistance = 130


  function State:update(player)
    State:superUpdate(player)

    local SpriteComponent = ent.components.sprite
    SpriteComponent:setFacing(nil, nil, 'wandering')

    if _G.p.new(ent):distanceTo(player) < self.attackDistance
    and player.state.name ~= 'death' then
      ent:setState('attacking', player)
    end
  end

  function State:start(player)
  end



  return State
end

return Public
