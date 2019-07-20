local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}
Public.name = 'wandering'

local coord
local velocity
local speed = 100

function Public:findCoord()
  local ent = self.ent
  return p.new(
    h.clamp(ent.x + math.random(-100, 100), 64, m.map.data.width-64),
    h.clamp(ent.y + math.random(-100, 100), 64, m.map.data.height-64)
  )
end

function Public:update(player)
  local ent = self.ent

  if not coord then
    coord = self:findCoord()
    velocity = p.newFromSubtraction(coord, ent):normalized():multiply(speed)
  end

  local hits = physics.rayCast(ent.x, ent.y, coord.x, coord.y, 'closest')

  if hits then
    coord = nil
  end

  if velocity and not hits then
    local vx, vy = velocity:getPosition()
    ent:setLinearVelocity(vx, vy)

    local distanceToCoord = p.new(ent):distanceTo(coord)

    if distanceToCoord < 2 then
      coord = nil
      velocity = nil
    end
  end

  if p.new(ent):distanceTo(player) < 120 then
      ent:setState('attacking', player)
  end

end

function Public:start()
end

function Public:exit()
end

return Public
