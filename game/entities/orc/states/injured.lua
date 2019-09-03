local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()
    if self.prevStateName ~= 'blocking' then
      local BloodComponent = ent.components.blood
      BloodComponent:createStreak()
    end
  end

  function State:start(player)

    _G.h.oscillate(3,20,"y",500)(_G.m.map)

    local impulseSpeed = 20
    local diff = _G.p.newFromSubtraction(ent, player):normalize()

    ent:setLinearVelocity(0, 0)
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    if self.prevStateName ~= 'blocking' then
      local BloodComponent = ent.components.blood
      BloodComponent:splash()
    end

    _G.m.addTimer(600, function()

      if self.prevStateName == 'blocking' then
        ent:setState('chasing', player)
      else
        ent.health = ent.health - 1

        if ent.health > 0 then
          ent:setState('chasing', player)
        elseif ent.health <= 0 and ent.item then
          ent:dropItem()
        end
      end

    end)

  end

  function State:exit()
    ent.alpha = 1
  end


  return State
end

return Public
