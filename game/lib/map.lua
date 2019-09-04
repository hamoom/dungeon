local mabs = math.abs
local dusk = require("Dusk.Dusk")
dusk.setPreference("virtualObjectsVisible", false)
dusk.setPreference("enableObjectCulling", false)
-- dusk.setPreference("enableCameraRounding", true)
dusk.setPreference("cullingMargin", 2)

local Public = {}

function Public.new(mapPath)
  local Map = dusk.buildMap(mapPath)
  Map.cameraScale = 1.2
  Map.camSpeedSizeMax = 0.016
  Map.camZoomDir = nil

  local padding = 100

  Map.setCameraBounds({
		xMin = display.contentWidth/2 - padding,
		xMax = Map.data.width - display.contentWidth/2 + padding,
		yMin = display.contentHeight/2 - padding,
		yMax = Map.data.height - display.contentHeight/2 + padding
	})

  function Map:moveCamera(player)
    local camScale = self.cameraScale

    local camSpeedSize
    local dir
    -- local vx, vy = player:getLinearVelocity()
    -- local isPlayerMoving = mround(mabs(vx)) > 0 or mround(mabs(vy)) > 0
    local isPlayerMoving = math.abs(player.vx) > 0 or math.abs(player.vy) > 0

    -- print(isPlayerMoving, math.abs(player.vx),  math.abs(player.vy))
    if not isPlayerMoving or player.state.name == 'death' then
      camSpeedSize = mabs(camScale - 1.5) * self.camSpeedSizeMax
      dir = 1
    else
      camSpeedSize = mabs(camScale - 1.2) * self.camSpeedSizeMax
      dir = -1
    end

    camScale = camScale * (1 + (dir * camSpeedSize))
    -- print(camScale)
    if camScale > 1.5 then
      camScale = 1.5
    elseif camScale < 1.2 then
      camScale = 1.2
    end

    self.updateView()
    self.xScale, self.yScale = camScale, camScale
    self.cameraScale = camScale

  end


  _G.m.map = Map
end


return Public
