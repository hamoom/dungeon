local m = require('myapp')
local composer = require 'composer'
local scene = composer.newScene()
local widget = require('widget')

function scene:show(event)

  if (event.phase == 'will') then
    composer.removeScene('game')
  elseif (event.phase == 'did') then
  end
end

function scene:create(event)
  local sceneGroup = self.view

  composer.loadScene('game')
  local retryText = display.newText({
    text = "Retry",
    x = display.contentWidth/2,
    y = display.contentHeight/2,
    width = display.contentWidth,
    font = native.systemFont,
    fontSize = 70,
    align = 'center'
  })
  sceneGroup:insert(retryText)

  local retryBtn = widget.newButton({
  	x=retryText.x,
  	y=retryText.y,
  	width=300,
  	height=300,
  	onPress=function(event)
      composer.removeScene('retry')
      composer.gotoScene('game', { time = 200, fadeTime = 500 })
  		event.target:setEnabled(false)
  	end
	})

  sceneGroup:insert(retryBtn)


end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)


return scene
