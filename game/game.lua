local composer = require('composer')

local scene = composer.newScene()

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)
-- physics.setDrawMode('hybrid')
_G.m.spriteList = {}
_G.controls = require('ui.controls'):new()
_G.controls.group:toFront()

local map = require('lib.map')
map.new('levels/level-' .. _G.m.currentLevel .. '.json')

local health = _G.controls.health
local joystick = _G.controls.joystick
local Player = require('entities.player.entity')

local Enemies = {
  blob = require('entities.blob.entity'),
  orc = require('entities.orc.entity'),
  archer = require('entities.archer.entity')
}

local Objects = {
  spike = require('objects.spike'),
  door = require('objects.door')
}

local Decorations = {
  torch = require('decorations.torch')
}

local SceneTransition = require('lib.scene-transition')

local mapContainer = display.newGroup()

local enemies = {}
local objects = {}


local player

local lastUpdate = 0
local preCollision,
  onCollision,
  screenTouched,
  update,
  getDeltaTime,
  keysPressed,
  stopInput,
  gameOver,
  nextLevel,
  pauseToggle,
  pause,
  resume
local gameEnded = false


function scene:create()
  local sceneGroup = self.view
  sceneGroup:insert(mapContainer)
  local transitionGroup = display.newGroup()
  sceneGroup:insert(transitionGroup)
  -- SceneTransition.new({
  --   transition = 'exiting',
  --   direction = 'left'
  -- }, transitionGroup)

  mapContainer:insert(_G.m.map)

  for object in _G.m.map.layer['entities'].objects() do
    if object._name == 'player' then
      player = Player.new(_G.m.map.layer['entities'], object.x, object.y)
      player:addEventListener('preCollision', preCollision)
    end
  end

  for object in _G.m.map.layer['entities'].objects() do
    if object._name ~= 'player' then
      enemies[#enemies + 1] = Enemies[object._name].new(_G.m.map.layer['entities'], object, player)
    end
  end

  for object in _G.m.map.layer['objects'].objects() do
    objects[#objects + 1] = Objects[object._name].new(_G.m.map.layer['objects'], object)
  end

  for object in _G.m.map.layer['decorations'].objects() do
    Decorations[object._name].new(_G.m.map.layer['decorations'], object)
  end

  player:toFront()

  -- timer.performWithDelay(1500, function()
  --   Runtime:dispatchEvent({ name = 'openDoor', doorId = 1, player = player })
  -- end,1)

  health:setHealth(player.health)

  _G.m.map.setCameraFocus(player)
  _G.m.map.setTrackingLevel(0.06)

  _G.controls.attackBtnFn = function(event)
    if event.phase == 'began' then
      player:attack()
      event.target:setEnabled(false)
      timer.performWithDelay(
        700,
        function()
          event.target:setEnabled(true)
        end,
        1
      )
    end
  end

  _G.controls.dashBtnFn = function(event)
    if event.phase == 'began' then
      player:dash()
      event.target:setEnabled(false)
      timer.performWithDelay(
        400,
        function()
          event.target:setEnabled(true)
        end,
        1
      )
    end
  end

  _G.controls.pauseBtnFn = function(event)
    pauseToggle()
    event.target:setEnabled(false)
    timer.performWithDelay(
      1000,
      function()
        event.target:setEnabled(true)
      end,
      1
    )
  end
end

function pauseToggle()
  print(_G.m.isPaused)
  if not _G.m.isPaused then
    pause()
  else
    resume()
  end
end

function pause()
  _G.m.pause()
  joystick.isVisible = false
  Runtime:removeEventListener('enterFrame', update)
  Runtime:removeEventListener('touch', screenTouched)
  Runtime:removeEventListener('key', keysPressed)
end

function resume()
  _G.m.resume()
  joystick.isVisible = true
  Runtime:addEventListener('enterFrame', update)
  Runtime:addEventListener('touch', screenTouched)
  Runtime:addEventListener('key', keysPressed)
end

function scene:show(event)
  local phase = event.phase

  if phase == 'will' then
    Runtime:addEventListener('enterFrame', update)
  elseif phase == 'did' then
  end
end

function scene:hide(event)

  local phase = event.phase

  if event.phase == 'will' then
    _G.m.eachFrameRemoveAll()
    _G.m.cancelAllTimers()
    _G.m.spriteList = {}
    Runtime:removeEventListener('enterFrame', update)
    Runtime:removeEventListener('collision', onCollision)
    Runtime:removeEventListener('key', keysPressed)
    Runtime:removeEventListener('touch', screenTouched)

    -- INSERT code here to pause the scene
    -- e.g. stop timers, stop animation, unload sounds, etc.)

  elseif phase == 'did' then
  -- Called when the scene is now off screen
  end
end

function scene:destroy()

  for _, enemy in pairs(enemies) do
    if enemy.destroy then
      enemy:destroy()
    end
  end

  for _, object in pairs(objects) do
    if object.destroy then
      object:destroy()
    end
  end

  health:destroy()
  player:destroy()
  _G.m.map.destroy()
  physics.stop()
  -- package.loaded[physics] = nil
  -- physics = nil
end

function preCollision(event)
  if player.state.name == 'running' or player.state.name == 'dashing' or player.state.name == 'stopped' then
    if event.contact then
      event.contact.bounce = 0

      if event.other.name == 'blob' then
        if event.other.isAttacking then
          event.contact.bounce = 1
        else
          event.contact.bounce = 0
        end
      end
    end
  end
end

function onCollision(event)
  local obj1, obj2 = event.object1, event.object2

  if event.phase == 'began' then

    if obj1.findNewCoord then
      obj1:findNewCoord()
    end
    if obj2.findNewCoord then
      obj2:findNewCoord()
    end

    if obj1.name ~= player and obj2.name ~= player then
      obj1.dontRotate = true
      obj2.dontRotate = true
    end

    if obj1.collisionCallBack and obj2.name ~= 'player' then
      obj1:collisionCallBack()
    end
    if obj2.collisionCallBack and obj1.name ~= 'player' then
      obj2:collisionCallBack()
    end

    if obj1.name == 'player' or obj2.name == 'player' then
      local thePlayer
      local otherObj
      if obj1.name == 'player' then
        thePlayer = obj1
        otherObj = obj2
      else
        thePlayer = obj2
        otherObj = obj1
      end

      -- if obj1.isEntity and obj2.isEntity then
      --   obj1.isTouchingEnt = true
      --   obj2.isTouchingEnt = true
      -- end
    end
  elseif event.phase == 'ended' then

    if obj1.name ~= player and obj2.name ~= player then
      obj1.dontRotate = false
      obj2.dontRotate = false
    end

    -- if obj1.isEntity and obj2.isEntity then
    --   obj1.isTouchingEnt = false
    --   obj2.isTouchingEnt = false
    -- end
  end
end

function screenTouched(event)
  local left = (event.x < display.contentWidth / 2) and true or false
  if left then
    if event.phase == 'began' then
      joystick.x,
        joystick.y = event.x, event.y
      joystick:makeJoystick()
    elseif event.phase == 'moved' then
      if joystick.isActive then
        joystick:moved(event.x, event.y)
      end
    elseif event.phase == 'ended' then
      joystick:stop()
      player:setState('stopped')
    end
  end
end

function getDeltaTime()
  if lastUpdate == 0 then
    _G.m.dt = 0
  else
    _G.m.dt = (system.getTimer() - lastUpdate) / 1000
  end
  lastUpdate = system.getTimer()

  if _G.m.dt > 0.02 then
    _G.m.dt = 0.02
  end
end

function keysPressed(event)
  if event.phase == 'down' then
    if event.keyName == 'space' then
      player:attack()
    elseif event.keyName == 'c' then
      player:dash()
    end
  end
end

function nextLevel()
  if not gameEnded then
    gameEnded = true
    _G.m.currentLevel = _G.m.currentLevel + 1
    -- transition.to(mapContainer, { delta = true, x = display.contentWidth, onComplete = function()

    _G.m.addTimer(
      100,
      function()
        composer.gotoScene('next-level', {effect = 'zoomInOutFade', time = 200, params = {fadeTime = 500}})
      end
    )

  -- end })
  end
end

function gameOver()
  if not gameEnded then
    gameEnded = true
    _G.m.addTimer(
      100,
      function()
        _G.controls:remove()
        composer.gotoScene('retry', {time = 0, params = {fadeTime = 500}})
      end
    )
  end
end

function update()
  getDeltaTime()

  local vx, vy = joystick.pos:normalized():getPosition()
  player:update(vx, vy)

  local activeEnemies = {}
  local activeObjects = {}

  for k, enemy in pairs(enemies) do
    if enemy.health <= 0 then
      table.remove(enemies, k)
    elseif _G.h.isActive(enemy, 100, 100) then
      activeEnemies[#activeEnemies + 1] = enemy
    end
  end

  for _, object in pairs(objects) do
    if _G.h.isActive(object) then
      activeObjects[#activeObjects + 1] = object
    end
  end

  for _, obj in pairs(activeObjects) do
    if obj.isAttacking then
      local sprite = player.components.sprite:getSprite()
      if _G.h.hasCollided(obj, sprite) then
        player:setState('injured', obj)
      end

      for _, enemy in pairs(activeEnemies) do
        if _G.h.hasCollided(obj, enemy) then
          enemy:setState('injured', obj)
        end
      end
    end
  end

  for _, enemy in pairs(activeEnemies) do
    local playerWeapon = player.components.weapon:getHitBox()
    -- local playerSprite = player.components.sprite:getSprite()
    local enemySprite = enemy.components.sprite:getSprite()

    if playerWeapon.isAttacking
      and _G.h.hasCollided(playerWeapon, enemySprite)
      and enemy.isHittable then
      if enemy:hasState('struck') then
        enemy:setState('struck', player)
      else
        enemy:setState('injured', player)
      end
    end

    enemy:update()
  end

  _G.m.map:moveCamera(player)
end

function stopInput()
  Runtime:removeEventListener('touch', screenTouched)
  Runtime:removeEventListener('key', keysPressed)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

Runtime:addEventListener('key', keysPressed)
Runtime:addEventListener('touch', screenTouched)

Runtime:addEventListener('collision', onCollision)
Runtime:addEventListener('gameOver', gameOver)
Runtime:addEventListener('stopInput', stopInput)
Runtime:addEventListener('pause', pause)
Runtime:addEventListener('resume', resume)

-----------------------------------------------------------------------------------------

return scene
