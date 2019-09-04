local Public = {}

function Public.new()
  local joystick = display.newGroup()
  joystick.isActive = false

  function joystick:moved(x, y)
    joystick.pos:setPosition(x, y):subtract(self)

    local length = self.pos:length()
    local maxDist = 40
    local adjustedLength = _G.h.clamp(length, 0, maxDist)

    self.knob.x, self.knob.y = self.pos:normalized():multiply(adjustedLength):getPosition()

    if length > maxDist then
      local lengthDiff = length - adjustedLength

      self.pos:normalized():multiply(lengthDiff, lengthDiff)

      self.x, self.y = _G.p.new(self):add(self.pos):getPosition()
    end
  end

  function joystick:makeJoystick()
    self.isActive = true
    self.pos:setPosition(0, 0)
    transition.to(self, {alpha = 0.7, time = 500})
  end

  function joystick:stop()
    self.isActive = false
    self.knob.x, self.knob.y = self.base.x, self.base.y
    self.pos:setPosition(0, 0)
    transition.fadeOut(self, {time = 500})
  end

  joystick.alpha = 0
  joystick.base = display.newCircle(joystick, 0, 0, 40)
  joystick.knob = display.newCircle(joystick, 0, 0, 25)
  joystick.knob:setFillColor(1, 0, 0)
  joystick.pos = _G.p.new(0, 0)
  return joystick
end

return Public
