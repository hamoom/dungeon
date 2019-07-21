local p = require('lib.point')
local h = require('lib.helper')
local Joystick = {}

function Joystick:new()
  self.group = display.newGroup()

  local screenH = display.actualContentHeight
	self.group.alpha = 0.3
	self.base = display.newCircle(self.group, 70, screenH-50, 40)
	self.knob = display.newCircle(self.group, self.base.x, self.base.y, 25)
	self.knob:setFillColor(1,0,0)
  self.pos = p.new(0,0)

  return self
end

function Joystick:moved(x, y)

  self.pos
    :setPosition(x, y)
    :subtract(self.base)


  local length = self.pos:length()
  local maxDist = 40
  local adjustedLength = h.clamp(length, 0, maxDist)

  self.knob.x, self.knob.y = self.pos
                              :normalized()
                              :multiply(adjustedLength)
                              :getPosition()

  self.knob.x = self.knob.x + self.base.x
  self.knob.y = self.knob.y + self.base.y

  if length > maxDist then
    local lengthDiff = length - adjustedLength

  self.pos:
    normalized():
    multiply(lengthDiff, lengthDiff)
  end


end

function Joystick:stopped()
  self.knob.x, self.knob.y = self.base.x, self.base.y
  self.pos:setPosition(0,0)
end

return Joystick
