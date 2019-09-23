local physics = require('physics')
local BaseEnemy = require('entities.base-enemy')

local Blood = require('components.graphics.blood')
local Weapon = require('components.items.weapon')
local CreateSprite = require('components.graphics.create-sprite')
local Public = {}

function Public.new(group, ogObj, player)
  local obj = display.newGroup()
  obj.x, obj.y = ogObj.x, ogObj.y
  group:insert(obj)
  obj.states = {'attacking', 'blocking', 'chasing', 'death', 'injured', 'struck', 'stunned', 'wandering'}

  local Orc = BaseEnemy.new(obj, 'orc', 'wandering', player)
  Orc.display = display.newRect(Orc, 0, 0, 32, 32)
  Orc.display.isVisible = false
  Orc.superUpdate = Orc.update

  Orc.item = ogObj.item
  Orc.health = 2
  Orc.fixedRotation = true
  Orc.facing = 'bottom'

  Orc.attackDistance = 40
  Orc.shadow = display.newImageRect(_G.m.map.layer['ground'], 'graphics/shadow.png', 28, 7)

  Orc:addComponent(Weapon, 56, 48)
  Orc:addComponent(Blood)
  Orc:addComponent(CreateSprite)

  Orc.display:setFillColor(0.4, 0.3, 0)

  function Orc:createPhysics()
    physics.addBody(
      self,
      'dynamic',
      {
        bounce = 0.5,
        density = 2,
        radius = 14,
        filter = {
          -- categoryBits = 2,
          -- maskBits = 1
        }
      }
    )
    self.linearDamping = 8
    self.isFixedRotation = true
  end

  function Orc:update()
    self:superUpdate()

    self.shadow.x, self.shadow.y = self.x, self.y + 12

    local sprite = self.components.sprite:getSprite()
    local playerSprite = player.components.sprite:getSprite()
    local WeaponComponent = self.components.weapon
    local weapon = WeaponComponent:getHitBox()

    if weapon.isAttacking and _G.h.hasCollided(playerSprite, weapon) then
      if player.health > 0 then
        player:setState('injured', weapon)
      end
    end


    WeaponComponent:updateWeaponDir(sprite, self.facing)
    self:setFacing()
  end

  Orc:createPhysics()
  return Orc
end

return Public
