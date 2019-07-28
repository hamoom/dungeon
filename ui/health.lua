local Public = {}

function Public.new()
  local healthBar = display.newGroup()
  local health = 3
  local hearts = {}
  for i = 1, health do
    local heart = display.newRect(healthBar, (i - 1) * 30, 0, 20, 20)
    heart.anchorX = 0
    heart.x = heart.x + 15
    heart:setFillColor(1, 0, 0)
    hearts[#hearts+1] = heart
  end
  return healthBar
end
return Public
