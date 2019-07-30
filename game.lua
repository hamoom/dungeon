local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local composer = require('composer')
local widget = require('widget')

local scene = composer.newScene()

local health =  require('ui.health')
local joystick = require('ui.joystick').new()
local Player = require('entities.player.entity')
local Blob = require('entities.blob.entity')

local Spike = require('objects.spike')

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local dusk = require('Dusk.Dusk')
dusk.setPreference('virtualObjectsVisible', false)
dusk.setPreference('enableObjectCulling', false)
-- dusk.setPreference('enableTileCulling', false)
dusk.setPreference('cullingMargin', 2)
m.map = dusk.buildMap('levels/test.json')

local mapContainer = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local attack
local blobs = {}
local objects = {}
local easeX, easeY
local lastUpdate = 0
local screenTouched, update, getDeltaTime, keysPressed, resetLinearVelocity
local gameEnded = false

function scene:create(event)

	local sceneGroup = self.view
	sceneGroup:insert(mapContainer)

	health = health.new()
	sceneGroup:insert(health)
	sceneGroup:insert(joystick)

	local pauseButton = widget.newButton({
			x=display.contentWidth-40,
			y=30,
			width=30,
			height=30,
			shape="rect",
			onPress=function(event)
				scene:pauseToggle()
				event.target:setEnabled(false)
				timer.performWithDelay(1000, function()
					event.target:setEnabled(true)
				end,1)
			end
	})

	-- lets not spam pausing
	pauseButton:setEnabled(false)
	timer.performWithDelay(1200, function()
		pauseButton:setEnabled(true)
	end,1)

	pauseButton:setFillColor(1,1,1)
	sceneGroup:insert(pauseButton)

	mapContainer:insert(m.map)


	local padding = 30

	m.map.setCameraBounds({
		xMin = display.contentWidth/2 - padding,
		xMax = m.map.data.width - display.contentWidth/2 + padding,
		yMin = display.contentHeight/2 - padding,
		yMax = m.map.data.height - display.contentHeight/2 + padding
	})

	for object in m.map.layer['entities'].objects() do

		if object.type == 'player' then
			player = Player.new(m.map.layer['entities'], object.x, object.y)
			player:addEventListener('preCollision', preCollision)
		elseif object.type == 'blob' then

			local newNum = #blobs+1
			local blob = Blob.new(m.map.layer['entities'], object, player, newNum)
			blobs[newNum] = blob
		end
	end

	for object in m.map.layer['objects'].objects() do

		if object.name == 'spike' then
			objects[#objects+1] = Spike.new(m.map.layer['objects'], object)
		end
	end


	health:setHealth(player.health)

	m.map.setCameraFocus(player)
	m.map.setTrackingLevel(0.07)

	attackBtn = widget.newButton({
		width = 90,
		height = 90,
		onPress = function(event)
			if event.phase == 'began' then
				player.attacking = true
			end
		end
	})

	attackBtn.x = display.contentWidth - 90
	attackBtn.y = screenH-80
	sceneGroup:insert(attackBtn)

	attackBtn.visual = display.newRect(sceneGroup, attackBtn.x, attackBtn.y, attackBtn.width, attackBtn.height)
	attackBtn.visual.alpha = 0.4
end

function scene:pauseToggle()
	m.pause()
	if m.paused then
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

		m.cancelAllTimers()
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

	for _, blob in pairs(blobs) do
		if blob.destroy then blob:destroy() end
	end

	health:destroy()
	player:destroy()
	m.map.destroy()

	-- package.loaded[physics] = nil
	-- physics = nil

end

function preCollision(event)
	if player.state.name == 'running' then
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

		local function findNewCoord(obj)
			if not obj.isColliding then
				obj.isColliding = true
				obj.coord = nil
				timer.performWithDelay(300, function()
					obj.isColliding = false
				end, 1)
			end
		end

		local obj1, obj2 = event.object1, event.object2

		if obj1.name == 'blob' then findNewCoord(obj1) end
		if obj2.name == 'blob' then findNewCoord(obj2) end

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
			-- elseif otherObj.name == 'spike' then
			-- 	timer.performWithDelay(1, function() otherObj.isBodyActive = true end, 1)
			-- 	if otherObj.isAttacking then
			-- 		player:setState('injured', otherObj)
			-- 	end

			elseif otherObj.name == 'door' and player.item == 'key' then
				gameOver()
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
		  joystick:moved(event.x, event.y)
		elseif event.phase == 'ended' then
			joystick:stopped()
			player:setState('stopped')
		end
	end

end


function getDeltaTime()
    if lastUpdate == 0 then
        m.dt = 0
    else
        m.dt = (system.getTimer() - lastUpdate) / 1000
    end
    lastUpdate = system.getTimer()

    if m.dt > 0.02 then
        m.dt = 0.02
    end
end

function keysPressed(event)

	if event.phase == 'down' then
		if event.keyName == 'space' then
			player.attacking = true
		end
	end
end

function gameOver()
	if not gameEnded then
		gameEnded = true
		m.addTimer(100, function()
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

	for _, blob in pairs(blobs) do
		if h.isActive(blob) then activeEnemies[#activeEnemies+1] = blob end
	end

	for _, object in pairs(objects) do
		if h.isActive(object) then activeObjects[#activeObjects+1] = object end
	end

	for _, obj in pairs(activeObjects) do
		if obj.isAttacking then

			if h.hasCollided(obj, player.display) then
				player:setState('injured', obj)
			end

			for _, blob in pairs(activeEnemies) do
				if h.hasCollided(obj, blob) then
					blob:setState('injured', obj)
				end
			end
		end
	end

	for k, blob in pairs(activeEnemies) do
		blob:update(player)

		if h.hasCollided(player.sword, blob) and player.sword.active then
			blob:setState('injured', player)
		end

		if h.hasCollided(player.display, blob) and blob.isAttacking then
			player:setState('injured', blob)
		end

		if blob.health <= 0 then

			local thisBlob = table.remove(blobs, k)
			if thisBlob then
				thisBlob:destroy()
			end
		end
	end

 	m.map.updateView()
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
