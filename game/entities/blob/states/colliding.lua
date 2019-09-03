local Public = {}

function Public.new(ent)
  local State = {}

  function State:update(player)
    ent:setLinearVelocity(0,0)
  end

  function State:start(player)
  end

  function State:exit(player)
  end


  return State
end

return Public
