local Public = {}
Public.name = 'stopped'

function Public:update()

  local ent = self.ent
  ent.speed = ent.speed * 0.9


  if math.abs(ent.vx) > 0 or math.abs(ent.vy) > 0 then
    ent:setState('running')
  end

  ent:setLinearVelocity(
    ent.lastVx * ent.speed,
    ent.lastVy * ent.speed
  )

  -- ent:setLinearVelocity(
  --   0,
  --   0
  -- )

  if ent.attacking then ent:setState('attacking') end


end

function Public:start()
end

function Public:exit()
end

return Public
