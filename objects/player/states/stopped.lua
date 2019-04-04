local Public = {}
Public.name = 'stopped'

function Public:update()

  if self.obj.vx > 0 or self.obj.vy > 0 then
    self.obj:setState('running')
  end

  if self.obj.attacking then self.obj:setState('attacking') end


end

function Public:start()
end

function Public:exit()
end

return Public