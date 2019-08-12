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


    ent.sprite.xScale = 1
    if ent.facing == 'bottom' then
      ent:setAnim('running-f')
    elseif ent.facing == 'top' then
      ent:setAnim('running-b')
    elseif ent.facing == 'right' or ent.facing == 'left' then

      local vx, _ = ent:getLinearVelocity()
      ent:setAnim('running-s')
      if vx > 0 then
        ent.sprite.xScale = 1
      else
        ent.sprite.xScale = -1
      end
    end



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
