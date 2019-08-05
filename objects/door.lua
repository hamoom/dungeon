local m = require("myapp")
local Public = {}

function Public.new(group, obj)
  local Door = display.newRect(group, obj.x, obj.y, obj.width, obj.height)
  Door.name = 'door'
  Door.isOpen = false

  physics.addBody(Door, 'static')

  function Door:open()
    self:setFillColor(0,0,0)
    self.isOpen = true
  end

  function Door:destroy()
    transition.cancel(self)
    display.remove(self)
  end

  return Door
end


return Public
