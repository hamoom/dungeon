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


local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local dusk = require('Dusk.Dusk')
dusk.setPreference('virtualObjectsVisible', false)
dusk.setPreference('enableObjectCulling', false)
dusk.setPreference('cullingMargin', 2)
m.map = dusk.buildMap('levels/test.json')

local mapContainer = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local attack
local blobs = {}
local easeX, easeY
local lastUpdate = 0
local screenTouched, update, getDeltaTime, keysPressed, resetLinearVelocity

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


	player = Player.new(m.map.layer['meh'], screenW/2, screenH/2)
	player:addEventListener('preCollision', preCollision)

	health:setHealth(player.health)

	m.map.setCameraFocus(player)
	m.map.setTrackingLevel(0.07)

	local validLocations = {}
	for tile in m.map.layer['ground'].tilesInRange(0, 0, m.map.data.width, m.map.data.height) do
		if tile.gid ~= 51 then
			validLocations[#validLocations+1] = tile
		end
	end


	for i = 1, 3, 1 do
		local location = math.random(1, #validLocations)
		local tile = validLocations[location]
		local newNum = #blobs+1
		local blob = Blob.new(m.map.layer['meh'], tile.x, tile.y, player, newNum)

		blobs[newNum] = blob

	end

	attackBtn = widget.newButton({
		width = 60,
		height = 60,
		onPress = function(event)
			if event.phase == 'began' then
				player.attacking = true
			end
		end
	})

	attackBtn.x = display.contentWidth - 70
	attackBtn.y = screenH-50
	sceneGroup:insert(attackBtn)
	attackBtn.visual = display.newRect(sceneGroup, attackBtn.x, attackBtn.y, attackBtn.width, attackBtn.height)

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

	m.cancelAllTimers()

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
		local obj1, obj2 = event.object1, event.object2
		if obj1.name == 'blob' and not obj1.isColliding then
			obj1.isColliding = true
			obj1.coord = nil
			timer.performWithDelay(200, function()
				obj1.isColliding = false
			end, 1)

		end
		if obj2.name == 'blob' and not obj2.isColliding then
			obj2.isColliding = true
			obj2.coord = nil
			timer.performWithDelay(200, function()
				obj2.isColliding = false
			end, 1)
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

function gameOver(event)
	m.addTimer(100, function()
		composer.gotoScene('retry', { time = 0, params = { fadeTime = 500 }})
	end)
end

function update()
	getDeltaTime()

	local vx, vy = joystick.pos:normalized():getPosition()
	player:update(vx, vy)

	if #blobs > 0 then
			for _, blob in pairs(blobs) do

				blob:update(player)

				if h.hasCollided(player.sword, blob) and player.sword.active then
					blob:setState('injured', player)
				end

				if h.hasCollided(player.display, blob) and blob.isAttacking then
					player:setState('injured', blob)
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
