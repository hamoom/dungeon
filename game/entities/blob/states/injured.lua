local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    local BloodComponent = ent.components.blood
    BloodComponent:createStreak()
  end

  function State:start(player)
    -- print('im here')
    ent.health = ent.health - 1

    _G.h.oscillate(3, 20, 'y', 500)(_G.m.map)

    local BloodComponent = ent.components.blood
    BloodComponent:splash()

    local diff = _G.p.newFromSubtraction(ent, player):normalize()
    local impulseSpeed = 20
    ent:setLinearVelocity(0, 0)
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    if ent.health > 0 then
      _G.m.addTimer(
        1000,
        function()
          ent:setState('stopped', player)
        end
      )
    else
      ent:setState('death', player)
    end
  end

  function State:exit()
  end

  return State
end

return Public
