local m = require("myapp")
local Public = {}

function Public.new(group, obj)
  local spike = display.newCircle(group, obj.x, obj.y, 12)
  spike.name = 'spike'
  spike.isAttacking = false

  -- physics.addBody(spike, 'static')
  -- spike.isSensor = true

  function spike:toggleSpikes()
    self.isAttacking = not self.isAttacking
    if self.isAttacking then
      spike.alpha = 1
    else
      spike.alpha = 0.2
    end
    m.addTimer(2000, function()
      self:toggleSpikes()
    end)
  end

  spike:toggleSpikes()

  return spike
end


return Public
