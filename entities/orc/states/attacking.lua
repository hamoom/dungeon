local Public = {}

function Public:new(ent)
  local State = {}


  function State:update(player)
    self.attackTimer = self.attackTimer - _G.m.dt
    ent.weapon.isAttacking = false
    ent.weapon:setFillColor(1,1,0)

    if self.attackTimer <= 1.75 and self.attackTimer >= 1.5 then
      ent.weapon.isAttacking = true
      ent.weapon:setFillColor(1,0,1)
    elseif self.attackTimer <= 0 then
      self.attackTimer = 2
      if _G.p.new(ent):distanceTo(player) > ent.attackDistance then
        ent:setState('chasing', player)
      end
    end
  end

  function State:start(player)


    ent.rotation = _G.h.rotateToward(ent, player)

    ent.fixedRotation = true
    ent.weapon.active = true
    ent.weapon.isVisible = true

    self.attackTimer = 2
  end

  function State:exit(player)
    ent.fixedRotation = false
    ent.weapon.active = false
    ent.weapon.isVisible = false
    ent.weapon.isAttacking = false
  end

  return State
end

return Public
