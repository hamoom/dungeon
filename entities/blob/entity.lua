local p = require('lib.point')
local physics = require('physics')
local Public = {}
local blob
local stateList = require('entities.blob.states.list')
local states


function Public.new(group, x, y)

  local blob = display.newCircle(group, x, x, 16)
  blob:setFillColor(0,1,0)

  physics.addBody(blob, 'dynamic', {
    bounce = 0
  })
  blob.isFixedRotation = true


  function blob:setState(state)
    local newState = states:getState(state)
    if blob.state.name ~= newState.name then
      blob.state:exit(newState)
      newState:start()
      blob.state = newState
    end
  end

  function blob:update(player)
    self.state:update(player)
  end

  states = stateList.new(blob)
  blob.state = states:getState('wandering')
  return blob
end



return Public