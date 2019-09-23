--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:73027d283bbb0d5f3ce813f7e9ca97c4:5c4959d9e3b2b8e04b8c271984d148f9:8727885a87035ca14fac084e838aa381$
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
            -- blood1
            x=75,
            y=1,
            width=28,
            height=29,

            sourceX = 6,
            sourceY = 2,
            sourceWidth = 38,
            sourceHeight = 39
        },
        {
            -- blood2
            x=41,
            y=1,
            width=32,
            height=35,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 38,
            sourceHeight = 39
        },
        {
            -- blood3
            x=1,
            y=1,
            width=38,
            height=39,

        },
    },
    
    sheetContentWidth = 104,
    sheetContentHeight = 41
}

SheetInfo.frameIndex =
{

    ["blood1"] = 1,
    ["blood2"] = 2,
    ["blood3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
