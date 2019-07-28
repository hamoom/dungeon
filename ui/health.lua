local Public = {}

function Public.new()
  local healthBar = display.newGroup()
  healthBar.x, healthBar.y = 10, 20

  function healthBar:clearAll()

    for i = self.numChildren, 1, -1 do
      self[i]:removeSelf()
      self[1] = nil
    end

  end

  function healthBar:setHealth(num)
    self:clearAll()

    if num > 0 then
      for i = 1, num do
        local heart = display.newRect(self, (i - 1) * 30, 0, 20, 20)
        heart.anchorX = 0
        heart.x = heart.x + 15
        heart:setFillColor(1, 0, 0)
      end
    end
  end

  local function setHealth(event)
    healthBar:setHealth(event.params.health)
  end

  function healthBar:destroy()
    Runtime:removeEventListener('changeHealth', setHealth)
  end

  Runtime:addEventListener('changeHealth', setHealth)

  return healthBar

end

return Public
