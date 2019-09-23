local Public = {}

function Public.new(group, obj)
  local spriteData = require('data.sprite-info.spark')
  local sprite = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)
  sprite.x, sprite.y = obj.x, obj.y
  group:insert(sprite)
  table.insert(_G.m.spriteList, sprite)

  function sprite:flare()
    local function spriteListener(event)
      if event.phase == 'ended' then
        display.remove(self)
      end
    end
    self:addEventListener('sprite', spriteListener)
    self:play()
  end

  return sprite
end


return Public