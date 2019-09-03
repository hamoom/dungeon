local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')
local Arrow = require('components.items.arrow')
local Blood = require('components.graphics.blood')

local Public = {}


function Public.new(group, ogObj, player)

  local obj = display.newGroup()
  group:insert(obj)
  local Archer = BaseEnemy.new(obj, 'archer', 'wandering', player)
  Archer.x, Archer.y = ogObj.x, ogObj.y
  Archer.display = display.newRect(Archer, 0, 0, 32, 32)
  Archer.superUpdate = Archer.update

  Archer.attackDistance = 300
  Archer.item = ogObj.item
  Archer.health = 2

  Archer.display:setFillColor(0.4,0.3,0.5)

  Archer:addComponent(Arrow, Archer, group)
  Archer:addComponent(Blood)

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
    self.linearDamping = 14
    self.isFixedRotation = true
  end

  function Archer:update(player)
    local arrowComponent = self.components.arrow
    local playerSprite = player.components.sprite:getSprite()

    self:superUpdate(player)

    if arrowComponent.isAttacking
    and _G.h.hasCollided(playerSprite, arrowComponent) then
      if player.health > 0 then
        player:setState('injured', arrowComponent)
      end
      arrowComponent:collisionCallBack()
    end

    self:setFacing()
  end

  Archer:createPhysics()

  return Archer
end



return Public
