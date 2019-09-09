local Public = {}

function Public.new(group, obj)
  local Door = obj
  local spriteData = require('data.sprite-info.lock')

  local lock = display.newSprite(spriteData.imageSheet, spriteData.sequenceData)

  Door.lock = lock

  group:insert(lock)
  -- local lock = display.newImageRect(doorObjectLayer, 'graphics/lock.png', 52, 30)
  lock.x = obj.x + (obj.lockXOffset or 0)
  lock.y = obj.y + (obj.lockYOffset or 0)

  function Door:openDoor(event)

    if event.doorId == self.doorId then

      local player = event.player

      local spriteListener = function(e)
        if e.phase == 'ended' then
          _G.m.addTimer(700, function()
            transition.fadeOut(lock, { time = 1000, onComplete = function()
              _G.m.map:focusCamera(self, player, 0, true)
            end})
          end)
        end
      end

      self.lock:addEventListener('sprite', spriteListener)

      _G.m.map:focusCamera(player, self, 1000, false, function()

        _G.h.oscillateMultiple(7, lock, function()
          self.lock:play()

          for _, coord in pairs(self.tiles) do
            self.isSensor = true
            local x, y = coord[1]+1, coord[2]+1
            local tile = _G.m.map.layer['doors'].tile(x, y)

            tile.fill.effect = 'filter.brightness'
            tile.fill.effect.intensity = 0.2
            tile:setFillColor(0.7,0,0)

            transition.fadeOut(tile, { time = 1000 })
          end
        end)
      end)


    end
  end

  function Door:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  Runtime:addEventListener('openDoor', Door)

  return Door
end

return Public
