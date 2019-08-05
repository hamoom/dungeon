local Public = {}

function Public.new(group, obj)
  local Spike = display.newCircle(group, obj.x, obj.y, 12)
  Spike.name = 'spike'
  Spike.isAttacking = false

  -- physics.addBody(spike, 'static')
  -- spike.isSensor = true

  function Spike:toggleSpikes()
    self.isAttacking = not self.isAttacking
    if self.isAttacking then
      self.alpha = 1
    else
      self.alpha = 0.2
    end
    _G.m.addTimer(2000, function()
      self:toggleSpikes()
    end)
  end

  function Spike:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  Spike:toggleSpikes()

  return Spike
end


return Public
