local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)
  local State = {}

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 40
  State.range = 150

  local line
  function State:update(player)
    local entLocation = p.new(ent)

    if not ent.coord then
      ent:setLinearVelocity(0,0)
      ent.coord = h.findValidCoord(ent, m.map, self.range)
    else
      -- if line then display.remove(line) end

      if not self.curAngle then
        self.curAngle = p.newFromSubtraction(ent.coord, ent):angle()
      end

      local offsetAngle = p.newFromSubtraction(ent.coord, ent):angle()

      local differenceAngle = p.shortestAngleBetween(self.curAngle, offsetAngle)

      local amtToRotate = self.rotationSpeed * m.dt

      if math.abs(differenceAngle) < amtToRotate then
        amtToRotate = math.abs(differenceAngle)
      end

      amtToRotate = -h.sign(differenceAngle) * amtToRotate
      self.curAngle = self.curAngle + amtToRotate

      local direction = p.newFromAng(self.curAngle)

      -- line = display.newLine(ent.parent, ent.x, ent.y, ent.coord.x, ent.coord.y)

      ent:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)
      if entLocation:distanceTo(ent.coord) < 32 then
        ent.coord = nil
      end
    end


  end

  function State:start(player)
    ent.coord = nil
  end

  function State:exit(player)
  end


  return State
end

return Public
