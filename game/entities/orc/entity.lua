local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')

local Weapon = require('components.items.weapon')

local Public = {}

function Public.new(group, ogObj, player)

  local obj = display.newGroup()
  group:insert(obj)
  local Orc = BaseEnemy.new(obj, 'orc', 'wandering', player)
  Orc.x, Orc.y = ogObj.x, ogObj.y
  Orc.display = display.newRect(Orc, 0, 0, 32, 32)
  Orc.superUpdate = Orc.update
  Orc.chaseDistance = 170
  Orc.item = ogObj.item
  Orc.health = 2

  Orc.attackDistance = 40
  Orc:addComponent(Weapon, 56, 48)

  Orc.display:setFillColor(0.4,0.3,0)

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

  function Orc:update(player)
    self:superUpdate(player)

    local playerSprite = player.components.sprite:getSprite()
    local weaponGroup = self.components.weapon:getGroup()
    local weapon = self.components.weapon:getHitBox()
    weaponGroup.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    weapon.x, weapon.y = self.display.x, self.display.y + self.height/4

    if weapon.isAttacking and _G.h.hasCollided(playerSprite, weapon) then
      if player.health > 0 then
				player:setState('injured', weapon)
			end
    end
  end

  Orc:createPhysics()
  return Orc
end



return Public
