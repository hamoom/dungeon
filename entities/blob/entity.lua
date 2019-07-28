local p = require('lib.point')
local physics = require('physics')
local Public = {}
local stateList = require('entities.create-states')

function Public.new(group, x, y, player, id)

  local blob = display.newRect(group, x, y, 32, 32)

  blob.id = id
  blob.attackDistance = 170
  blob:setFillColor(0,1,0)

  physics.addBody(blob, 'dynamic', {
    bounce = 0.5,
    density = 2
  })
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

  function blob:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return blob
end



return Public
