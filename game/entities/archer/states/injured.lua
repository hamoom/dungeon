local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    local BloodComponent = ent.components.blood
    BloodComponent:createStreak()
  end

  function State:start(player)
    local BloodComponent = ent.components.blood
    BloodComponent:splash()
    _G.h.oscillate(3, 20, 'y', 500)(_G.m.map)

    ent.display.fill.effect = 'filter.brightness'
    ent.display.fill.effect.intensity = 1

    _G.m.addTimer(
      50,
      function()
        ent.display.fill.effect = ''
      end
    )

    local impulseSpeed = 60
    ent:setLinearVelocity(0, 0)

    local diff = _G.p.newFromSubtraction(ent, player):normalize()

    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    _G.m.addTimer(
      1000,
      function()
        ent.health = ent.health - 1
        if ent.health > 0 then
          ent:setState('shooting', player)
        elseif ent.health <= 0 and ent.item then
          ent:dropItem()
        end
      end
    )
  end

  function State:exit()
    ent.alpha = 1
  end

  return State
end

return Public
