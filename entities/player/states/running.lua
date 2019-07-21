local physics = require('physics')
local Public = {}
local p = require('lib.point')
Public.name = 'running'


function getMagnitudeInRect(angle, width, height)

    local abs_cos_angle = math.abs(math.cos(angle))
    local  abs_sin_angle = math.abs(math.sin(angle))

    local magnitude = 0

    if width/2 * abs_sin_angle <= height/2 * abs_cos_angle then
        magnitude = width / 2 / abs_cos_angle
    else
        magnitude = height / 2 / abs_sin_angle
    end

    return magnitude
end

function Public:update(blob)

  local ent = self.ent
  if ent.speed <= 30 then
    ent.speed = 30
  end

  ent.speed = ent.speed * 1.1
  if ent.speed > ent.maxSpeed then ent.speed = ent.maxSpeed end


  ent:setLinearVelocity(
    ent.vx * ent.speed,
    ent.vy * ent.speed
  )

  -- ent.

  -- local liney = display.newLine(ent.parent, ent.x, ent.y, ent.x + ent.vx*17, ent.y + ent.vy*17)
  -- liney:setStroke(1,0,0)
  -- local hits = physics.rayCast(ent.x, ent.y, ent.x + ent.vx*17, ent.y + ent.vy*17, 'closest')

  -- if hits then ent:setLinearVelocity(0,0) end


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

function Public:start()
end

function Public:exit()
  local ent = self.ent
  ent.lastVx = ent.vx
  ent.lastVy = ent.vy
end

return Public
