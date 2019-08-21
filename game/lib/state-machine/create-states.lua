local lfs = require('lfs')
local Public = {}

function Public.new(ent, name)

  local doc_path = system.pathForFile('entities/' .. name .. '/states', system.ResourceDirectory )

  local states = {}
  for file in lfs.dir( doc_path ) do
    if string.find( file, '.lua' ) then
      file = string.gsub(file, '.lua', '')
      table.insert(states, file)
    end
  end

  local list = {}

  for _, v in pairs(states) do
    list[v] = require('entities.' .. name .. '.states.' .. v):new(ent)
    list[v].name = v
  end

  function list:getState(state)
    return self[state]
  end

  return list
end

return Public
