local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local Public = {}


function Public.new(group, ogObj, player, id)

  local stateNames = {'wandering', 'shooting', 'injured'}

  local obj = display.newGroup()
  group:insert(obj)
  local Archer = BaseEnemy.new(obj, stateNames, 'Archer')
  Archer.x, Archer.y = ogObj.x, ogObj.y
  Archer.display = display.newRect(Archer, 0, 0, 32, 32)
  Archer.superUpdate = Archer.update
  Archer.id = id
  Archer.attackDistance = 300
  Archer.item = ogObj.item
  Archer.health = 2

  Archer.display:setFillColor(0.4,0.3,0.5)

  Archer.weapon = display.newRect(group, ogObj.x, ogObj.y, 24, 6)
  Archer.weapon.name = 'arrow'
  Archer.weapon.isAttacking = false
  Archer.weapon.isVisible = false
  Archer.weapon:setFillColor(1,1,0)

  function Archer.weapon:collisionCallBack()
    self.isVisible = false
    self.isAttacking = false
  end


  function Archer:update(player)
    self:superUpdate(player)
    -- self.weapon.x, self.weapon.y = self.display.x, self.display.y
  end

  function Archer:createArrowPhysics()
    physics.addBody(self.weapon, 'dynamic', {
      bounce = 0.5,
      density = 0.1,
      filter = {
        categoryBits = 2,
        maskBits = 1
      }
    })
    self.weapon.isFixedRotation = true
    self.weapon.isSensor = true
  end

  function Archer:createPhysics()
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

  Archer:createPhysics()
  Archer:createArrowPhysics()
  Archer:setState('wandering', player)


  return Archer
end



return Public
