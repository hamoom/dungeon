local physics = require('physics')
local Public = {}
local player
local stateList = require('objects.player.states.list')
local states

function Public.new(group, x, y)
  local player = display.newRect(group, x, y, 32, 32)

  physics.addBody(player, "dynamic", {
    bounce = 0
  })
  player.isFixedRotation = true

  function player:setState(state)
    player.state = states:getState(state)
  end

  function player:update(vx, vy)
    player.vx, player.vy = vx, vy
    self.state:update()
    self:setLinearVelocity(vx, vy)
  end


  states = stateList.new(player)
  player:setState('stopped')

  return player

end

return Public



