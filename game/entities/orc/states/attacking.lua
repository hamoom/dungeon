local Public = {}

function Public.new(ent)
  local State = {}

  function State:update(player)
    local weapon = ent.components.weapon:getHitBox()
    local SpriteComponent = ent.components.sprite
    local sprite = SpriteComponent:getSprite()
    self.attackTimer = self.attackTimer - _G.m.dt
    weapon.isAttacking = false

    if self.attackTimer <= 0.75 and self.attackTimer >= 0.5 then
      weapon.isAttacking = true
    elseif self.attackTimer <= 0 then
      self.attackTimer = 1
      if _G.p.new(ent):distanceTo(player) > ent.attackDistance then
        ent:setState('chasing', player)
      else
        local angle = _G.h.rotateToward(ent, player)
        ent.facing = _G.h.getDirFromAngle(angle)
        if ent.facing == 'right' or ent.facing == 'left' then
          sprite.xScale = player.x > ent.x and 1 or -1
        end
        SpriteComponent:setFacing('attacking-f', 'attacking-b', 'attacking-s', true, true)
      end
    end
  end

  function State:start(player)

    local SpriteComponent = ent.components.sprite
    local sprite = SpriteComponent:getSprite()
    local angle = _G.h.rotateToward(ent, player)
    ent.facing = _G.h.getDirFromAngle(angle)
    if ent.facing == 'right' or ent.facing == 'left' then
      sprite.xScale = player.x > ent.x and 1 or -1
    end
    SpriteComponent:setFacing('attacking-f', 'attacking-b', 'attacking-s', true)
    ent.fixedRotation = true

    self.attackTimer = 1
  end

  function State:exit()
    local weapon = ent.components.weapon:getHitBox()

    ent.fixedRotation = false
    weapon.isVisible = false
    weapon.isAttacking = false
  end

  return State
end

return Public
