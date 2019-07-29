local p = require('lib.point')
local physics = require('physics')
local Public = {}
local stateList = require('entities.create-states')

function Public.new(group, x, y)
  local player = display.newGroup()
  group:insert(player)

  player.display = display.newRect(player, 0, 0, 32, 32)
  player.dirInd = display.newRect(player, 0, 0, 10, 10)
  player.dirInd:setFillColor(0,1,1)

  player.name = 'player'
  player.speed = 0
  player.maxSpeed = 150
  player.x, player.y = x, y
  player.lastX, player.lastY = x, y

  player.vx, player.vy = 0, 0
  player.lastVx, player.lastVy = 0, 0
  player.attacking = false

  player.health = 3

  physics.addBody(player, 'dynamic', {
    bounce = 1,
    radius = 14,
    filter = {
      -- categoryBits = 1,
      -- maskBits = 2
    }
  })
  player.isFixedRotation = true
  player.linearDamping = 8

  player.sword = display.newRect(player, 0, 0, 56, 32)
  player.sword.active = false
  player.sword.isVisible = false
  player.sword:setFillColor(1,0,0)

  local stateNames = {'attacking', 'injured', 'running', 'stopped'}
  local states = stateList.new(player, stateNames)
  player.state = states:getState('stopped')

  -----------------------------
  -- METHODS
  -----------------------------

  function player:setState(state, enemy)
    local newState = states:getState(state)

    if player.state.name ~= newState.name then
      player.state:exit(newState)
      newState:start(enemy)
      player.state = newState
    end
  end

  function player:update(vx, vy)
    player.vx, player.vy = vx, vy

    self.state:update()

    player.sword.x, player.sword.y = player.display.x, player.display.y + player.height/4
    player.dirInd.x, player.dirInd.y = player.display.x, player.display.y + player.height/4
    player.lastX, player.lastY = player.x, player.y
  end

  function player:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return player

end

return Public
