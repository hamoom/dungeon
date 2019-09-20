local Public = {}
Public.name = 'dashEffect'

function Public.new(ent, args)
  local group, sprite = unpack(args)

  local DashComponent = {}
  DashComponent.sprites = {}

  for _ = 1, 10 do
    local spriteData = require('data.sprite-info.' .. ent.name)
    local thisSprite = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)
    group:insert(thisSprite)
    thisSprite.isVisible = false
    thisSprite.alpha = 0.3
    thisSprite.cancelChase = function(self)
      self.isVisible = false
      _G.m.eachFrameRemove(self.animFunc)
    end

    thisSprite.chaseEnt = function(self)
      self.animFunc = function()
        if _G.p.new(self):distanceTo(ent) > 10 then
          local velocity = _G.p.new(ent)
            :subtract(self)
            :normalize()
            :multiply(15)

          self.x, self.y = self.x + velocity.x, self.y + velocity.y
        else
          self:cancelChase()
        end
      end
      _G.m.addTimer(100, function()
        _G.m.eachFrame(self.animFunc)
      end)

    end
    DashComponent.sprites[#DashComponent.sprites + 1] = thisSprite
  end

  function DashComponent:chase()
    sprite.fill.effect = 'filter.brightness'
    sprite.fill.effect.intensity = 1

    _G.m.addTimer(50, function()
      sprite.fill.effect.intensity = 0
    end)

    local time = 15

    for _, v in pairs(self.sprites) do
      -- print(_G.h.dumpvar(v))
      v:cancelChase()
      v.x, v.y = ent.x, ent.y
      v.xScale = sprite.xScale
      _G.m.addTimer(time, function()

        v.isVisible = true
        v:setSequence(sprite.sequence)
        v:play()
        v:chaseEnt()
      end)
      time = time * 1.15
    end
  end

  return DashComponent

end

return Public
