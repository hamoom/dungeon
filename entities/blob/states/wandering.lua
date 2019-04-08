local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}
Public.name = 'wandering'

local coord
local velocity

function Public:findCoord(player)
  return p.new(
    h.clamp(self.ent.x + math.random(-100, 100), 64, m.map.data.width-64),
    h.clamp(self.ent.y + math.random(-100, 100), 64, m.map.data.height-64)
  )
end

function Public:update(player)
  if not coord then
    coord = self:findCoord(player)
    velocity = p.newFromSubtraction(coord, self.ent):normalized():multiply(100)
  end

  local hits = physics.rayCast(self.ent.x, self.ent.y, coord.x, coord.y, 'closest')
  if hits then coord = nil end

  if velocity and not hits then
    local vx, vy = velocity:getPosition()
    self.ent:setLinearVelocity(vx, vy)

    local distanceToCoord = p.new(self.ent):distanceTo(coord)

    if distanceToCoord < 2 then
      coord = nil
      velocity = nil
    end
  end

end

function Public:start()
end

function Public:exit()
end

return Public