local m = require("myapp")
local p = require('lib.point')
local h = require('lib.helper')
local composer = require('composer')
local widget = require('widget')

local scene = composer.newScene()

local Player = require('entities.player.entity')
local Blob = require('entities.blob.entity')


local physics = require('physics')
physics.start()


local dusk = require('Dusk.Dusk')
dusk.setPreference('virtualObjectsVisible', false)
dusk.setPreference('enableObjectCulling', false)

dusk.setPreference('cullingMargin', 2)

local mapContainer = display.newGroup()
m.map = dusk.buildMap('levels/test.json')

-- TODO FIX THIS I GUESS
local map = m.map

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local joystick, joystickBase, joystickKnob, attackBtn
local direction = { x = nil, y = nil }
local joystickPos = p.new(0,0)
local blob
local easeX, easeY
local lastUpdate = 0
local screenTouched, joystickMoved, joystickStopped, update, getDeltaTime, keysPressed



function scene:create(event)

	physics.setGravity(0, 0)
	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	sceneGroup:insert(mapContainer)
	player = Player.new(map.layer['meh'], screenW/2, screenH/2)
	player:addEventListener('collision', onCollision)
	player:addEventListener('preCollision', preCollision)


	blob = Blob.new(map.layer['meh'], screenW/2+100, screenH/2+100)

	map.setCameraFocus(player)
	map.setTrackingLevel(0.07)
	local padding = 30

	map.setCameraBounds({
		xMin = display.contentWidth/2 - padding,
		xMax = map.data.width - display.contentWidth/2 + padding,
		yMin = display.contentHeight/2 - padding,
		yMax = map.data.height - display.contentHeight/2 + padding
	})

	mapContainer:insert(map)

	joystick = display.newGroup()
	sceneGroup:insert(joystick)
	joystick.alpha = 0.3
	joystickBase = display.newCircle(joystick, 70, screenH-50, 40)
	joystickKnob = display.newCircle(joystick, joystickBase.x, joystickBase.y, 25)
	joystickKnob:setFillColor(1,0,0)

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
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == 'did' then
		-- Called when the scene is now off screen
	end

end

function scene:destroy(event)

	-- Called prior to the removal of scene's 'view' (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

function preCollision(event)
	if event.phase == 'began' then
		if event.other.name == 'blob' then
			if not event.other.isAttacking then
				print('meh')
				player:setLinearVelocity(0,0)
			end
		end
	end
end

function onCollision(event)
	if event.phase == 'began' then
		if event.other.name == 'blob' then

			if event.other.isAttacking then
				player:setState('injured', event.other)

			end

		end

		-- print(event.object1, event.object2)
	end
end

function screenTouched(event)
  local left = (event.x < display.contentWidth/2) and true or false
	if left then
		if event.phase == 'began' or event.phase == 'moved' then
		  joystickMoved(event)
		elseif event.phase == 'ended' then
			joystickStopped()
		end
	end

end

function joystickMoved(event)

	joystickPos
		:setPosition(event.x, event.y)
		:subtract(joystickBase)


	local length = joystickPos:length()
	local maxDist = 40
	local adjustedLength = h.clamp(length, 0, maxDist)

	joystickKnob.x, joystickKnob.y = joystickPos
																		:normalized()
																		:multiply(adjustedLength)
																		:getPosition()

	joystickKnob.x = joystickKnob.x + joystickBase.x
	joystickKnob.y = joystickKnob.y + joystickBase.y

  if length > maxDist then
    local lengthDiff = length - adjustedLength

    joystickPos:
	    normalized():
	    multiply(lengthDiff, lengthDiff)


  end

end

function joystickStopped()
	joystickKnob.x, joystickKnob.y = joystickBase.x, joystickBase.y
	joystickPos:setPosition(0,0)
	player:setState('stopped')
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

function update()
	getDeltaTime()

	local vx, vy = joystickPos:normalized():getPosition()
	player:update(vx, vy, blob)

	if h.hasCollided(player.sword, blob) and player.sword.active then
		-- display.remove(blob)
		-- blob = nil
		blob:setState('injured', player)
	end

	if blob then blob:update(player) end

 	map.updateView()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

Runtime:addEventListener('key', keysPressed)
Runtime:addEventListener('touch', screenTouched)

-----------------------------------------------------------------------------------------

return scene
