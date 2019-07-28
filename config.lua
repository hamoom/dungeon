--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--


local aspectRatio = display.pixelWidth / display.pixelHeight
local mult = 10^(2)
local scaleDown = 1.5
aspectRatio = math.floor(aspectRatio * mult + 0.5) / mult

local height = (aspectRatio >= 0.75) and 512 or 568
if (aspectRatio < 0.48) then
  height = 660
end

local width = (aspectRatio >= 0.75) and 384 or 320

 application =
{

	content =
	{
        width = width * scaleDown,
        height = height * scaleDown,
        scale = (aspectRatio >= 0.75) and "letterbox" or "dynamic",
        xAlign = "center",
        yAlign = "center",
        fps = 60,

		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}
