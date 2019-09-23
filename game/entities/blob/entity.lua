local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local CreateSprite = require('components.graphics.create-sprite')
local Blood = require('components.graphics.blood')
local Public = {}

function Public.new(group, ogObj, player)

  local obj = display.newGroup()
  obj.x, obj.y = ogObj.x, ogObj.y
  group:insert(obj)
  obj.states = {'attacking', 'colliding', 'death', 'injured', 'stunned', 'wandering'}

  local Blob = BaseEnemy.new(obj, 'blob', 'wandering', player)

  Blob.superUpdate = Blob.update
  Blob.attackDistance = 170
  Blob.item = ogObj.item
  Blob.health = 2
  Blob.fixedRotation = true

  Blob.shadow = display.newImageRect(Blob, 'graphics/shadow.png', 28, 7)
  Blob:addComponent(CreateSprite)
  Blob:addComponent(Blood, {r = 0.435, g = 0.890, b = 0.710})

  function Blob:createPhysics()
    physics.addBody(
      self,
      'dynamic',
      {
        bounce = 0.5,
        density = 2,
        filter = {
          -- categoryBits = 2,
          -- maskBits = 1
        }
      }
    )
    self.linearDamping = 8
    self.isFixedRotation = true
  end

  function Blob:bounce()
    local diff = _G.p.newFromSubtraction(self, player):normalize()
    self:setLinearVelocity(0, 0)
    self:applyLinearImpulse(20 * diff.x, 20 * diff.y, self.x, self.y)
  end

  function Blob:update()
    self:superUpdate()

    local playerSprite = player.components.sprite:getSprite()
    local blobSprite = self.components.sprite:getSprite()

    if self.isAttacking and _G.h.hasCollided(playerSprite, self) then
      if player.health > 0 then
        self:bounce(player)
        player:setState('injured', self)
      end
    end

    self.shadow.x, self.shadow.y = blobSprite.x, blobSprite.y + 12
    self:setFacing()
  end

  Blob:createPhysics()

  return Blob
end

return Public
