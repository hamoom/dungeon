local mabs = math.abs
local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    local vx, vy = ent:getLinearVelocity()
    if mabs(vx) < 2 and mabs(vy) < 2 then
      ent.isSensor = true
    end
  end

  function State:start()
    local BloodComponent = ent.components.blood

    local spriteComponent = ent.components.sprite
    spriteComponent:setAnim('death', function(event)
      if event.phase == 'ended' then
        display.remove(ent.shadow)
        BloodComponent:puddle()
      end
    end)

    Runtime:dispatchEvent({ name = 'stopInput' })
    _G.controls:remove()

    _G.m.addTimer(5000, function()
      Runtime:dispatchEvent({ name = 'gameOver' })
    end)
  end

  function State:exit()

  end


  return State
end

return Public
