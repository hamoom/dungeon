local mabs = math.abs
local Public = {}

function Public:new(ent)
  local State = {}

  local function createGhost()
    local sheetInfo = require('sprites.player')
    local myImageSheet = graphics.newImageSheet('sprites/player.png', sheetInfo:getSheet())
    local sequenceData = {
      { name='ghost', frames={ 39,40,41,42 }, time=800 },
    }
    local ghostSprite = display.newSprite(myImageSheet, sequenceData)
    ent.parent:insert(ghostSprite)

    -- ghostSprite.alpha = 0.7
    ghostSprite:play()
    ghostSprite.alpha = 0


    _G.m.addTimer(1000, function()
      ghostSprite.x, ghostSprite.y = ent.x-2, ent.y-2
      transition.to(ghostSprite, {alpha = 0.8, time = 700, y=ent.y-30, onComplete = function()
        local wave = 0
        _G.m.eachFrame(function()

          ghostSprite.y = ghostSprite.y - 1
          ghostSprite.x = ent.x-4 + math.sin(wave) * 40
          wave = wave + 0.02
        end)
      end})
    end)
  end

  function State:update()
    local vx, vy = ent:getLinearVelocity()
    if mabs(vx) < 2 and mabs(vy) < 2 then
      ent.isSensor = true
    end
  end

  function State:start()
    local spriteComponent = ent.components.sprite
    spriteComponent:setAnim('death')

    Runtime:dispatchEvent({ name = 'stopInput' })
    _G.controls:remove()

    -- createGhost()

    _G.m.addTimer(5000, function()
      Runtime:dispatchEvent({ name = 'gameOver' })
    end)
  end

  function State:exit()

  end


  return State
end

return Public
