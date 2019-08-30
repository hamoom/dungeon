--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b7868dc784d1bed03ce99f99a9193b05:6627410793236b27d2af7a7712a7985b:081054e524172d87a1f61a8d13ca77d3$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- orc1
            x=1,
            y=1,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc2
            x=1,
            y=43,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc3
            x=1,
            y=85,
            width=26,
            height=40,

            sourceX = 17,
            sourceY = 6,
            sourceWidth = 60,
            sourceHeight = 66
        },
        {
            -- orc4
            x=1,
            y=127,
            width=24,
            height=42,

            sourceX = 15,
            sourceY = 7,
            sourceWidth = 60,
            sourceHeight = 66
        },
    },
    
    sheetContentWidth = 28,
    sheetContentHeight = 170
}

SheetInfo.frameIndex =
{

    ["orc1"] = 1,
    ["orc2"] = 2,
    ["orc3"] = 3,
    ["orc4"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
