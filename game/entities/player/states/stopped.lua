local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()

    ent.speed = ent.speed * 0.9

    if math.abs(ent.vx) > 0 or math.abs(ent.vy) > 0 then
      ent:setState('running')
    end

    ent:setLinearVelocity(
      ent.lastVx * ent.speed,
      ent.lastVy * ent.speed
    )

    if ent.attacking then ent:setState('attacking') end

    if ent.facing == 'bottom' then
      ent:setAnim('stopped-f')
    elseif ent.facing == 'top' then
      ent:setAnim('stopped-b')
    elseif ent.facing == 'right' then
      ent:setAnim('stopped-s')      
    elseif ent.facing == 'left' then
      ent:setAnim('stopped-s')
    end

  end

  function State:start()
    ent.fixedRotation = true
  end

  function State:exit()
    ent.fixedRotation = false
  end


  return State
end

return Public
