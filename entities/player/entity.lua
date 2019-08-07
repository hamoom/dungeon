local physics = require('physics')
local Public = {}
local stateList = require('lib.state-machine.create-states')

function Public.new(group, x, y)
  local Player = display.newGroup()
  group:insert(Player)

  Player.display = display.newRect(Player, 0, 0, 32, 32)
  Player.dirInd = display.newRect(Player, 0, 0, 10, 10)
  Player.dirInd:setFillColor(0,1,1)

  Player.name = 'player'
  Player.item = nil
  Player.speed = 0
  Player.maxSpeed = 150
  Player.x, Player.y = x, y
  Player.lastX, Player.lastY = x, y

  Player.vx, Player.vy = 0, 0
  Player.lastVx, Player.lastVy = 0, 0

  Player.health = 3

  physics.addBody(Player, 'dynamic', {
    bounce = 1,
    radius = 14
  })
  Player.isFixedRotation = false
  Player.linearDamping = 8

  Player.sword = display.newRect(Player, 0, 0, 56, 32)
  Player.sword.active = false
  Player.sword.isVisible = false
  Player.sword:setFillColor(1,0,0)

  local stateNames = {'attacking', 'injured', 'running', 'stopped', 'dashing'}
  local states = stateList.new(Player, stateNames)
  Player.state = states:getState('stopped')

  -----------------------------
  -- METHODS
  -----------------------------

  function Player:setState(state, enemy)
    local newState = states:getState(state)

    if self.state.name ~= newState.name then
      local prevStateName = self.state.name
      newState.prevStateName = prevStateName
      self.state:exit(newState)
      newState:start(enemy)
      self.state = newState
    end
  end

  function Player:attack()
    if self.state.name ~= 'injured' then self:setState('attacking') end
  end

  function Player:dash()
    if self.state.name ~= 'injured' and self.state.name ~= 'attacking' then self:setState('dashing') end
  end

  function Player:update(vx, vy)
    self.vx, self.vy = vx, vy

    self.state:update()

    if not self.fixedRotation then
      self.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)

    end

    self.sword.x, self.sword.y = self.display.x, self.display.y + self.height/4
    self.dirInd.x, self.dirInd.y = self.display.x, self.display.y + self.height/4
    self.lastX, self.lastY = self.x, self.y
  end

  function Player:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return Player

end

return Public
