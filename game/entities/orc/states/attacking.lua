local Public = {}

function Public:new(ent)
  local State = {}

  function State:update(player)
    local weapon = ent.components.weapon:getHitBox()

    self.attackTimer = self.attackTimer - _G.m.dt
    weapon.isAttacking = false
    weapon:setFillColor(1,1,0)

    if self.attackTimer <= 1.75 and self.attackTimer >= 1.5 then
      weapon.isAttacking = true
      weapon:setFillColor(1,0,1)
    elseif self.attackTimer <= 0 then
      self.attackTimer = 2
      if _G.p.new(ent):distanceTo(player) > ent.attackDistance then
        ent:setState('chasing', player)
      end
    end
  end

  function State:start(player)
    local weapon = ent.components.weapon:getHitBox()
    -- ent.rotation = _G.h.rotateToward(ent, player)

    ent.fixedRotation = true
    weapon.isVisible = true

    self.attackTimer = 2
  end

  function State:exit(player)
    local weapon = ent.components.weapon:getHitBox()

    ent.fixedRotation = false
    weapon.isVisible = false
    weapon.isAttacking = false
  end

  return State
end

return Public
