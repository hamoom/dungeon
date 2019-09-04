local Public = {}

function Public.new(ent)
  local State = {}

  function State:update()
    ent:setLinearVelocity(0,0)
  end

  function State:start()
  end

  function State:exit()
  end


  return State
end

return Public
