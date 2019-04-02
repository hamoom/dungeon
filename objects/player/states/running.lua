
local Public = {}
Public.name = 'running'

function Public:update()
  if self.obj.vx == 0 and self.obj.vy == 0 then
    self.obj:setState('stopped')
  end
end

return Public