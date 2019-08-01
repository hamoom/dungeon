
local p = require('lib.point')
local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local Public = {}


function Public.new(group, ogObj, player, id)

  local stateNames = {'wandering', 'chasing', 'blocking', 'attacking', 'injured'}

  local obj = display.newGroup()
  group:insert(obj)
  local Orc = BaseEnemy.new(obj, stateNames, 'orc')
  Orc.x, Orc.y = ogObj.x, ogObj.y
  Orc.display = display.newRect(Orc, 0, 0, 32, 32)
  Orc.superUpdate = Orc.update
  Orc.id = id
  Orc.attackDistance = 170
  Orc.item = ogObj.item
  Orc.health = 2


  Orc.attackDistance = 40
  Orc.weapon = display.newRect(Orc, 0, 0, 56, 32)
  Orc.weapon.active = false
  Orc.weapon.isVisible = false
  Orc.weapon:setFillColor(1,1,0)

  Orc.display:setFillColor(0,1,0)



  function Orc:update(player)
    self:superUpdate(player)
    self.weapon.x, self.weapon.y = self.display.x, self.display.y + self.height/4
  end

  function Orc:createPhysics()
    physics.addBody(self, 'dynamic', {
      bounce = 0.5,
      density = 2,
      radius = 14,
      filter = {
        categoryBits = 2,
        maskBits = 1
      }
    })
    self.linearDamping = 8
    self.isFixedRotation = true
  end

  Orc:createPhysics()
  Orc:setState('wandering', player)



  return Orc
end



return Public
