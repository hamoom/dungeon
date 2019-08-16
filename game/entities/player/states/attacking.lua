local Public = {}

function Public:new(ent)
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
    
    if ent.facing == 'bottom' then
      ent:setAnim('attacking-f')
    elseif ent.facing == 'top' then
      ent:setAnim('attacking-a')
    elseif ent.facing == 'right' then
      ent:setAnim('attacking-s')
    elseif ent.facing == 'left' then
      ent:setAnim('attacking-s')
    end


    ent.fixedRotation = true
    ent.sword.active = true
    -- ent.sword.isVisible = true

    self.attackTimer = 0.30
  end

  function State:exit()
    ent.fixedRotation = false
    ent.sword.active = false
    ent.sword.isVisible = false
  end


  return State
end



return Public
