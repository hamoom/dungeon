
local Public = {}
Public.name = 'running'

function Public:update()
  if self.obj.vx == 0 and self.obj.vy == 0 then
    self.obj:setState('stopped')
  end

  if self.obj.attacking then self.obj:setState('attacking') end
end

function Public:start()
end

function Public:exit()
end

return Public