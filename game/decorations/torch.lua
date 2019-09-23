local Public = {}

function Public.new(group, obj)
  local spriteData = require('data.sprite-info.torch')
  local sprite = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)
  sprite.x, sprite.y = obj.x, obj.y
  group:insert(sprite)
  table.insert(_G.m.spriteList, sprite)
  sprite:play()

  return sprite
end

return Public