--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:c659599417ba226356e9569d403ec831:27fe00534d1bc7aa9a2390a6e3a7cf98:0cd2e56b2826ccabf498f9136415676c$
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
            -- torch1
            x=0,
            y=38,
            width=10,
            height=17,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 10,
            sourceHeight = 19
        },
        {
            -- torch2
            x=0,
            y=0,
            width=10,
            height=19,

        },
        {
            -- torch3
            x=0,
            y=19,
            width=10,
            height=19,

        },
    },
    
    sheetContentWidth = 10,
    sheetContentHeight = 55
}

SheetInfo.frameIndex =
{

    ["torch1"] = 1,
    ["torch2"] = 2,
    ["torch3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
