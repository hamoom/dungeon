local widget = require('widget')

local Controls = {}

function Controls:new()
  if not self.created then
    self = display.newGroup()
    self.joystick = require('ui.joystick').new()
    self.health = require('ui.health').new()

    self:insert(self.joystick)
    self:insert(self.health)

    -----------------------------
    -- Attack Button
    -----------------------------
    self.attackBtn = widget.newButton({
  		width = 140,
  		height = 110,
  		onPress = function(event)
        if self.attackBtnFn then self.attackBtnFn(event) end
      end
  	})

    local attackBtn = self.attackBtn
  	attackBtn.x = display.contentWidth - 140
  	attackBtn.y = display.contentHeight - 80
  	self:insert(attackBtn)

  	attackBtn.visual = display.newRect(self, attackBtn.x, attackBtn.y, attackBtn.width, attackBtn.height)
  	attackBtn.visual.alpha = 0.4

    -----------------------------
    -- Dash Button
    -----------------------------
  	self.dashBtn = widget.newButton({
  		width = 140,
  		height = 110,
  		onPress = function(event)
        if self.dashBtnFn then self.dashBtnFn(event) end
      end
  	})
    local dashBtn = self.dashBtn

  	dashBtn.x = display.contentWidth - 140
  	dashBtn.y = attackBtn.y - 140
  	self:insert(dashBtn)

  	dashBtn.visual = display.newRect(self, dashBtn.x, dashBtn.y, dashBtn.width, dashBtn.height)
  	dashBtn.visual.alpha = 0.4

    -----------------------------
    -- Pause Button
    -----------------------------
    self.pauseButton = widget.newButton({
  			x = display.contentWidth-40,
  			y = 30,
  			width = 30,
  			height = 30,
  			shape = "rect",
  			onPress = function(event)
          if self.pauseBtnFn then self.pauseBtnFn(event) end
        end
  	})
    local pauseButton = self.pauseButton

  	pauseButton:setFillColor(1,1,1)
  	self:insert(pauseButton)

    self.created = true
  end

  return self
end


function Controls:remove()
  display.remove(self)
  self.created = false
end



return Controls
