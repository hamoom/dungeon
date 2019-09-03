local Public = {}
local mrand = math.random
local mabs = math.abs
function Public:new(ent)
  local State = {}
  State.bloods = {}

  function State:update()
    local BloodComponent = ent.components.blood
    BloodComponent:createStreak()
  end

  function State:start(enemy)

    -- ent.health = ent.health - 1
    --
    -- local BloodComponent = ent.components.blood
    -- BloodComponent:splash()
    --
    -- _G.h.oscillate(3,50,"y",500)(_G.m.map)
    --
    -- Runtime:dispatchEvent({ name = 'changeHealth', params = { health = ent.health }})
    --
    -- local diff = _G.p.newFromSubtraction(ent, enemy):normalize()
    --
    -- diff.x = diff.x + (mrand(-100, 100) / 100)
    -- diff.y = diff.y + (mrand(-100, 100) / 100)
    --
    -- ent:setLinearVelocity(0,0)
    -- ent:applyLinearImpulse(0.2 * diff.x, 0.2  * diff.y, ent.x, ent.y)

    _G.m.addTimer(50, function()

      if ent.health <= 0 then
        ent:setState('death')
      else
        _G.m.addTimer(250, function()
          ent:setState('stopped')
        end)
      end
    end)

    _G.h.stutter()

  end

  function State:exit()
  end

  return State
end


return Public
