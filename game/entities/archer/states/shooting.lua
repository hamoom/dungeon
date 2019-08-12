local Public = {}

function Public:new(ent)
  local State = {}



  local function shoot(player)

    ent.weapon.x, ent.weapon.y = ent.x, ent.y
    ent.weapon.isAttacking = true
    ent.weapon.isVisible = true
    ent.weapon.rotation = p.new(ent.weapon):subtract(player):angle()

    local speed = 200

    State.arrowVelocity = p.new(player)
      :subtract(ent.weapon)
      :normalize()
      :multiply(speed)
  end

  function State:update(player)
      ent.rotation = _G.h.rotateToward(ent, player)


      if self.arrowVelocity then
        ent.weapon:setLinearVelocity(self.arrowVelocity.x, self.arrowVelocity.y)
      end

      if _G.p.new(ent):distanceTo(player) > ent.attackDistance then
        ent:setState('wandering', player)
      end

      self.shootTimer = self.shootTimer - _G.m.dt
      if self.shootTimer <= 0 then
        self.shootTimer = 4.5
        shoot(player)
      end

  end

  function State:start(player)
    State.shootTimer = 4.5
    shoot(player)
  end

  function State:exit(player)
    self.arrowVelocity = nil
  end

  return State
end

return Public
