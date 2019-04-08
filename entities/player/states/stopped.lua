local Public = {}
Public.name = 'stopped'

function Public:update()

  if self.ent.vx > 0 or self.ent.vy > 0 then
    self.ent:setState('running')
  end

  if self.ent.attacking then self.ent:setState('attacking') end


end

function Public:start()
end

function Public:exit()
end

return Public