local Public = {}
local mrand = math.random
function Public:new(ent)
  local State = {}

  function State:update()
    -- if self.enemy then self.enemy:setLinearVelocity(0,0) end
    -- ent:setLinearVelocity(0,0)
  end

  function State:start(enemy)
    -- ent.health = ent.health - 3
    Runtime:dispatchEvent({ name = 'changeHealth', params = { health = ent.health }})

    local diff = _G.p.newFromSubtraction(ent, enemy):normalize()


    diff.x = diff.x + (mrand(-100, 100) / 100)
    diff.y = diff.y + (mrand(-100, 100) / 100)

    ent.sprite:setFillColor(1,0.6,0.6)
    ent:setLinearVelocity(0,0)
    ent:applyLinearImpulse(0.2 * diff.x, 0.2  * diff.y, ent.x, ent.y)
    -- ent.alpha = 0.3

    -- if ent.facing == 'bottom' then
      ent:setAnim('injured-f')
    -- elseif ent.facing == 'top' then
    --   ent:setAnim('attacking-a')
    -- elseif ent.facing == 'right' then
    --   ent:setAnim('attacking-s')
    -- elseif ent.facing == 'left' then
    --   ent:setAnim('attacking-s')
    -- end

    _G.m.addTimer(500, function()
      if ent.health <= 0 then
        ent.health = 0
        Runtime:dispatchEvent({ name = 'gameOver' })
      else
        -- ent.alpha = 1
        ent.sprite:setFillColor(1,1,1)
        ent:setState('stopped')
      end
    end)


  end


  function State:exit()
  end


  return State
end


return Public
