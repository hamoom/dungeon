
local p = require('lib.point')
local physics = require('physics')
local Public = {}
local stateList = require('entities.create-states')

function Public.new(group, ogObj, player, id)

  local blob = display.newRect(group, ogObj.x, ogObj.y, 32, 32)

  blob.id = id
  blob.attackDistance = 170
  blob.item = ogObj.item
  blob:setFillColor(0,1,0)

  physics.addBody(blob, 'dynamic', {
    bounce = 0.5,
    density = 2,
    filter = {
      categoryBits = 2,
      maskBits = 1
    }
  })
  blob.health = 2
  blob.name = 'blob'
  blob.linearDamping = 8
  blob.isFixedRotation = true
  blob.running = false

  local stateNames = {'attacking', 'injured', 'stopped', 'wandering', 'colliding'}
  local states = stateList.new(blob, stateNames)
  blob.state = states:getState('wandering')
  blob.state:start(player)

  function blob:setState(state, player)
    local newState = states:getState(state)

    if blob.state.name ~= newState.name then
      blob.state:exit(newState)
      newState:start(player)
      blob.state = newState
    end
  end

  function blob:update(player)
    self.state:update(player)
  end

  function blob:dropItem()
    local item = display.newRect(group, self.x, self.y, 16, 16)

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

  function blob:destroy()
    self.state:exit()
    transition.cancel(self)
    display.remove(self)
  end

  return blob
end



return Public
