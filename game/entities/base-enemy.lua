local physics = require('physics')
local BaseEntity = require('entities.base-entity')
-- local animation = require('plugin.animation')
local Public = {}

function Public.new(obj, name, initialState, player)
  local Enemy = BaseEntity.new(obj, name, initialState, player)


  Enemy.type = 'enemy'
  Enemy.lastX, Enemy.lastY = Enemy.x, Enemy.y
  Enemy.isHittable = true

  function Enemy:dropItem()
    local item = display.newRect(self.parent, self.x, self.y, 16, 16)

    item:setFillColor(1, 1, 0)
    item.name = self.item
    physics.addBody(
      item,
      'dynamic',
      {
        bounce = 0.5,
        filter = {
          categoryBits = 2,
          maskBits = 1
        }
      }
    )
    item.isFixedRotation = true
    item.linearDamping = 10
    local x, y = math.random(), math.random()
    item:applyLinearImpulse(x * 0.02, y * 0.02, item.x, item.y)
  end

  function Enemy:findNewCoord()
    if not self.isColliding then
      self.isColliding = true
      self.coord = self.lastCoord
      timer.performWithDelay(
        500,
        function()
          self.isColliding = false
        end,
        1
      )
    end
  end

  function Enemy:update()

    if player.state.name == 'death' then
      self:setState(initialState, player)
    end

    -- if self.name == 'orc' then
    --   print(self.state.name, self.state.update)
    -- end
    self.state:update(player)

    if not self.fixedRotation then
    -- self.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end
  end

  function Enemy:destroy(player)

    self.state:exit()
    transition.cancel(self)
    physics.removeBody(self)

  end

  function Enemy:bounce()
  end

  return Enemy
end

return Public
