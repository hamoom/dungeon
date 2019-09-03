local Public = {}

function Public.new(ent)
  local State = {}

  State.attackTimer = 0

  function State:update()
    ent.speed = ent.speed * 0.8
    ent:setLinearVelocity(ent.vx * ent.speed, ent.vy * ent.speed)

    self.attackTimer = self.attackTimer - _G.m.dt
    if self.attackTimer <= 0 then
      ent:setState('stopped')
    end
  end

  function State:start()
    local weaponComponent = ent.components.weapon
    local SpriteComponent = ent.components.sprite

    SpriteComponent:setFacing('attacking-f', 'attacking-b', 'attacking-s', true)

    weaponComponent:setAttacking(true)

    self.attackTimer = 0.30
  end

  function State:exit()
    local weaponComponent = ent.components.weapon

    weaponComponent:setAttacking(false)
  end

  return State
end

return Public
