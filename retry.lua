local m = require('myapp')
local composer = require 'composer'
local scene = composer.newScene()

function scene:show(event)

  if (event.phase == 'will') then
    composer.removeScene('game')
  elseif (event.phase == 'did') then
    composer.removeScene('retry')

    composer.gotoScene('game', { time = 200, fadeTime = 500 })
  end
end

function scene:create(event)
  composer.loadScene('game')
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)


return scene
