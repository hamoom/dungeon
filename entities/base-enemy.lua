local h = require('lib.helper')
local stateList = require('lib.state-machine.create-states')
local Public = {}

function Public.new(obj, stateNames, name)
  local Enemy = obj
  Enemy.name = name
  Enemy.type = 'enemy'
  Enemy.state = {
    name = 'blank',
    exit = function() end
  }
  Enemy.lastX, Enemy.lastY = Enemy.x, Enemy.y

  local states = stateList.new(Enemy, stateNames, 'enemies')

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


  function Enemy:setState(state, player)
    local newState = states:getState(state)

    if self.state.name ~= newState.name then
      local prevStateName = self.state.name
      newState.prevStateName = prevStateName
      self.state:exit(newState)
      newState:start(player)
      self.state = newState
    end
  end

  function Enemy:update(player)
    self.state:update(player)

    if not self.fixedRotation then
      self.rotation = h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end
    self.lastX, self.lastY = self.x, self.y
  end

  function Enemy:destroy()
    self.state:exit()
    transition.cancel(self)
    display.remove(self)
  end

  return Enemy
end



return Public
