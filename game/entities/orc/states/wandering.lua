local Wandering = require('lib.state-machine.common-states.wandering')
local Public = {}

function Public:new(ent)
  local State = Wandering:new(ent)
  State.superUpdate = State.update
  State.superStart = State.start

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 40
  State.range = 150

  function State:update(player)
    self:superUpdate(player)
    if _G.p.new(ent):distanceTo(player) < ent.chaseDistance
    and player.state.name ~= 'death' then
      ent:setState('chasing', player)
    end
  end

  -- function State:start(player)
  --   self:superStart(play)
  --   local spriteComponent = ent.components.sprite
  --   spriteComponent:setAnim('running-f')
  -- end

  return State
end

return Public
