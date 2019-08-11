local physics = require('physics')
local Public = {}
local stateList = require('lib.state-machine.create-states')

function Public.new(group, x, y)
  local Player = display.newGroup()
  group:insert(Player)


  local sequenceData = {
    { name='stopped-f', frames={1,2,1,2,1,2,3}, time=2000 },
    { name='stopped-b', frames={4,5}, time=1000 },
    { name='stopped-s', frames={12,13}, time=1000 },
    { name='running-f', frames={9,10,11}, time=300 },
    { name='running-b', frames={6,7,8}, time=300 },
    { name='running-s', frames={14,15,16}, time=300 },
  }


  local sheetInfo = require("sprites.player")
  local myImageSheet = graphics.newImageSheet("sprites/player.png", sheetInfo:getSheet())
  Player.sprite = display.newSprite(myImageSheet, sequenceData)
  Player:insert(Player.sprite)
  Player.sprite:play()



  -- Player.sprite = display.newRect(Player, 0, 0, 32, 32)
  Player.dirInd = display.newRect(Player, 0, 0, 10, 10)
  Player.dirInd:setFillColor(0,1,1)
  Player.dirInd.isVisible = false

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

  function Player:setAnim(sequence)
      local sprite = self.sprite and self.sprite or self
      if sprite.sequence ~= sequence then

          sprite:setSequence(sequence)
          sprite:play()
          sprite.sequence = sequence
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
      self.facing = _G.h.getFacing(self.x, self.lastX, self.y, self.lastY) or 'bottom'
      -- self.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end


    self.sword.x, self.sword.y = self.sprite.x, self.sprite.y + self.height/4
    self.dirInd.x, self.dirInd.y = self.sprite.x, self.sprite.y + self.height/4
    self.lastX, self.lastY = self.x, self.y
  end

  function Player:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return Player

end

return Public
