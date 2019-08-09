local dusk = require("Dusk.Dusk")
dusk.setPreference("virtualObjectsVisible", false)
dusk.setPreference("enableObjectCulling", false)
-- dusk.setPreference("enableCameraRounding", true)
dusk.setPreference("cullingMargin", 2)

local Public = {}

function Public.new(mapPath)
  local Map = dusk.buildMap(mapPath)
  Map.cameraScale = 1
  Map.camSpeedSizeMax = 0.016
  Map.camZoomDir = nil

  local padding = 30

  Map.setCameraBounds({
		xMin = display.contentWidth/2 - padding,
		xMax = Map.data.width - display.contentWidth/2 + padding,
		yMin = display.contentHeight/2 - padding,
		yMax = Map.data.height - display.contentHeight/2 + padding
	})

  function Map:moveCamera()
    local camScale = self.cameraScale

    local camSpeedSize
    local dir

    local isPlayerMoving = math.abs(player.vx) > 0 or math.abs(player.vy) > 0
    if not isPlayerMoving then
      camSpeedSize = math.abs(camScale - 1.2) * self.camSpeedSizeMax
      dir = 1
    else
      camSpeedSize = math.abs(camScale - 1) * self.camSpeedSizeMax
      dir = -1
    end

    camScale = camScale * (1 + (dir * camSpeedSize))
    if camSpeedSize < 0.001 then camSpeedSize = 0 end

    if camScale > 1.2 then
      camScale = 1.2
    elseif camScale < 1 then
      camScale = 1
    end

    self.updateView()
    self.xScale, self.yScale = camScale, camScale
    self.cameraScale = camScale

  end


  _G.m.map = Map
end


return Public
