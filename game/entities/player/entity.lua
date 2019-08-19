local physics = require('physics')
local Public = {}
local stateList = require('lib.state-machine.create-states')

function Public.new(group, x, y)
  local Player = display.newGroup()
  group:insert(Player)

  local sheetInfo = require('sprites.player')
  local myImageSheet = graphics.newImageSheet('sprites/player.png', sheetInfo:getSheet())
  local sequenceData = {
    { name='stopped-f', frames={ 1,2,1,2,1,2,3 }, time=2000 },
    { name='stopped-b', frames={ 4,5 }, time=1000 },
    { name='stopped-s', frames={ 12,13 }, time=1000 },
    { name='running-f', frames={ 9,10,11 }, time=300 },
    { name='running-b', frames={ 6,7,8 }, time=300 },
    { name='running-s', frames={ 14,15,16 }, time=300 },
    { name='attacking-f', frames={ 17,18,19,20,21 }, time=300, loopCount=1 },
    { name='attacking-s', frames={ 22,23,24 }, time=200, loopCount=1 },
    { name='attacking-a', frames={ 25,26,27,28 }, time=250, loopCount=1 },
    { name='injured-f', frames={ 29 }, time=250, loopCount=1 },
  }

  Player.dashSprites = {}
  for i = 1, 10 do
    local thisSprite = display.newSprite(myImageSheet, sequenceData)
    group:insert(thisSprite)
    thisSprite.isVisible = false
    thisSprite.alpha = 0.3
    thisSprite.cancelChase = function(self)
      self.isVisible = false
      _G.m.eachFrameRemove(self.animFunc)
    end

    thisSprite.chasePlayer = function(self)
      self.animFunc = function()
        if p.new(self):distanceTo(Player) > 10 then
          local velocity = p.new(Player)
            :subtract(self)
            :normalize()
            :multiply(15)

          self.x, self.y = self.x + velocity.x, self.y + velocity.y
        else
          self:cancelChase()
        end
      end
      _G.m.addTimer(100, function()
        _G.m.eachFrame(self.animFunc)
      end)

    end
    Player.dashSprites[#Player.dashSprites + 1] = thisSprite
  end

  Player.shadow = display.newImageRect(Player, 'graphics/shadow.png', 28, 7)

  Player.sprite = display.newSprite(myImageSheet, sequenceData)
  Player:insert(Player.sprite)
  Player.sprite:play()

  Player.name = 'player'
  Player.item = nil
  Player.facing = 'bottom'
  Player.speed = 0
  Player.maxSpeed = 150
  Player.x, Player.y = x, y
  Player.lastX, Player.lastY = x, y

  Player.vx, Player.vy = 0, 0
  Player.lastVx, Player.lastVy = 0, 0

  Player.health = 3

  physics.addBody(Player, 'dynamic', {
    bounce = 0.5,
    radius = 14,
  })
  Player.isFixedRotation = false
  Player.linearDamping = 16

  Player.swordGroup = display.newGroup()
  Player:insert(Player.swordGroup)
  Player.sword = display.newRect(Player.swordGroup, 0, 0, 56, 32)
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
      self.swordGroup.rotation = _G.h.getAngle(self.x, self.lastX, self.y, self.lastY)
    end

    local newFacing = _G.h.getFacing(self.x, self.lastX, self.y, self.lastY)
    if newFacing then self.facing = newFacing end

    self.shadow.x, self.shadow.y = self.sprite.x, self.sprite.y + 10
    self.sword.x, self.sword.y = self.sprite.x, self.sprite.y + self.height/4
    self.lastX, self.lastY = self.x, self.y
  end

  function Player:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return Player

end

return Public
