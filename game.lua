
local composer = require('composer')
local widget = require('widget')

local scene = composer.newScene()

_G.controls:toFront()
local health = _G.controls.health
local joystick = _G.controls.joystick
local Player = require('entities.player.entity')

local Enemies = {
	blob = require('entities.blob.entity'),
	orc = require('entities.orc.entity'),
	archer = require('entities.archer.entity'),
}

local Objects = {
	spike = require('objects.spike'),
	door = require('objects.door')
}

local physics = require('physics')
-- physics.setDrawMode('hybrid')
physics.start()
physics.setGravity(0, 0)

local map = require('lib.map').new('levels/level-' .. _G.m.currentLevel .. '.json')

local mapContainer = display.newGroup()

local enemies = {}
local objects = {}
local theDoor

local lastUpdate = 0
local screenTouched, update, getDeltaTime, keysPressed
local gameEnded = false

function scene:create(event)


	local sceneGroup = self.view
	sceneGroup:insert(mapContainer)

	mapContainer:insert(_G.m.map)


	for object in _G.m.map.layer['entities'].objects() do

		if object.name == 'player' then
			player = Player.new(_G.m.map.layer['entities'], object.x, object.y)
			player:addEventListener('preCollision', preCollision)
		else
			local newNum = #enemies+1
			enemies[newNum] = Enemies[object.name].new(_G.m.map.layer['entities'], object, player, newNum)
		end
	end

	if _G.m.map.layer['objects'] then
		for object in _G.m.map.layer['objects'].objects() do
				if object.name == 'door' then
					theDoor = Objects[object.name].new(_G.m.map.layer['objects'], object)
				else
					objects[#objects+1] = Objects[object.name].new(_G.m.map.layer['objects'], object)
				end
		end
	end


	health:setHealth(player.health)

	_G.m.map.setCameraFocus(player)
	_G.m.map.setTrackingLevel(0.06)

	_G.controls.attackBtnFn = function(event)
		if event.phase == 'began' then
			player:attack()
		end
	end

	_G.controls.dashBtnFn = function(event)
		if event.phase == 'began' then
			player:dash()
			event.target:setEnabled(false)
			timer.performWithDelay(400, function()
				event.target:setEnabled(true)
			end,1)
		end
	end

	_G.controls.pauseBtnFn = function(event)
		scene:pauseToggle()
		event.target:setEnabled(false)
		timer.performWithDelay(1000, function()
			event.target:setEnabled(true)
		end,1)
	end

end

function scene:pauseToggle()
	_G.m.pause()
	if _G.m.paused then
		joystick.isVisible = false
		Runtime:removeEventListener("enterFrame", update)
		Runtime:removeEventListener("touch", screenTouched)
		Runtime:removeEventListener('key', keysPressed)
	else
		joystick.isVisible = true
		Runtime:addEventListener("enterFrame", update)
		Runtime:addEventListener("touch", screenTouched)
		Runtime:addEventListener('key', keysPressed)
	end
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if phase == 'will' then
		Runtime:addEventListener('enterFrame', update)

	elseif phase == 'did' then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

	end
end

function scene:hide(event)
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == 'will' then

		_G.m.cancelAllTimers()
		Runtime:removeEventListener('enterFrame', update)
		Runtime:removeEventListener('collision', onCollision)
		Runtime:removeEventListener('key', keysPressed)
		Runtime:removeEventListener('touch', screenTouched)

		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == 'did' then
		-- Called when the scene is now off screen
	end

end

function scene:destroy(event)

	local sceneGroup = self.view

	for _, enemy in pairs(enemies) do
		if enemy.destroy then enemy:destroy() end
	end

	for _, object in pairs(objects) do
		if object.destroy then object:destroy() end
	end

	health:destroy()
	player:destroy()
	_G.m.map.destroy()

	-- package.loaded[physics] = nil
	-- physics = nil

end

function preCollision(event)
	if player.state.name == 'running' or player.state.name == 'dashing' then
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
	if event.phase == 'began' then



		local obj1, obj2 = event.object1, event.object2

		if obj1.findNewCoord then obj1:findNewCoord() end
		if obj2.findNewCoord then obj2:findNewCoord() end

		if obj1.collisionCallBack then obj1:collisionCallBack() end
		if obj2.collisionCallBack then obj2:collisionCallBack() end

		if obj1.name == 'player' or obj2.name == 'player' then
			local player
			local otherObj
			if obj1.name == 'player' then
				player = obj1
				otherObj = obj2
			else
				player = obj2
				otherObj = obj1
			end

			if otherObj.name == 'key' then
				display.remove(otherObj)
				player.item = 'key'
				theDoor:open()
			-- elseif otherObj.name == 'spike' then
			--
			-- 	if otherObj.isAttacking then
			-- 		player:setState('injured', otherObj)
			-- 	end

		elseif otherObj.name == 'door' then
			-- and otherObj.isOpen
			-- and player.item == 'key' then
				nextLevel()
			end
		end
	end
end

function screenTouched(event)
  local left = (event.x < display.contentWidth/2) and true or false
	if left then
		if event.phase == 'began' then
			joystick.x, joystick.y = event.x, event.y
			joystick:makeJoystick()
		elseif event.phase == 'moved' then
		  if joystick.isActive then joystick:moved(event.x, event.y) end
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

			_G.m.addTimer(100, function()
				composer.gotoScene('next-level', { effect = 'zoomInOutFade', time = 200, params = { fadeTime = 500 }})
			end)

		-- end })

	end
end

function gameOver()
	if not gameEnded then
		gameEnded = true
		_G.m.addTimer(100, function()
			composer.gotoScene('retry', { time = 0, params = { fadeTime = 500 }})
		end)
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
			local thisEnemy = table.remove(enemies, k)
			if thisEnemy then thisEnemy:destroy() end
		elseif _G.h.isActive(enemy) then
			activeEnemies[#activeEnemies+1] = enemy
		end

	end

	for _, object in pairs(objects) do
		if _G.h.isActive(object) then activeObjects[#activeObjects+1] = object end
	end

	for _, obj in pairs(activeObjects) do
		if obj.isAttacking then

			if _G.h.hasCollided(obj, player.sprite) then
				player:setState('injured', obj)
			end

			for _, enemy in pairs(activeEnemies) do
				if _G.h.hasCollided(obj, enemy) then
					enemy:setState('injured', obj)
				end
			end
		end
	end

	for k, enemy in pairs(activeEnemies) do
		enemy:update(player)

		if player.sword.active and _G.h.hasCollided(player.sword, enemy) then
			enemy:setState('injured', player)
		end

		if enemy.isAttacking and _G.h.hasCollided(player.sprite, enemy)
		or enemy.weapon and enemy.weapon.isAttacking and _G.h.hasCollided(player.sprite, enemy.weapon) then
			player:setState('injured', enemy.weapon or enemy)

			if enemy.weapon and enemy.weapon.collisionCallBack then enemy.weapon:collisionCallBack() end
		end

	end

	_G.m.map:moveCamera()
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

-----------------------------------------------------------------------------------------

return scene
