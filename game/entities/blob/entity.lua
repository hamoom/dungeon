local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local Public = {}


function Public.new(group, ogObj, player, id)

  local stateNames = {'attacking', 'injured', 'stopped', 'wandering', 'colliding'}

  local obj = display.newRect(group, ogObj.x, ogObj.y, 32, 32)
  local Blob = BaseEnemy.new(obj, stateNames, 'blob')

  Blob.id = id
  Blob.attackDistance = 170
  Blob.item = ogObj.item
  Blob.health = 2

  Blob:setFillColor(0,1,0)

  function Blob:createPhysics()
    physics.addBody(self, 'dynamic', {
      bounce = 0.5,
      density = 2,
      filter = {
        categoryBits = 2,
        maskBits = 1
      }
    })
    self.linearDamping = 8
    self.isFixedRotation = true
  end

  function Blob:bounce(player)
    local diff = _G.p.newFromSubtraction(self, player):normalize()
    self:setLinearVelocity(0, 0)
    self:applyLinearImpulse(20 * diff.x, 20 * diff.y, self.x, self.y)
  end

  Blob:createPhysics()
  Blob:setState('wandering', player)


  return Blob
end



return Public
