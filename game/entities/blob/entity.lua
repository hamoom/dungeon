local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local Public = {}


function Public.new(group, ogObj, player)

  local obj = display.newRect(group, ogObj.x, ogObj.y, 32, 32)
  local Blob = BaseEnemy.new(obj, 'blob', 'wandering', player)
  Blob.superUpdate = Blob.update
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

  function Blob:update(player)
    self:superUpdate(player)
    local playerSprite = player.components.sprite:getSprite()

    if self.isAttacking and _G.h.hasCollided(playerSprite, self) then
      if player.health > 0 then
				self:bounce(player)
				player:setState('injured', self)
			end
    end
  end

  Blob:createPhysics()

  return Blob
end



return Public
