local Public = {}
local stateList = require('lib.state-machine.create-states')

function Public.new(ent, name, initialState, otherEnt)
  ent.components = {}
  ent.name = name

  local states = stateList.new(ent, name)

  function ent:addComponent(component, ...)
    self.components[component.name] = component.new(self, arg)
  end

  function ent:setState(state, obj)
    local newState = states:getState(state)


    if self.state.name ~= newState.name then
      local prevStateName = self.state.name
      newState.prevStateName = prevStateName
      self.state:exit(newState)
      newState:start(obj)
      self.state = newState

    end
  end

  function ent:setFacing()
    local newFacing = _G.h.getFacing(self.x, self.lastX, self.y, self.lastY)
    if newFacing then self.facing = newFacing end
    self.lastX, self.lastY = self.x, self.y
  end

  ent.state = states:getState(initialState, otherEnt)

  return ent
end

return Public
