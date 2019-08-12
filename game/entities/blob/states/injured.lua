local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()
  end

  function State:start(player)


    local impulseSpeed = 50

    ent.alpha = 0.3
    ent:setLinearVelocity(0, 0)

    local diff = _G.p.newFromSubtraction(ent, player):normalize()

    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    _G.m.addTimer(1000, function()
      ent.health = ent.health - 2

      if ent.health > 0 then
        ent:setState('stopped', player)
      elseif ent.health <= 0 and ent.item then
        ent:dropItem()
      end
    end)

  end

  function State:exit()
    ent.alpha = 1
  end


  return State
end

return Public
