local Public = {}

function Public:new(ent)
  local State = {}

  function State:update()

  end

  function State:start()
    Runtime:dispatchEvent({ name = 'stopInput' })
    _G.controls:remove()

    ent.isSensor = true
    ent:setAnim('death')
    _G.m.addTimer(5000, function()
      Runtime:dispatchEvent({ name = 'gameOver' })
    end)
  end

  function State:exit()

  end


  return State
end

return Public
