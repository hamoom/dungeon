local physics = require('physics')
local Public = {}
local p = require('lib.point')


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

     -- ent.blee = false
    local real_vx, real_vy = ent.x - ent.lastX, ent.y - ent.lastY
    -- if math.abs(real_vx) > 0 and math.abs(real_vy) > 0 then

    local avx, avy = math.abs(real_vx), math.abs(real_vy)
    local angle


    if avy > avx then
      if real_vy < 0 then
        angle = -180
        -- print('top')
      elseif real_vy > 0 then
        angle = 0
        -- print('bottom')
      end
    elseif avx > avy then
      if real_vx > 0 then
        angle = -90
        -- print('right')
      elseif real_vx < 0 then
        angle = 90
        -- print('left')
      end
    end

    ent.rotation = angle

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
