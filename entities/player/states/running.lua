
local Public = {}
Public.name = 'running'

function Public:update()
  if self.ent.vx == 0 and self.ent.vy == 0 then
    self.ent:setState('stopped')
  end

  if self.ent.attacking then self.ent:setState('attacking') end
end

function Public:start()
end

function Public:exit()
end

return Public