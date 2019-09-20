local Public = {}

function Public.new(ent, name)

  local states = ent.states
  local list = {}

  for _, v in pairs(states) do
    list[v] = require('entities.' .. name .. '.states.' .. v).new(ent)
    list[v].name = v
  end

  function list:getState(state)
    return self[state]
  end

  return list
end

return Public
