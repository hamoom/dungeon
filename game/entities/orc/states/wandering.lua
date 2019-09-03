local Wandering = require('lib.state-machine.common-states.wandering')
local Public = {}

function Public:new(ent)
  local State = Wandering:new(ent)
  State.superUpdate = State.update
  State.superStart = State.start

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 60
  State.range = 130
  State.chaseDistance = 30

  function State:update(player)
    self:superUpdate(player)

    local spriteComponent = ent.components.sprite

    spriteComponent:setFacing(
      'running-f',
      'running-b',
      'running-s'
    )

    if _G.p.new(ent):distanceTo(player) < self.chaseDistance
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
