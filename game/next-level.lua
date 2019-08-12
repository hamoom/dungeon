local m = require('myapp')
local composer = require 'composer'
local scene = composer.newScene()
local widget = require('widget')

function scene:show(event)

  if (event.phase == 'will') then

  elseif (event.phase == 'did') then

  end
end

function scene:create(event)
  local sceneGroup = self.view


  timer.performWithDelay(260, function()
    composer.removeScene('game')
    composer.loadScene('game')
    composer.removeScene('next-level')
    composer.gotoScene('game', { time = 200, fadeTime = 500})
  end, 1)

end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)


return scene
