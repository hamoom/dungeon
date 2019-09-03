local physics = require('physics')
local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()

    if ent.speed <= 30 then
      ent.speed = 30
    end

    ent.speed = ent.speed * 1.1
    if ent.speed > ent.maxSpeed then ent.speed = ent.maxSpeed end


    ent:setLinearVelocity(
      ent.vx * ent.speed,
      ent.vy * ent.speed
    )

    local SpriteComponent = ent.components.sprite

    SpriteComponent:setFacing(
      'running-f',
      'running-b',
      'running-s'
    )

    if ent.attacking then ent:setState('attacking') end
  end


  function State:start()
  end

  function State:exit()
    ent.lastVx = ent.vx
    ent.lastVy = ent.vy
  end


  return State
end




return Public
