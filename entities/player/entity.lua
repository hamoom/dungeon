local p = require('lib.point')
local physics = require('physics')
local Public = {}
local player
local stateList = require('entities.player.states.list')
local states

function Public.new(group, x, y)
  player = display.newGroup()
  group:insert(player)
  player.x, player.y = x,y
  player.attacking = false

  player.display = display.newRect(player, 0, 0, 32, 32)

  physics.addBody(player, 'dynamic', {
    bounce = 0
  })
  player.isFixedRotation = true

  player.sword = display.newRect(player, 0, 0, 32, 24)
  player.sword.active = false
  player.sword.isVisible = false
  player.sword:setFillColor(1,0,0)

  function player:setState(state)
    local newState = states:getState(state)
    if player.state.name ~= newState.name then
      player.state:exit(newState)
      newState:start()
      player.state = newState
    end
  end

  function player:update(vx, vy)
    player.vx, player.vy = vx, vy
    self.state:update()
    self:setLinearVelocity(player.vx, player.vy)

    if math.abs(player.vx) > 0 and math.abs(player.vy) > 0 then

      local avx, avy = math.abs(player.vx), math.abs(player.vy)
      local angle

      if avy > avx and player.vy < 0 then
        angle = -180
      elseif avy > avx and player.vy > 0 then
        angle = 0
      elseif avx > avy and player.vx > 0 then
        angle = -90
      elseif avx > avy and player.vx < 0 then
        angle = 90
      end

      -- 90 is left, -90 is right
      -- 0 is down, -180 is up


      player.rotation = angle
    end



    player.sword.x, player.sword.y = player.display.x, player.display.y + player.height/2
  end


  states = stateList.new(player)
  player.state = states:getState('stopped')

  return player

end

return Public



