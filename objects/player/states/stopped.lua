local Public = {}
Public.name = 'stopped'

function Public:update()

  if self.obj.vx > 0 or self.obj.vy > 0 then
    self.obj:setState('running')
  end


end

return Public