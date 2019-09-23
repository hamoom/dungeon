local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
  end

  function State:start(player)
    ent.isHittable = false
    local BloodComponent = ent.components.blood

    local spriteComponent = ent.components.sprite
    spriteComponent:setAnim('death', function(event)
      if event.phase == 'ended' then
        display.remove(ent.shadow)
        BloodComponent:puddle()
      end
    end)

    self.timer = _G.m.addTimer(1000, function()
      ent:destroy(player)
    end)
  end

  function State:exit()
    _G.m.cancelTimer(self.timer)
  end


  return State
end

return Public
