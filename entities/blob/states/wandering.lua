local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local Public = {}

function Public:new(ent)

  local State = {}
  State.name = 'wandering'

  State.curAngle = nil
  State.rotationSpeed = 200
  State.speed = 50

  local line
  local function findValidCoord()

    local range = 300
    local randomPt = p.new(
      ent.x + math.random(-range, range),
      ent.y + math.random(-range, range)
    )

    local indices = {7,1,3,5,0,2,6,8}
    local validTile = true
    for i=1, #indices do
      local tileIndex = indices[i]

      local coorx, coory = m.map.pixelsToTiles(randomPt.x, randomPt.y)

      local tileCol = math.floor(tileIndex % 3)
      local tileRow = math.floor(tileIndex / 3)

      local tileCoord = {
        x = coorx + (tileCol - 1),
        y = coory + (tileRow - 1)
      }

      local tile = m.map.layer["ground"].tile(tileCoord.x, tileCoord.y)
      if validTile and tile then
        validTile = tile.gid ~= 51
        -- print(validTile)
      end
    end

    local hits = physics.rayCast(ent.x, ent.y, randomPt.x, randomPt.y, 'closest')
    -- line = display.newLine(m.map.layer['ground'], ent.x, ent.y, randomPt.x, randomPt.y)

    local clearPath = not hits
    if not validTile and not clearPath then
      display.remove( line )
    end

    return (validTile and clearPath) and randomPt or nil
  end

  function State:update(player)
    local entLocation = p.new(ent)

    if not ent.coord then
      ent:setLinearVelocity(0,0)
      ent.coord = findValidCoord()
    else

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

      -- local direction = p.newFromSubtraction(ent.coord, ent):normalize()

      ent:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)
      if entLocation:distanceTo(ent.coord) < 32 then
        ent.coord = findValidCoord()
      end
    end

    if entLocation:distanceTo(player) < ent.attackDistance then
      ent:setState('attacking', player)
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
