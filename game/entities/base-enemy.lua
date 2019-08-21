local BaseEntity = require('entities.base-entity')
local stateList = require('lib.state-machine.create-states')
local Public = {}

function Public.new(obj, name, initialState, player)
  local Enemy = BaseEntity.new(obj, name, initialState, player)

  Enemy.type = 'enemy'
  Enemy.lastX, Enemy.lastY = Enemy.x, Enemy.y

  function Enemy:dropItem()
    local item = display.newRect(self.parent, self.x, self.y, 16, 16)

    item:setFillColor(1,1,0)
    item.name = self.item
    physics.addBody(item, 'dynamic', {
      bounce = 0.5,
      filter = {
        categoryBits = 2,
        maskBits = 1
      }
    })
    item.isFixedRotation = true
    item.linearDamping = 10
    local x, y = math.random(), math.random()
    item:applyLinearImpulse(x * 0.02, y * 0.02, item.x, item.y)
  end

  function Enemy:findNewCoord()
    if not self.isColliding then
      self.isColliding = true
      self.coord = nil
      timer.performWithDelay(300, function()
        self.isColliding = false
      end, 1)
    end
  end

  function Enemy:update(player)

    if player.state.name == 'death' then
      self:setState('wandering', player)
    end

    self.state:update(player)

    if not self.fixedRotation then
      self.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end
    self.lastX, self.lastY = self.x, self.y
  end

  function Enemy:destroy()
    self.state:exit()
    transition.cancel(self)
    display.remove(self)
  end

  function Enemy:bounce() end

  return Enemy
end



return Public
