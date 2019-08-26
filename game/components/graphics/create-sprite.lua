local Public = {}
Public.name = 'sprite'
function Public.new(ent)

  local SpriteComponent = {}

  local spriteData = require('data.sprite-info.' .. ent.name)

  SpriteComponent.sprite = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)
  SpriteComponent.sprite:play()
  ent:insert(SpriteComponent.sprite)

  table.insert(_G.m.spriteList, SpriteComponent.sprite)

  function SpriteComponent:setAnim(sequence)

    local sprite = self.sprite
    if sprite.sequence ~= sequence then
      
      sprite:setSequence(sequence)
      sprite:play()
      sprite.sequence = sequence
    end
  end

  function SpriteComponent:getSprite()
    return self.sprite
  end

  return SpriteComponent
end

return Public
