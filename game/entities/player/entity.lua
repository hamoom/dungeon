local physics = require('physics')
local Public = {}

local BaseEntity = require('entities.base-entity')

local DashEffect = require('components.effects.dash')
local CreateSprite = require('components.graphics.create-sprite')
local Blood = require('components.graphics.blood')
local Weapon = require('components.items.weapon')


function Public.new(group, x, y)
  local obj = display.newGroup()
  obj.x, obj.y = x, y
  local Player = BaseEntity.new(obj, 'player', 'stopped')
  group:insert(Player)
  Player:toFront()

  Player.shadow = display.newImageRect(Player, 'graphics/shadow.png', 28, 7)

  Player:addComponent(CreateSprite)
  Player:addComponent(
    DashEffect,
    group,
    Player.components.sprite:getSprite()
  )
  Player:addComponent(Weapon, 56, 32)
  Player:addComponent(Blood)

  Player.item = nil
  Player.facing = 'bottom'
  Player.speed = 0
  Player.maxSpeed = 150
  Player.x, Player.y = x, y
  Player.lastX, Player.lastY = x, y

  Player.vx, Player.vy = 0, 0
  Player.lastVx, Player.lastVy = 0, 0

  Player.health = 3

  physics.addBody(Player, 'dynamic', {
    bounce = 0.5,
    radius = 14,
  })
  Player.isFixedRotation = false
  Player.linearDamping = 16

  -----------------------------
  -- METHODS
  -----------------------------

  function Player:attack()
    if self.state.name ~= 'injured' then self:setState('attacking') end
  end

  function Player:dash()
    if self.state.name == 'running' then
      self:setState('dashing')
    end
  end

  function Player:update(vx, vy)
    local sprite = self.components.sprite:getSprite()
    local weaponGroup = self.components.weapon:getGroup()
    local weapon = self.components.weapon:getHitBox()

    self.vx, self.vy = vx, vy

    self.state:update()

    if not self.fixedRotation then
      weaponGroup.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end
    weapon.x, weapon.y = sprite.x, sprite.y + self.height/4

    local newFacing = _G.h.getFacing(self.x, self.lastX, self.y, self.lastY)
    if newFacing then self.facing = newFacing end

    self.shadow.x, self.shadow.y = sprite.x, sprite.y + 10

    self.lastX, self.lastY = self.x, self.y
  end

  function Player:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return Player

end

return Public
