local Public = {}
Public.name = 'sprite'
function Public.new(ent)

  local SpriteComponent = {}

  local spriteData = require('data.sprite-info.' .. ent.name)

  SpriteComponent.sprite = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)
  SpriteComponent.sprite:play()
  -- SpriteComponent.sprite:setStrokeColor( 1, 0 ,0 )
  -- SpriteComponent.sprite.strokeWidth = 5
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

  function SpriteComponent:setFacing(front, back, side, dontSwitchDir)
    local sprite = self.sprite

    if front and ent.facing == 'bottom'  then
      self:setAnim(front)
    elseif back and ent.facing == 'top' then
      self:setAnim(back)
    elseif side and ent.facing == 'right' or ent.facing == 'left' then
      self:setAnim(side)
      local vx = ent.x - ent.lastX

      if not dontSwitchDir
      and not ent.isColliding then
        if vx > 0 then
          sprite.xScale = 1
        elseif vx < 0 then
          sprite.xScale = -1
        end
      end
    end



  end

  return SpriteComponent
end

return Public
