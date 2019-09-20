local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    local BloodComponent = ent.components.blood
    BloodComponent:createStreak()
  end

  function State:start(player)
    _G.h.oscillate(3, 20, 'y', 500)(_G.m.map)

    local impulseSpeed = 30
    local diff = _G.p.newFromSubtraction(ent, player):normalize()

    ent:setLinearVelocity(0, 0)
    ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

    local BloodComponent = ent.components.blood
    BloodComponent:splash()

    local SpriteComponent = ent.components.sprite
    local sprite = SpriteComponent:getSprite()
    SpriteComponent:setFacing('running-f', 'running-b', 'running-s')
    sprite:pause()

    _G.m.addTimer(
      200,
      function()

        ent.health = ent.health - 1

        if ent.health > 0 then
          ent:setState('stunned', player)
        elseif ent.health <= 0 then
          if ent.item then
            ent:dropItem()
          end
          SpriteComponent:setAnim(nil)
          ent:setState('death', player)
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
