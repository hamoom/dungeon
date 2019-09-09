local Public = {}

function Public.new(info, group)
  display.setDefault('textureWrapX', 'repeat')
  display.setDefault('textureWrapY', 'repeat')
  local transitionGroup = display.newGroup()
  group:insert(transitionGroup)

  local borderSize = 64
  local border = display.newRect(transitionGroup, 0, 0, 0, 0)

  if info.direction == 'up' or info.direction == 'down' then
    border.width, border.height = display.contentWidth, borderSize
  else
    border.width, border.height = borderSize, display.contentHeight
  end

  border.anchorX, border.anchorY = 0, 0
  border.fill = {type = 'image', filename = 'graphics/triangle.png'}
  border.fill.scaleX = borderSize / border.width
  border.fill.scaleY = borderSize / border.height

  local square = display.newRect(transitionGroup, 0, 0, display.contentWidth, display.contentHeight)
  square.x, square.y = 0, 0

  local color = 31 / 255
  square:setFillColor(color, color, color)
  square.anchorX, square.anchorY = 0, 0
  local targetX, targetY = transitionGroup.x, transitionGroup.y
  local totalSizeX = display.contentWidth + borderSize
  local totalSizeY = display.contentHeight + borderSize

  if info.transition == 'entering' then
    if info.direction == 'up' then
      border.y = -borderSize
      transitionGroup.y = totalSizeY
    elseif info.direction == 'down' then
      border.yScale = -1
      border.y = totalSizeY
      transitionGroup.y = -totalSizeY
    elseif info.direction == 'right' then
      border.fill.rotation = 90
      border.x = square.width
      transitionGroup.x = -totalSizeX
    elseif info.direction == 'left' then
      border.fill.rotation = -90
      border.x = transitionGroup.x - borderSize
      transitionGroup.x = totalSizeX
    end
  else
    if info.direction == 'up' then
      border.yScale = -1
      border.y = totalSizeY
      targetY = -totalSizeY
    elseif info.direction == 'down' then
      border.y = -borderSize
      targetY = totalSizeY
    elseif info.direction == 'right' then
      border.fill.rotation = -90
      border.x = transitionGroup.x - borderSize
      targetX = totalSizeX
    elseif info.direction == 'left' then
      border.fill.rotation = 90
      border.x = transitionGroup.width
      targetX = -totalSizeX
    end

  end

  transition.moveTo(transitionGroup, {x = targetX, y = targetY, time = 3000, delay = 1000, transition = easing.outSine})

  display.setDefault('textureWrapX', 'clampToEdge')
  display.setDefault('textureWrapY', 'clampToEdge')
end

return Public
